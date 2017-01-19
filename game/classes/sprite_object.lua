require "classes.primitive"
local Color = require "classes.color.color"

-- Sprite Object class

SpriteObject = Class{
    __includes = {Sprite, Object},
    init = function(self, grid, i, j, key, bg, delay, tp, clr)
        Object.init(self, grid, i, j, tp, bg)
        Sprite.init(self, i, j, key, delay, clr)
        self.tp = tp
        self.sx = ROOM_CW/self.w
        self.sy = ROOM_CH/self.h
        self.color = clr
    end
}

function SpriteObject:draw()
    if not self.quad then
        Object.draw(self)
        return
    end
    Color.set(self.color)
    love.graphics.draw(self.img, self.quad, self.rx + ROOM_CW / 2, self.ry + ROOM_CH / 2, self.r[1],
                       self.sx, self.sy, self.w / 2, self.h / 2)
end
