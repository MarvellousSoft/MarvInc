require "classes.primitive"
local Color = require "classes.color.color"
require "classes.tabs.tab"

-- INFO TAB CLASS--

InfoTab = Class{
    __includes = {Tab},

    init = function(self, eps, dy)
        Tab.init(self, eps, dy)

        self.main_color =  Color.new(150, 200, 120)
        self.tp = "info_tab"
    end
}

function InfoTab:draw()
    local t

    t = self

    Color.set(t.main_color)

    love.graphics.rectangle("fill", t.pos.x, t.pos.y, t.w, t.h)
end
