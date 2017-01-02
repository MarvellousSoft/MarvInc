require "classes.primitive"
local Color = require "classes.color.color"

-- Console class

Console = Class{
    __includes = {Object},
    -- may receive a vector or a function that receives the coordinates and creates the vector
    init = function(self, grid, i, j, key, bg, color, __, ___, args)
        Object.init(self, grid, i, j, "console", bg)
        self.color = Color[color or "white"](Color)
        self.img = OBJS_IMG[key]
        self.sx = ROOM_CW/self.img:getWidth()
        self.sy = ROOM_CH/self.img:getHeight()

        -- Optional emitters
        self.clients = {}
        self.clients_awake = true

        self.out = type(args) == 'table' and args or args(i, j)
        self.inp = {}
        self.i = 1

        self.fnt = FONTS.fira(20)
    end
}

function Console:postDraw()
    --[[
    local _tp = nil
    _tp = math.max(#self.inp, #self.out - self.i + 1)
    love.graphics.print(_tp, self.rx - self.fnt:getWidth(_tp)/2, self.ry-self.fnt:getHeight()-5)
    ]]
    love.graphics.setFont(self.fnt)
    local fw, fh = self.fnt:getWidth("a"), self.fnt:getHeight()
    Color.set(self.color)
    local r, g, b = love.graphics.getColor()

    local nums = {}
    if #self.out > 0 then
        for i = 0, math.min(2, #self.out - self.i), 1 do
            table.insert(nums, self.out[self.i + i])
        end
    else
        for i = 0, math.min(2, #self.inp - 1), 1 do
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
        love.graphics.setColor(r, g, b, 270 - 70 * i)
        if self.r[2] == 4 then
            cx = cx + self.fnt:getWidth(nums[i]) * 1.2
        end
        love.graphics.printf(nums[i], -100, cy, cx + 100, 'right')
        cy = cy - ORIENT[self.r[2]].y * fh
        if self.r[2] == 2 then
            cx = cx - self.fnt:getWidth(nums[i]) * 1.2
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
    if self.i > #self.out then return end
    self.i = self.i + 1
    return self.out[self.i - 1]
end

function Console:write(val)
    if #self.out > 0 then return "Trying to write to input-only console" end
    if #self.inp >= 500 then return "Trying to put too many numbers on console" end
    table.insert(self.inp, val)
end
