require "classes.primitive"
local Color = require "classes.color.color"

-- Object class

local obj = {}

Object = Class{
    __includes = {RECT},
    init = function(self, grid, i, j)
        RECT.init(self, i, j, ROOM_CW, ROOM_CH, Color.white())
        self.r = SOUTH_R
        self.grid = grid
        self.grid[i][j] = self
        -- Real positions relative to grid's position
        self.rx = (i-1)*ROOM_CW
        self.ry = (j-1)*ROOM_CH
    end
}

-- Turns the object to point to an orientation.
function Object:turn(o)
    self.r = o[1]
end

-- Turns clockwise.
function Object:clock()
    self.r = ORIENT_R[self.r[2]+1 % #ORIENT_R]
end

-- Must move to an adjacent cell. Orientation o is north, east, south or west.
function Object:move(o)
    self.grid[self.pos.x][self.pos.y] = nil
    self.pos = self.pos + o
    self.rx = (i-1)*ROOM_CW
    self.ry = (j-1)*ROOM_CH
    self.grid[self.pos.x][self.pos.y] = self
end

return obj
