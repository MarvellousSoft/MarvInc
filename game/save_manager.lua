local LoreManager = require "classes.lore_manager"
local BotManager = require 'classes.bot'
binser = require "binser"

local sm = {}
local f = love.filesystem -- used a lot
sm.user_data = {}

-- used to improve compatibilty
local current_save_version = "1"

function sm.base_user_save(user)
    if not f.exists('saves/' .. user) then
        f.createDirectory('saves/'.. user)
        f.write('saves/' .. user .. '/version', current_save_version)
    end
end

function sm.save()
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
        local handle = next(LoreManager.timer.functions)
        LoreManager.timer.functions[handle] = nil -- removes from timer
        handle.after(handle.after) -- calls function manually
        -- rinse and repeat until there are no more events (even if one creates another)
    end

    data.puzzle_done = LoreManager.puzzle_done
    data.done_events = LoreManager.done_events

    -- saving emails
    data.emails = {}
    for _, email in ipairs(Util.findId('email_tab').email_list) do
        table.insert(data.emails, {id = email.id, read = email.was_read, can_reply = email.can_reply})
    end


    -- Other stuff
    local info = Util.findId('info_tab')
    data.known_commands = info.commands
    data.bots_dead = info.dead
    data.last_bot = BotManager.current_bot

    data.employee_id = EMPLOYEE_NUMBER
    -- whether to draw star on the corner of the screen
    data.draw_star = ROOM.draw_star
    -- Marvellous OS version
    data.os_version = ROOM.version
    --------------------

    f.write('saves/' .. user .. '/save_file', binser.serialize(data))

    if ROOM:connected() then
        sm.save_code(ROOM.puzzle_id, table.concat(Util.findId("code_tab"):getLines(), "\n"))
    end
end

function sm.login(user)
    if sm.current_user then sm.logout() end
    sm.current_user = user
    local data = sm.user_data[user]
    if data then
        EMPLOYEE_NUMBER = data.employee_id

        LoreManager.puzzle_done = data.puzzle_done
        LoreManager.set_done_events(data.done_events)

        -- loading emails
        for _, email in ipairs(data.emails) do
            local e = Mail.new(email.id, true)
            e.was_read = email.read
            e.can_reply = email.can_reply
        end

        -- Other stuff
        local info = Util.findId('info_tab')
        info.commands = data.known_commands
        info.dead = data.bots_dead
        BotManager.current_bot = data.last_bot

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

function sm.load()
    if not f.exists("README") then
        f.write("README", [[
This is Marvellous Inc's save directory.

Feel free to mess up the files here, but if the game crashes it is not our responsability :)]])
    end
    if not f.exists("saves") then
        f.createDirectory("saves")
    end
    for _, user in pairs(f.getDirectoryItems("saves")) do
        if f.exists('saves/' .. user .. '/save_file') then
            local ver = f.read('saves/' .. user .. '/version')
            if ver ~= current_save_version then
                -- deal with old save versions
            end
            sm.user_data[user] = binser.deserializeN(f.read('saves/' .. user .. '/save_file'), 1)
        end
    end
end

function sm.load_code(puzzle)
    local filename = 'saves/' .. sm.current_user .. '/' .. puzzle .. '.code'
    if f.exists(filename) then return f.read(filename) end
end

function sm.save_code(puzzle, str)
    sm.base_user_save(sm.current_user)
    local filename = 'saves/' .. sm.current_user .. '/' .. puzzle .. '.code'
    f.write(filename, str)
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
