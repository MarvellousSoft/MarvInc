require "classes.primitive"
local Color = require "classes.color.color"

-- Bucket class

Bucket = Class{
    __includes = {Object},
    init = function(self, grid, i, j, key, bg)
        Object.init(self, grid, i, j, "bucket", bg)
        self.img = OBJS_IMG[key]
        self.sx = ROOM_CW/self.img:getWidth()
        self.sy = ROOM_CH/self.img:getHeight()
        self.pickable = true
    end
}

function Bucket:use(bot, grid, i, j)
    local _o = grid[i][j]
    if _o and _o.bucketable then
        _o:sleep()
    end
    bot.inv = nil
end
