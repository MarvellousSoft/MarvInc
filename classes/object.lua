require "classes.primitive"
local Color = require "classes.color.color"

-- Object class

local obj = {}

Object = Class{
    __includes = {RECT},
    init = function(self, grid, i, j)
        RECT.init(self, i, j, ROOM_CW, ROOM_CH, Color.white())
        self.r = SOUTH_R
        -- Real positions relative to grid's position
        self.rx = (i-1)*ROOM_CW
        self.ry = (j-1)*ROOM_CH
        grid[i][j] = self
    end
}

-- Turns the object to point to an orientation.
function Object:turn(o)
    self.r = o[1]
end

-- Turns clockwise.
function Object:clock()
    self.r = ORIENT_R[(self.r[2] % #ORIENT_R) + 1]
end

-- Turns anti-clockwise.
function Object:anti()
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
    if  self.pos.x + o.x > r or
        self.pos.x + o.x < 1 or
        self.pos.y + o.y > c or
        self.pos.y + o.y < 1 then
        return
    end
    grid[self.pos.x][self.pos.y] = nil
    self.pos = self.pos + o
    self.rx = (self.pos.x-1)*ROOM_CW
    self.ry = (self.pos.y-1)*ROOM_CH
    grid[self.pos.x][self.pos.y] = self
end

return obj
