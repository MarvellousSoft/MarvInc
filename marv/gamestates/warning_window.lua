--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local Timer = require "extra_libs.hump.timer"
local FX = require "classes.fx"
local state = {}

--Local variables

local _window
local _dont_pop

-- Warning Window State  --

function state:enter(old_state, title, message, buttonlist, dont_pop)

    _dont_pop = dont_pop
    _window = WarningWindow.create(title,message,buttonlist)

end

function state:update(dt)

end

function state:draw()

    Draw.allTables()

end

function state:mousepressed(x, y)
    for _,but in ipairs(_window.buttons) do
        if but:checkCollides(x,y) then
            WarningWindow.deactivate(_dont_pop)
        end
    end
end

function state:keypressed(key)
    if key == "escape" then
        Gamestate.pop()
    end
end

function state:leave()
    _window:destroy()

end

return state
