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

-- Container class

Container = Class{
    __includes = {SpriteObject},
    init = function(self, grid, i, j, key, bg, delay,clr, _, args)
        SpriteObject.init(self, grid, i, j, key, bg, delay, "container", clr)

        self.content = args.content
        self.content_color = args.content_color or Color.new(0, 0, 70)
        self.color = self.content_color

        self.pickable = true
    end
}

function Container:toInventory(bot)
    return "Can't pickup container"
end
