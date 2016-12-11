require "classes.primitive"
local Color = require "classes.color.color"

-- Bot class

local bot = {}

Bot = Class{
    __includes = {Object},
    init = function(self, grid, i, j)
        -- i and j are 0-indexed positions in grid
        Object.init(self, grid, i, j, "bot", true)
        self.head = HEAD[love.math.random(#HEAD)]
        self.body = BODY[love.math.random(#BODY)]
        self.head_clr = Color.new(love.math.random(256) - 1, 200, 200)
        self.body_clr = Color.new(love.math.random(256) - 1, 200, 200)
        self.sx = ROOM_CW/self.body:getWidth()
        self.sy = ROOM_CH/self.body:getHeight()

        -- Get random name from list
        self.name = NAMES[love.math.random(#NAMES)]
    end
}

function Bot:kill(grid)
    Object.kill(self, grid)
    Signal.emit("death")
end

function Bot:blocked(grid, r, c)
    local p = ORIENT[self.r[2]]
    local px, py = self.pos.x + p.x, self.pos.y + p.y
    if  px < 1 or
        px > r or
        py < 1 or
        py > c then
        return nil
    end
    print("hue", grid[px][py])
    return grid[px][py]
end

function Bot:draw()
    Color.set(self.body_clr)
    love.graphics.draw(self.body, self.rx + ROOM_CW/2, self.ry + ROOM_CH/2, self.r[1],
        self.sx, self.sy, ROOM_CW, ROOM_CH)
    Color.set(self.head_clr)
    love.graphics.draw(self.head, self.rx + ROOM_CW/2, self.ry + ROOM_CH/2, self.r[1],
        self.sx, self.sy, ROOM_CW, ROOM_CH)
end

return bot
