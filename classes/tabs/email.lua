require "classes.primitive"
local Color = require "classes.color.color"
require "classes.tabs.tab"
-- EMAIL TAB CLASS--

EmailTab = Class{
    __includes = {Tab},

    init = function(self, eps, dy)
        Tab.init(self, eps, dy)

        self.tp = "email_tab"
    end
}
