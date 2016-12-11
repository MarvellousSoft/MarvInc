require "classes.primitive"

-- Dead class
-- Object that kills bot on touch.

local dead = {}

Dead = Class{
    __includes = {Object},
    init = function(self, grid, i, j, key, bg)
        Object.init(self, grid, i, j, "dead", bg)
        self.img = OBJS_IMG[key]
        self.sx = ROOM_CW/self.img:getWidth()
        self.sy = ROOM_CH/self.img:getHeight()
    end
}

return dead
