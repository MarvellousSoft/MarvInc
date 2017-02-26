require "classes.primitive"
local Color = require "classes.color.color"

-- Obstacle class

local obst = {}

Obstacle = Class{
    __includes = {SpriteObject, Object},
    init = function(self, grid, i, j, key, bg, delay, clr)
        if delay then
            SpriteObject.init(self, grid, i, j, key, bg, delay, "obst", clr)
        else
            Object.init(self, grid, i, j, "obst", bg)
            self.img = OBJS_IMG[key]
            self.sx = ROOM_CW/self.img:getWidth()
            self.sy = ROOM_CH/self.img:getHeight()
        end
    end
}

return obst
