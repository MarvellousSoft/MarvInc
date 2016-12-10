require "classes.primitive"
local Color = require "classes.color.color"
require "classes.tabs.tab"
-- CODE TAB CLASS--

CodeTab = Class{
    __includes = {Tab},

    init = function(self, color, eps, dy)
        Tab.init(self, color, eps, dy)

        self.tp = "code_tab"
    end
}
