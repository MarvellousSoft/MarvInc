require "classes.primitive"
local Color = require "classes.color.color"
-- CODE TAB CLASS--

Code_Tab = Class{
    __includes = {RECT},

    init = function(self)
        local b = 20, color

        color = Color.green() -- Color of this tab
        RECT.init(self, b, b, W - H - b, H - 2 * b, Color.red())

        self.tp = "email_tab"
    end
}

function Code_Tab:draw()
    local tab

    tab = self

    Color.set(tab.color)
    love.graphics.rectangle("fill", tab.pos.x, tab.pos.y, tab.w, tab.h)

end

function Code_Tab:update()

end
