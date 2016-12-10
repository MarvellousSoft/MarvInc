require "classes.primitive"
local Color = require "classes.color.color"
require "classes.tabs.tab"
-- CODE TAB CLASS--

CodeTab = Class{
    __includes = {Tab},

    init = function(self, eps, dy)
        Tab.init(self, eps, dy)

        self.tp = "code_tab"
    end
}
