local Rooms = require "classes.room"
local PcBox = require "classes.pc-box"
local Button = require "classes.button"
local Mail = require "classes.tabs.email"

--MODULE FOR THE GAMESTATE: GAME--

local state = {}
local pc_box
local room

function state:enter()
    room = Rooms.create()
    pc_box = PcBox.create()
end

function state:leave()

end


function state:update(dt)
    Util.updateSubTp(dt, "gui")
    Util.destroyAll()

    pc_box:update(dt)

    Util.updateTimers(dt)
end

function state:draw()
    Draw.allTables()
end

function state:keypressed(key)

    if key == 'f2' then
        Mail.new("titulo", "blablabla", "ernesto")
    else
        Util.defaultKeyPressed(key)
        pc_box:keyPressed(key)
        room:keyPressed(key)
    end

end

function state:mousepressed(x, y, but)

    pc_box:mousePressed(x,y,but)
    
end

function state:textinput(t)
    pc_box:textInput(t)
end

--Return state functions
return state
