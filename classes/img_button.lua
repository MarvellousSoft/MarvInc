local Color = require "classes.color.color"
require "classes.primitive"

-- Assumes it is a square
ImgButton = Class{
    __include = {RECT},
    init = function(self, x, y, sz, img, callback)
        RECT.init(self, x, y, sz, sz, Color.white())

        self.call = callback
        self.img = img

        self.scale = sz / img:getWidth()

        self.tp = "img_button"
    end
}


function ImgButton:draw()
    self.color.l = 20
    self.color.l = 255
    Color.set(self.color)
    love.graphics.draw(self.img, self.pos.x, self.pos.y, 0, self.scale, self.scale)
end

function ImgButton:mousePressed(x, y, but)
    if but == 1 and Util.pointInRect(x, y, self) then
        self.call()
    end
end

