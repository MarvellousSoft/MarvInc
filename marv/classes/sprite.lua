--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

require "classes.primitive"
local Color = require "classes.color.color"

-- Sprite class

Sprite = Class{
    __includes = {RECT},
    init = function(self, x, y, key, delay, clr)
        RECT.init(self, x, y, -1, -1, clr)
        -- key is image trail
        self.sheet = PULL_ASSET(key, "sprite")
        self.img = self.sheet[1]
        self.n = self.sheet[2]
        self.w = math.floor(self.img:getWidth()/self.n)
        self.h = self.img:getHeight()
        self.delay = delay
        self.i = 0
        self.hdl = MAIN_TIMER:every(self.delay, function()
            self.i = (self.i + 1) % self.n
            self.quad:setViewport(self.i*self.w, 0, self.w, self.h)
        end)
        self.quad = love.graphics.newQuad(0, 0, self.w, self.h, self.img:getDimensions())
        self.death = false
    end
}

function Sprite:destroy()
    MAIN_TIMER:cancel(self.hdl)
end

function Sprite:draw()
    if not self.post_draw then
        Color.set(self.color)
        love.graphics.draw(self.img, self.quad, self.pos.x, self.pos.y)
    end
end

function Sprite:postDraw()
    if self.post_draw then
        Color.set(self.color)
        love.graphics.draw(self.img, self.quad, self.pos.x, self.pos.y)
    end
end
