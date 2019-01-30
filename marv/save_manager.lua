--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local LoreManager = require "classes.lore_manager"
local BotManager = require 'classes.bot'
local LParser = require "lparser.parser"
binser = require "binser"

local sm = {}
local f = love.filesystem -- used a lot
sm.user_data = {}

-- used to improve compatibilty
local current_common_version = "1"
local current_save_version = "3"

function sm.base_user_save(user)
    if not f.exists('saves/' .. user) then
        f.createDirectory('saves/'.. user)
    end
    if not f.exists('saves/' .. user .. '/custom_puzzles') then
        f.createDirectory('saves/' .. user .. '/custom_puzzles')
    end
    f.write('saves/' .. user .. '/version', current_save_version)
end

function sm.common_save()
    local data = {}

    f.write('version', current_common_version)

    data.sound_effect_mod = SOUND_EFFECT_MOD
    data.music_mod = MUSIC_MOD

    data.fullscreen = love.window.getFullscreen()

    f.write('config', binser.serialize(data))
end

function sm.save()
    sm.common_save()
    local user = sm.current_user
    if not user then return end
    sm.base_user_save(user)
    local data = {}

    -- DATA TO BE SAVED

    -- LoreManager stuff

    -- we will first trigger all events made by lore events
    -- assumes all events are created with 'after'
    -- checkout hump/timer.lua for better understanding :)
    while next(LoreManager.timer.functions) do
        local handle = nil

        -- chooses the next handle that would be triggered
        for h in pairs(LoreManager.timer.functions) do
            if not handle or h.limit - h.time < handle.limit - handle.time then
                handle = h
            end
        end

        LoreManager.timer.functions[handle] = nil -- removes from timer
        handle.after(handle.after) -- calls function manually
        -- rinse and repeat until there are no more events (even if one creates another)
    end

    data.puzzle_done = LoreManager.puzzle_done
    data.done_events = LoreManager.done_events

    -- saving emails
    data.emails = {}
    for _, email in ipairs(Util.findId('email_tab').email_list) do
        table.insert(data.emails, {
            id = email.id,
            read = email.was_read,
            can_reply = email.can_reply,
            can_be_deleted = email.can_be_deleted,
            time_received = email.time,
            custom = email.is_custom
        })
    end


    -- Other stuff
    local info = Util.findId('info_tab')
    local manual = Util.findId('manual_tab')
    data.known_commands = manual.cmds
    data.bots_dead = info.dead
    data.last_bot = BotManager.current_bot
    data.block_extra_bot_messages = SideMessage.block_extra_bot_messages
    data.block_intro_bot_messages = SideMessage.block_intro_bot_messages
    data.static_screen = SETTINGS["static"]

    data.employee_id = EMPLOYEE_NUMBER
    data.achievement_progress = ACHIEVEMENT_PROGRESS

    -- whether to draw star on the corner of the screen
    data.draw_star = ROOM.draw_star
    -- Marvellous OS version
    data.os_version = ROOM.version
    --------------------

    f.write('saves/' .. user .. '/save_file', binser.serialize(data))

    if ROOM:connected() then
        Util.findId('code_tab'):saveCurrentCode()
    end
end

function sm.login(user)
    if sm.current_user then sm.logout() end
    sm.current_user = user
    local data = sm.user_data[user]
    if data then
        EMPLOYEE_NUMBER = data.employee_id

        --Load achievements
        AchManager.load(data.achievement_progress)

        LoreManager.puzzle_done = data.puzzle_done
        LoreManager.set_done_events(data.done_events)

        -- loading emails
        for _, email in ipairs(data.emails) do
            local e
            if email.custom then
                e = LParser.load_email(email.id)
            else
                e = Mail.new(email.id, true)
            end
            if e then
                e.was_read = email.read
                e.can_reply = email.can_reply
                e.can_be_deleted = email.can_be_deleted
                e.time = email.time_received
            end
        end
        -- load custom emails
        if love.filesystem.exists("custom") then
            local list = {}
            for _, file in ipairs(love.filesystem.getDirectoryItems("custom")) do
                if love.filesystem.isFile("custom/"..file.."/email.lua") then
                    LParser.load_email(file)
                end
            end
        end
        UNREAD_EMAILS = Mail.getUnreadEmails() --Update UNREAD_EMAILS variable

        -- Other stuff
        local info = Util.findId('info_tab')
        local manual = Util.findId('manual_tab')
        for _, item in ipairs(data.known_commands) do
            manual:addCommand(item)
        end
        info.dead = data.bots_dead
        BotManager.current_bot = data.last_bot
        SideMessage.block_extra_bot_messages = data.block_extra_bot_messages
        SideMessage.block_intro_bot_messages = data.block_intro_bot_messages
        SETTINGS["static"] = data.static_screen
        MISC_IMG["static"] = MISC_IMG[data.static_screen] or MISC_IMG.reg_static

        ROOM.draw_star = data.draw_star
        ROOM.version = data.os_version
    else
        -- without save
    end
    LoreManager.check_all()

