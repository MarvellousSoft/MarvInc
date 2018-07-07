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
local _old_state

-- Warning Window State  --

function state:enter(old_state, title, message, buttonlist, dont_pop)
    _old_state = old_state

    _dont_pop = dont_pop
    _window = WarningWindow.create(title,message,buttonlist)

end

function state:update(dt)

end

function state:draw()
    _old_state:draw()

    _window:draw()

end

function state:mousepressed(x, y)
    for _,but in ipairs(_window.buttons) do
        if but:checkCollides(x,y) then
            WarningWindow.deactivate(_dont_pop)
        end
    end
end

function state:keypressed(key)
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
    elseif key == "escape" and _window.escape and _window.buttons[_window.escape] then
        _window.buttons[_window.escape]:callback()
        WarningWindow.deactivate(_dont_pop)
    elseif (key == "return" or key == "kpenter") and _window.enter and _window.buttons[_window.enter] then
        _window.buttons[_window.enter]:callback()
        WarningWindow.deactivate(_dont_pop)
    end
end

function state:leave()
    _window:destroy()

end

return state
