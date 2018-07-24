--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

require "classes.primitive"

-- Dead class
-- Object that kills bot on touch.

local dead = {}

Dead = Class{
    __includes = {SpriteObject, Object},
    init = function(self, grid, i, j, key, bg, delay, clr)
        self.key = key
        if delay then
            SpriteObject.init(self, grid, i, j, key, bg, delay, "dead", clr)
        else
            Object.init(self, grid, i, j, "dead", bg)
            self.img = PULL_ASSET(key)
            self.sx = ROOM_CW/self.img:getWidth()
            self.sy = ROOM_CH/self.img:getHeight()
        end
    end
}

return dead
