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
    print(bot.inv.tp)
    bot.inv.dropped_on_computer = true
end
