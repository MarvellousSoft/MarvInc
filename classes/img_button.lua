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
    local mx, my = love.mouse.getPosition()
    local hover = Util.pointInRect(mx, my, self)

    if hover then
        self.color.l = 50
        self.color.a = 50
        Color.set(self.color)
        love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.w, self.h)
    end

    self.color.l = 255
    self.color.a = 255
    Color.set(self.color)
    love.graphics.draw(self.img, self.pos.x, self.pos.y, 0, self.scale, self.scale)
end

function ImgButton:mousePressed(x, y, but)
    if but == 1 and Util.pointInRect(x, y, self) then
        self.call()
    end
end

