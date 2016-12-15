local Color = require "classes.color.color"

local Rooms = require "classes.room"
local PcBox = require "classes.pc-box"
local Button = require "classes.button"
local Mail = require "classes.tabs.email"
local LoreManager = require "classes.lore-manager"
local PopManager = require "classes.popmanager"
local FX = require "classes.fx"

--MODULE FOR THE GAMESTATE: GAME--

local state = {}
local pc_box
local room

-- DONT USE LEAVE BEFORE FIXING THIS
function state:enter()

    room = Rooms.create()
    pc_box = PcBox.create()

    LoreManager.begin()
    FX.intro()
end

function state:leave()

end


function state:update(dt)
    Util.updateSubTp(dt, "gui")
    Util.destroyAll()

    pc_box:update(dt)
    room:update(dt)
    StepManager:update(dt)
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
    if EVENTS_LOCK then return end

    Util.defaultKeyPressed(key)
    pc_box:keyPressed(key)
    room:keyPressed(key)

end

function state:mousepressed(x, y, but)
    if EVENTS_LOCK then return end

    pc_box:mousePressed(x,y,but)

end

function state:mousereleased(x, y, button, touch)
    PopManager.mousereleased(x, y, button, touch)
end

function state:textinput(t)
    if EVENTS_LOCK then return end

    pc_box:textInput(t)
end

function state:wheelmoved(x, y)
    if EVENTS_LOCK then return end

    pc_box:mouseScroll(x, y)
end

--Return state functions
return state
