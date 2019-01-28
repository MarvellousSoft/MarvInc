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
local Util = require "util"

-- Console class

Console = Class{
    __includes = {Object},
    -- may receive a vector or a function that receives the coordinates and creates the vector
    init = function(self, grid, i, j, key, bg, color, __, ___, args)
        Object.init(self, grid, i, j, "console", bg)
        self.color = Color[color or "white"](Color)
        self.img = PULL_ASSET(key)
        self.sx = ROOM_CW/self.img:getWidth()
        self.sy = ROOM_CH/self.img:getHeight()

        -- Optional emitters
        self.clients = {}
        self.clients_awake = true

        if type(args.vec) == 'table' then
            self.out = Util.shallowCopy(args.vec)
            self.ctype = args.ctype or 'input'
        elseif type(args.vec) == 'function' then
            self.out = args.vec(i, j)
            self.ctype = 'input'
        elseif type(args.vec) == 'string' then
            self.ctype = args.vec
            self.out = {}
        else
            assert(false)
        end
        self.inp = {}
        self.i = 1
        self.show_nums = args.show_nums

        self.fnt = FONTS.firaBold(20)
    end,
    show_nums = 3 -- amount of numbers to show on postDraw
}

function Console:postDraw()
    love.graphics.setFont(self.fnt)
    local fw, fh = self.fnt:getWidth("a"), self.fnt:getHeight()
    Color.set(self.color)
    local r, g, b = love.graphics.getColor()

    local nums = {}

    if #self.out > 0 then
        for i = 0, math.min(self.show_nums - 1, #self.out - self.i), 1 do
            table.insert(nums, self.out[self.i + i])
        end
    else
        for i = 0, math.min(self.show_nums - 1, #self.inp - 1), 1 do
            table.insert(nums, self.inp[#self.inp - i])
        end
    end
    local cx, cy
    if     self.r[2] == 1 then cx, cy = self.rx + ROOM.grid_cw, self.ry + ROOM.grid_cw
    elseif self.r[2] == 2 then cx, cy = self.rx, self.ry + (ROOM.grid_cw - fh) / 2
    elseif self.r[2] == 3 then cx, cy = self.rx + ROOM.grid_cw, self.ry - fh
    elseif self.r[2] == 4 then cx, cy = self.rx + ROOM.grid_cw, self.ry + (ROOM.grid_cw - fh) / 2
    end
    for i = 1, #nums, 1 do
        love.graphics.setColor(r, g, b, 270 - 70 * (3 / self.show_nums) * i)
        if self.r[2] == 4 then
            cx = cx + self.fnt:getWidth(nums[i]) + self.fnt:getWidth('-') * .5
        end
        love.graphics.printf(nums[i], -100, cy, cx + 100, 'right')
        cy = cy - ORIENT[self.r[2]].y * fh
        if self.r[2] == 2 then
            cx = cx - self.fnt:getWidth(nums[i]) - self.fnt:getWidth('-') * .5
        end
    end
end

-- Signals all clients to sleep.
function Console:sleep()
    if not self.clients_awake then return end
    for _, v in ipairs(self.clients) do
        v:sleep()
    end
    self.clients_awake = false
end

-- Signals all clients to wakeup.
function Console:wakeup()
    if self.clients_awake then return end
    for _, v in ipairs(self.clients) do
        v:wakeup()
    end
    self.clients_awake = true
end

-- Toggles clients to wakeup or sleep.
function Console:toggleClients()
    if self.clients_awake then self:sleep() else self:wakeup() end
end

-- Adds an emitter to this console.
function Console:addClient(e)
    table.insert(self.clients, e)
end

function Console:input()
    if self.ctype == 'output' then return "Trying to read from output-only console" end
    if self.i > #self.out then return end
    local v = self.out[self.i]
    self.i = self.i + 1
    return type(v) == 'string' and v:byte() or v
end

function Console:write(val)
    if self.ctype == 'IO' then
        if #self.out >= 500 then return "Trying to put too many numbers on console" end
        table.insert(self.out, val)
    elseif self.ctype == 'input' then
        return "Trying to write to input-only console"
    else
        if #self.inp >= 500 then return "Trying to put too many numbers on console" end
        table.insert(self.inp, val)
    end
end
