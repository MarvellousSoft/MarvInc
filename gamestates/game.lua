local Rooms = require "classes.room"
local PcBox = require "classes.pc-box"
local Button = require "classes.button"
local Mail = require "classes.tabs.email"

--MODULE FOR THE GAMESTATE: GAME--

local state = {}
local pc_box

function state:enter()
    Rooms.create()
    pc_box = PcBox.create()
end

function state:leave()

end


function state:update(dt)
    Util.updateSubTp(dt, "gui")
    Util.destroyAll()

    Util.updateTimers(dt)
end

function state:draw()
    Draw.allTables()
end

function state:keypressed(key)

    if key == 'f2' then
        Mail.new("Título imponente e legal", "blablabla", "Ernesto B.")
    else
        Util.defaultKeyPressed(key)
        pc_box:keyPressed(key)
    end

end

function state:textinput(t)
    pc_box:textInput(t)
end

--Return state functions
return state
