--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local Color = require "classes.color.color"

local Rooms = require "classes.room"
local PcBox = require "classes.pc_box"
local Button = require "classes.button"
local Mail = require "classes.tabs.email"
local LoreManager = require "classes.lore_manager"
local PopManager = require "classes.pop_manager"
local FX = require "classes.fx"

--MODULE FOR THE GAMESTATE: GAME--

local state = {}
local pc_box
local room
local bgmmanager

-- DONT USE LEAVE BEFORE FIXING THIS
-- see what should be on init and what should be on enter
function state:init()
    room = Rooms.create()
    pc_box = PcBox.create()
    bgmmanager = BGMManager()
    LoreManager.init()
    FX.intro()

    -- autosave every 2 min
    -- in case of a crash or something
    -- WARNING: saving may trigger unwanted events so we have to handle that case
    MAIN_TIMER:after(120, function(itself)
        if SaveManager.safeToSave() then
            print("Autosaving...")
            SaveManager.save()
            MAIN_TIMER:after(120, itself)
        else
            print("Not safe to autosave now. Scheduling for later...")
            MAIN_TIMER:after(10, itself)
        end
    end)
end

function state:getRoom()
    return room
end

function state:getBGMManager()
    return bgmmanager
end


function state:enter(prev, user)
    SaveManager.login(user)
    SettingsTab:refresh()
    AchManager.checkAchievements()
    bgmmanager:newBGM()

    if START_PUZZLE then
        ROOM:connect(START_PUZZLE, nil, START_PUZZLE_CUSTOM)
    end
end

function state:resume()
    AchManager.checkAchievements()
end

function state:leave()

end


function state:update(dt)
    Util.updateSubTp(dt, "gui")
    Util.destroyAll()

    pc_box:update(dt)
    room:update(dt)
    bgmmanager:update(dt)
    StepManager.update(dt)
    LoreManager.update(dt)

    MAIN_TIMER:update(dt)
    AUDIO_TIMER:update(dt)
end

function state:draw()
    FX.pre_draw()
    Draw.allTables()
    FX.post_draw()
end

function state:keypressed(key)
    if IS_EXITING then return end
    --Toggle fullscreen
    if key == 'f11' then
        if not love.window.getFullscreen() then
            PREV_WINDOW = {love.window.getMode()}
            love.window.setFullscreen(true, "desktop")
            love.resize(love.window.getMode())
        else
            love.window.setFullscreen(false, "desktop")
            if PREV_WINDOW then
                love.window.setMode(unpack(PREV_WINDOW))
            end
            love.resize(love.window.getMode())
        end
        local set = Util.findId("settings_tab")
        if set then set:refresh() end
    end
    PopManager.keypressed(key)
    if EVENTS_LOCK > 0 then return end

    Util.defaultKeyPressed(key)
    pc_box:keyPressed(key)
    room:keyPressed(key)

    if key == 'f12' then
        --Mail.new('ryr')
    end
end

function state:mousepressed(x, y, but)
    if EVENTS_LOCK > 0 or IS_EXITING then return end

    pc_box:mousePressed(x,y,but)
    room:mousePressed(x, y, but)

    --Pass mouse-click to side messages
    if but == 1 then
        local side_messages = Util.findSbTp("side_message")
        if side_messages then
            for message in pairs(side_messages) do
                message:mousepressed(x,y)
            end
        end
    end

end

function state:mousereleased(x, y, button, touch)
    if IS_EXITING then return end
    PopManager.mousereleased(x, y, button, touch)
    pc_box:mouseReleased(x, y, button)
end

function state:mousemoved(...)
    if IS_EXITING then return end
    pc_box:mouseMoved(...)
    room:mouseMoved(...)
end

function state:textinput(t)
    if EVENTS_LOCK > 0 or IS_EXITING then return end

    pc_box:textInput(t)
end

function state:wheelmoved(x, y)
    if EVENTS_LOCK > 0 or IS_EXITING then return end

    pc_box:mouseScroll(x, y)
end

--Return state functions
return state
