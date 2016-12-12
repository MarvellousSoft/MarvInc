require "classes.primitive"
local Color = require "classes.color.color"

-- Console class

Color = Class{
    __includes = {Object},
    init = function(self, grid, i, j, key, bg, delay, clr, args)
        Object.init(self, grid, i, j, "console", bg)
        self.img = OBJS_IMG[key]
        self.sx = ROOM_CW/self.img:getWidth()
        self.sy = ROOM_CH/self.img:getHeight()

        self.vec = type(args) == 'table' and args or args()
    end
}
