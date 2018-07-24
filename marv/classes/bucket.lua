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

local contents = {}
contents.empty, contents.water, contents.paint = unpack(require "classes.bucket_content")

-- Bucket class

Bucket = Class{
    __includes = {Object},
    init = function(self, grid, i, j, key, bg, _, __, ___, args)
        Object.init(self, grid, i, j, "bucket", bg)
        self.img = PULL_ASSET(key)
        self.content = contents[args.content](args.content_args)
        self.sx = ROOM_CW/self.img:getWidth()
        self.sy = ROOM_CH/self.img:getHeight()
        self.pickable = true
        if args.color then
            self.color = args.color
            self.content.color = args.color
        end
        if args.content_color then
            self.content.color = args.content_color
        end
        if args.pickable ~= nil then
            self.pickable = args.pickable
        end
        if args.w then
            self.w = args.w
        end
        if args.h then
            self.h = args.h
        end
    end
}

function Bucket:toInventory(bot)
    bot.inv = self
    ROOM.grid_obj[self.pos.x][self.pos.y] = nil
    self.pos = nil
end

function Bucket:use(bot, grid, i, j, blocked)
    return self.content:drop(bot, grid, i, j, blocked)
end

function Bucket:draw(x, y, w, h)
    if not x then return end
    Color.set(self.color)
    self:drawImg(self.img, x, y, w, h)
    Color.set(self.content.color)
    self:drawImg(self.content.img, x, y, w, h)
end

function Bucket:postDraw()
    if self.img == OBJS_IMG.papers then
        Color.set(Color.green())
        self:drawImg(MISC_IMG.arrow, self.rx, self.ry - (1 + math.sin(CUR_TIME * 5)) * ROOM_CH / 4 - ROOM_CH, ROOW_CW, ROOM_CH)
    end
    Color.set(self.color)
    self:drawImg(self.img, nil, nil, self.w, self.h)
    Color.set(self.content.color)
    self:drawImg(self.content.img)
end

-- pickup other object while holding bucket
function Bucket:pickup_other(bot, grid, i, j)
    if self.content.pickup_other then
        return self.content:pickup_other(bot, grid, i, j)
    else
        return "Not enough free hands"
    end
end