end

function sm.logout()
    assert(sm.current_user)
    sm.save()
    sm.current_user = nil
end

function sm.common_load()
    if not f.exists('config') then return end
    local ver = f.read('version')
    if ver ~= current_common_version then
        print('Unrecognized common save version')
        -- deal with old save versions
    end

    local data = binser.deserializeN(f.read('config'), 1)

    MUSIC_MOD = data.music_mod
    SOUND_EFFECT_MOD = data.sound_effect_mod

    love.window.setFullscreen(data.fullscreen, 'desktop')
end

function sm.load()
    if not f.exists("README") then
        f.write("README", [[
This is Marvellous Inc's save directory.

Feel free to mess up the files here, but if the game crashes it is not our responsability :)]])
    end
    sm.common_load()
    if not f.exists("saves") then
        f.createDirectory("saves")
    end
    local uppercase_users = {}
    for _, user in pairs(f.getDirectoryItems("saves")) do
        --Check for user with uppercase letters
        if string.match(user, "[A-Z]") then
            table.insert(uppercase_users,user)
        end
        if f.exists('saves/' .. user .. '/save_file') then
            local ver = f.read('saves/' .. user .. '/version')
            sm.user_data[user] = binser.deserializeN(f.read('saves/' .. user .. '/save_file'), 1)
            if ver == "1" then -- 1 --> 2
                local bot = sm.user_data[user].last_bot
                if bot then
                    bot.hair_i = love.math.random(#HAIR)
                    bot.hair_clr = Color.new(love.math.random(256) - 1, 200, 200)
                    bot.head_clr = Color.rand_skin()
                    bot.body_clr = Color.new(love.math.random(256) - 1, 200, 200)
                end
                ver = "2"
            end
            if ver == "2" then -- 2 --> 3
                sm.user_data[user].static_screen = "reg_static"
                ver = "3"
            end
            if ver ~= current_save_version then
                -- deal with old save versions
            end
            if not f.exists("saves/".. user .. "/custom_puzzles") then
                f.createDirectory("saves/".. user .. "/custom_puzzles")
            end
        end
    end

    --Handle warning if there is users with uppercase
    local uppercase_users_warning = false
    if #uppercase_users > 0 then
        uppercase_users_warning = true

        local users = '"'..uppercase_users[1]..'"'
        for i = 2, #uppercase_users do
            local separator = (i == #uppercase_users) and " and " or ", "
            users = users..separator..'"'..uppercase_users[i]..'"'
        end

        local plural = #uppercase_users > 1 and "s" or ""
        local title = "Warning: Username"..plural.." with uppercase letters"
        local message = "The username"..plural.." "..users.." contains uppercase letters, and we no longer support this type of username since it can create conflicts on certain OS. Please rename the user folder"..plural.." in the save directory folder so you can access it and supress this warning."
        Gamestate.switch(GS.BLANK)
        WarningWindow.show(title, message, {"OKAY", function()Gamestate.switch(SKIP_SPLASH and GS.MENU or GS.SPLASH)end, enter = 1, escape = 1}, true)
    end

    return uppercase_users_warning
end

function sm.load_code(puzzle, is_custom)
    local code, rnm = "", {}
    local basename
    if not is_custom then
        basename = 'saves/' .. sm.current_user .. '/' .. puzzle
    else
        basename = 'saves/' .. sm.current_user .. '/custom_puzzles/' .. puzzle
    end
    if f.exists(basename .. '.code') then code = f.read(basename .. '.code') end
    if f.exists(basename .. '.renames') then
        for line in f.read(basename .. '.renames'):gmatch("[^\n]+") do
            num, str = line:match("^([%d]+)=([%a]+)$")
            if tonumber(num) and str then
                rnm[str] = tonumber(num)
            end
        end
    end
    return code, rnm
end

function sm.save_code(puzzle, str, renames, is_custom)
    sm.base_user_save(sm.current_user)
    local basename
    if not is_custom then
        basename = 'saves/' .. sm.current_user .. '/' .. puzzle
    else
        basename = 'saves/' .. sm.current_user .. '/custom_puzzles/' .. puzzle
    end
    f.write(basename .. '.code', str)
    local rnm = ""
    for str, num in pairs(renames) do
        rnm = rnm .. (num .. '=' .. str) .. '\n'
    end
    if rnm:len() > 0 then
        f.write(basename .. '.renames', rnm)
    end
end

-- returns whether saving would trigger unwanted events
function sm.safeToSave()
    return not next(LoreManager.timer.functions)
end

local function recDelete(file)
    if f.isDirectory(file) then
        for _, child in ipairs(f.getDirectoryItems(file)) do
            recDelete(file .. '/' .. child)
        end
    end
    love.filesystem.remove(file)
end

function sm.deleteUser(user)
    recDelete('saves/' .. user)
    sm.user_data[user] = nil
end

return sm
