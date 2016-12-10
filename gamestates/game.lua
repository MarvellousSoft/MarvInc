local Util = require "util"
local Draw = require "draw"
local Rooms = require "classes.room"
local PcBox = require "classes.pc-box"
local Button = require "classes.button"

--MODULE FOR THE GAMESTATE: GAME--

local state = {}
local kill

function state:enter()
    Rooms.create()
    PcBox.create()
    kill = Button.create_gui(10, 10, 100, 100, function() print "hey" end, "hey", FONTS.fira(20))
end

function state:leave()

end


function state:update(dt)

    Util.updateSubTp(dt, "gui")
    Util.destroyAll()

end

function state:draw()

    Draw.allTables()

end

function state:keypressed(key)

    Util.defaultKeyPressed(key)

end

--Return state functions
return state
