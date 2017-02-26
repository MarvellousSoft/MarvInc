require "classes.primitive"
local Color = require "classes.color.color"

local contents = {}
contents.empty, contents.water, contents.paint = unpack(require "classes.bucket_content")

-- Bucket class

Bucket = Class{
    __includes = {Object},
    init = function(self, grid, i, j, key, bg, _, __, ___, args)
        Object.init(self, grid, i, j, "bucket", bg)
        self.img = OBJS_IMG[key]
        self.content = contents[args.content](args.content_args)
        self.sx = ROOM_CW/self.img:getWidth()
        self.sy = ROOM_CH/self.img:getHeight()
        self.pickable = true
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
    Color.set(self.color)
    self:drawImg(self.img, x, y, w, h)
    Color.set(self.content.color)
    self:drawImg(self.content.img, x, y, w, h)
end

-- pickup other object while holding bucket
function Bucket:pickup_other(bot, grid, i, j)
    if self.content.pickup_other then
        return self.content:pickup_other(bot, grid, i, j)
    else
        return "Not enough free hands"
    end
end
