require "classes.primitive"
local Color = require "classes.color.color"
-- TAB CLASS--

Tab = Class{
    __includes = {RECT},

    init = function(self, eps, dy)
        local b = WIN_BORD

        RECT.init(self, b + eps, b + eps + dy, W - H - b - 2 * eps, H - 2 * b - 2 * eps - dy,
        Color.transp())

        self.tp = "tab"
    end
}

function Tab:draw()

end

function Tab:update()

end

function Tab:activate()

end

function Tab:deactivate()

end

function Tab:keyPressed(key)

end

function Tab:textInput(t)

end
