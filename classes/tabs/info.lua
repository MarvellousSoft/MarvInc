require "classes.primitive"
local Color = require "classes.color.color"
--INFO TAB CLASS--

InfoTab = Class{
    __includes = {RECT},

    init = function(self)
        local b = 20, color

        color = Color.orange() -- Color of this tab
        RECT.init(self, b, b, W - H - b, H - 2 * b, Color.red())

        self.tp = "info_tab"
    end
}

function InfoTab:draw()
    local tab

    tab = self

    Color.set(tab.color)
    love.graphics.rectangle("fill", tab.pos.x, tab.pos.y, tab.w, tab.h)

end

function InfoTab:update()

end

function InfoTab:activate()

end

function InfoTab:deactivate()

end
