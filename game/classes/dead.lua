require "classes.primitive"

-- Dead class
-- Object that kills bot on touch.

local dead = {}

Dead = Class{
    __includes = {SpriteObject, Object},
    init = function(self, grid, i, j, key, bg, delay, clr)
        self.key = key
        if delay then
            SpriteObject.init(self, grid, i, j, key, bg, delay, "dead", clr)
        else
            Object.init(self, grid, i, j, "dead", bg)
            self.img = OBJS_IMG[key]
            self.sx = ROOM_CW/self.img:getWidth()
            self.sy = ROOM_CH/self.img:getHeight()
        end
    end
}

return dead
