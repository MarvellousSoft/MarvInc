--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

-- Shows up only in the last level

Computer = Class {
    __includes = {Object},
    init = function(self, grid, i, j, key, bg, _, __, ___, args)
        Object.init(self, grid, i, j, "computer", bg)
        self.img = OBJS_IMG[key]
        self.sx = ROOM_CW/self.img:getWidth()
        self.sy = ROOM_CH/self.img:getHeight()
        if args.color then
            self.color = args.color
        end
    end
}

function Computer:onInventoryDrop(bot)
    bot.inv.delivered_to_feds = 'computer'
end

function Computer:draw() end

function Computer:postDraw()
    Object.draw(self)
end
