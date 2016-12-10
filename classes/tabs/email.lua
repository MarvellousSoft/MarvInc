require "classes.primitive"
local Color = require "classes.color.color"
require "classes.tabs.tab"
-- EMAIL TAB CLASS--

EmailTab = Class{
    __includes = {Tab},

    init = function(self, color, eps, dy)
        Tab.init(self, color, eps, dy)

        self.tp = "email_tab"
    end
}
