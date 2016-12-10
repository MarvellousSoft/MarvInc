require "classes.primitive"
local Color = require "classes.color.color"

-- Bot class

local bot = {}

Bot = Class{
    __includes = {Object},
    init = function(self, grid, i, j)
        -- i and j are 0-indexed positions in grid
        Object.init(self, grid, i, j)
        self.head = HEAD[love.math.random(#HEAD)]
        self.body = BODY[love.math.random(#BODY)]
        self.head_clr = Color.new(love.math.random(256) - 1, 200, 200)
        self.body_clr = Color.new(love.math.random(256) - 1, 200, 200)
        self.sx = ROOM_CW/self.body:getWidth()
        self.sy = ROOM_CH/self.body:getHeight()
    end
}

function Bot:draw()
    Color.set(self.body_clr)
    love.graphics.draw(self.body, self.rx, self.ry, self.r[1], self.sx, self.sy)
    Color.set(self.head_clr)
    love.graphics.draw(self.head, self.rx, self.ry, self.r[1], self.sx, self.sy)
end

return bot
