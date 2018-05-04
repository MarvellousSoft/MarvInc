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
local WarnWindow = require "classes.warning_window"
local state = {}

local _coroutine
local _window
-- Warning Window State  --

function state:enter(old_state, title, message, buttonlist)

    _window = WarnWindow.create(title,message,buttonlist)
    
end

function state:update(dt)

end

function state:draw()

    Draw.allTables()

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
