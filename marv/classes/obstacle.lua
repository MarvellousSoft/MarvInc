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

-- Obstacle class

local obst = {}

Obstacle = Class{
    __includes = {SpriteObject, Object},
    init = function(self, grid, i, j, key, bg, delay, clr, _, args)
        if delay then
            SpriteObject.init(self, grid, i, j, key, bg, delay, "obst", clr)
        else
            Object.init(self, grid, i, j, "obst", bg)
            self.img = PULL_ASSET(key)
            self.sx = ROOM_CW/self.img:getWidth()
            self.sy = ROOM_CH/self.img:getHeight()
        end
        if args and args.onInventoryDrop then
            self.onInventoryDrop = args.onInventoryDrop
        end
        if args and args.onWalk then
            self.onWalk = args.onWalk
        end
    end
}

return obst
