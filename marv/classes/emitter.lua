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

-- Emitter class

Emitter = Class{
    __includes = {Object},
    init = function(self, grid, i, j, key, bg, color, _, __, args, dir)
        Object.init(self, grid, i, j, "emitter", bg)
        self.color = Color[color or "white"](Color)

        self.r = _G[dir:upper() .. '_R']

        self.img = PULL_ASSET(key)
        self.sx = ROOM_CW/self.img:getWidth()
        self.sy = ROOM_CH/self.img:getHeight()

        self.t_args = args.t_args
        self.awake = true
        self.rays = {}
    end
}

function Emitter:toggle()
    if self.awake then self:sleep() else self:wakeup() end
end

function Emitter:sleep()
    self.awake = false
end

function Emitter:wakeup()
    self.awake = true
end

function Emitter:createRays(grid)
    if not self.awake then return end
    local d = ORIENT[self.r[2]]
    local px, py = self.pos.x, self.pos.y
    local i = 0
    while true do
        i = i + 1
        px, py = px + d.x, py + d.y
        if px < 1 or px > ROWS or py < 1 or py > COLS then return end
        local o = grid[px][py]
        if o and o.tp == 'bot' then
            StepManager.stop("laser")
            return
        end
        -- does not work well when colliding with other lasers
        if o then return end
        if not self.rays[i] then
            self.rays[i] = DeadSwitch(grid, px, py, unpack(self.t_args))
            self.rays[i].is_ephemeral = true
            self.rays[i].r = self.r
        end
        grid[px][py] = self.rays[i]
    end
end
