require "classes.primitive"
local Color = require "classes.color.color"
require "classes.tabs.tab"
-- Info TAB CLASS--

InfoTab = Class{
    __includes = {Tab},

    init = function(self, color, eps, dy)
        Tab.init(self, color, eps, dy)

        self.tp = "info_tab"
    end
}

function InfoTab:draw()
    Color.set(Color.red())
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.w, self.h)
end
