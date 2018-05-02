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
        self.rx = (i - 1)*ROOM_CW
        self.ry = (j - 1)*ROOM_CH
        grid[i][j] = self
    end
}

-- Careful when calling this function!
function Object:teleport(grid, i, j)
    if self.pos then
        grid[self.pos.x][self.pos.y] = nil
    else
        self.pos = Vector()
    end
    self.pos.x, self.pos.y = i, j
    self.rx = (i-1)*ROOM_CW
    self.ry = (j-1)*ROOM_CH
    grid[i][j] = self
end

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

function Object:dieIfStay(grid)
    local obj = grid[self.pos.x][self.pos.y]
    if obj and (obj.tp == "dead" or obj.tp == "container") then
        self:kill(grid, t)
    end
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
        local t = grid[px][py].tp
        -- refactor me plz
        if t == "obst" or t == "console" or t == "bucket" then
            if grid[px][py].onWalk then
                grid[px][py]:onWalk(bot)
            end
            return
        end

        -- Don't dead open inside
        if t == "dead" or t == "container" then
            self:kill(grid, grid[px][py])
            return
        end
    end

    if ROOM.inv_wall[px][py] then
        return
    end

    if grid[self.pos.x][self.pos.y] == self then
        grid[self.pos.x][self.pos.y] = nil
    end
    self.pos.x, self.pos.y = px, py
    self.rx = (px-1)*ROOM_CW
    self.ry = (py-1)*ROOM_CH
    grid[px][py] = self
end

-- img must have the same size as the objects image
function Object:drawImg(img, x, y, w, h)
    love.graphics.draw(img, (x or self.rx) + (w or ROOM_CW) / 2, (y or self.ry) + (h or ROOM_CH) / 2, self.r[1],
                       (w and (w / self.img:getWidth()) or self.sx), (h and (h / self.img:getHeight()) or self.sy), self.img:getWidth()/2, self.img:getHeight()/2)
end

function Object:draw(x, y, w, h)
    Color.set(self.color)
    self:drawImg(self.img, x, y, w, h)
end

return obj
