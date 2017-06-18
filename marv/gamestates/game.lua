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

-- DONT USE LEAVE BEFORE FIXING THIS
-- see what should be on init and what should be on enter
function state:init()
    room = Rooms.create()
    pc_box = PcBox.create()

    LoreManager.init()
    FX.intro()

    -- autosave every 2 min
    -- in case of a crash or something
    -- WARNING: saving may trigger unwanted events so we have to handle that case
    Timer.after(120, function(itself)
        if SaveManager.safeToSave() then
            SaveManager.save()
            Timer.after(120, itself)
        else
            Timer.after(10, itself)
        end
    end)
end

function state:enter(prev, user)
    SaveManager.login(user)
end

function state:leave()

end


function state:update(dt)
    Util.updateSubTp(dt, "gui")
    Util.destroyAll()

    pc_box:update(dt)
    room:update(dt)
    StepManager.update(dt)
    LoreManager.update(dt)

    Util.updateTimers(dt)
end

function state:draw()
    FX.pre_draw()
    Draw.allTables()
    FX.post_draw()
end

function state:keypressed(key)
    PopManager.keypressed(key)
    if EVENTS_LOCK > 0 then return end

    Util.defaultKeyPressed(key)
    pc_box:keyPressed(key)
    room:keyPressed(key)

    if key == 'f12' then
        -- add something to test the game
    end
end

function state:mousepressed(x, y, but)
    if EVENTS_LOCK > 0 then return end

    pc_box:mousePressed(x,y,but)

end

function state:mousereleased(x, y, button, touch)
    PopManager.mousereleased(x, y, button, touch)
    pc_box:mouseReleased(x, y, button)
end

function state:mousemoved(x, y)
    pc_box:mouseMoved(x, y)
end

function state:textinput(t)
    if EVENTS_LOCK > 0 then return end

    pc_box:textInput(t)
end

function state:wheelmoved(x, y)
    if EVENTS_LOCK > 0 then return end

    pc_box:mouseScroll(x, y)
end

--Return state functions
return state
