--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

require "classes.primitive"
local Color = require "classes.color.color"
-- TAB CLASS--

Tab = Class{
    __includes = {RECT},

    button_color = 0,

    init = function(self, eps, dy)
        local b = WIN_BORD

        RECT.init(self, b + eps, b + eps + dy, W - H - b - 2 * eps, H - 2 * b - 2 * eps - dy,
        Color.transp())

        self.tp = "tab"
    end
}

function Tab:draw()

end

function Tab:update(dt)

end

function Tab:activate()

end

function Tab:deactivate()

end

function Tab:keyPressed(key)

end

function Tab:textInput(t)

end

function Tab:mousePressed(x, y, but)

end

function Tab:mouseReleased(x, y, but)

end

function Tab:mouseScroll(x, y)

end

function Tab:mouseMoved(x, y)

end

function Tab:preload()

end
