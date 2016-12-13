require "classes.primitive"
local Color = require "classes.color.color"

-- Object class

local obj = {}

Object = Class{
    __includes = {RECT},
    init = function(self, grid, i, j, tp, bg)
        RECT.init(self, i, j, ROOM_CW, ROOM_CH, Color.white())
        self.r = SOUTH_R
        self.tp = tp
        -- Whether to draw background
        self.bg = bg or false
        -- Real positions relative to grid's position
        self.rx = (i-1)*ROOM_CW
        self.ry = (j-1)*ROOM_CH
        grid[i][j] = self
    end
}

-- Kills this object.
function Object:kill(grid)
    grid[self.pos.x][self.pos.y] = nil
end

-- Turns the object to point to an orientation.
function Object:turn(o)
    self.r = o
end

-- Turns clockwise.
function Object:clock()
    self.r = ORIENT_R[(self.r[2] % #ORIENT_R) + 1]
end

-- Turns anti-clockwise.
function Object:counter()
    if self.r[2] == 1 then
        self.r = ORIENT_R[#ORIENT_R]
    else
        self.r = ORIENT_R[self.r[2]-1 % #ORIENT_R]
    end
end

-- Move. Moves to the adjacent cell given its current orientation.
function Object:move(grid, r, c)
    self:moveTo(grid, r, c, ORIENT[self.r[2]])
end

-- Move towards. Must move to an adjacent cell. Orientation o is north, east, south or west.
function Object:moveTo(grid, r, c, o)
    local px, py = self.pos.x + o.x, self.pos.y + o.y
    -- Out of bounds
    if  px > r or
        px < 1 or
        py > c or
        py < 1 then
        return
    end

    -- Obstacle ahead
    if grid[px][py] ~= nil then
        if grid[px][py].tp == "obst" then
            return
        end

        -- Don't dead open inside
        if grid[px][py].tp == "dead" then
            self:kill(grid)
            return
        end
    end

    grid[self.pos.x][self.pos.y] = nil
    self.pos.x, self.pos.y = px, py
    self.rx = (px-1)*ROOM_CW
    self.ry = (py-1)*ROOM_CH
    grid[px][py] = self
end

function Object:draw()
    Color.set(self.color)
    love.graphics.draw(self.img, self.rx + ROOM_CW/2, self.ry + ROOM_CW/2, self.r[1],
        self.sx, self.sy, ROOM_CW, ROOM_CH)
end

return obj
