--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

require "classes.primitive"

-- DeadSwitch class

DeadSwitch = Class{
    __includes = {SpriteObject, Dead},
    init = function(self, grid, i, j, key, bg, delay, clr, skey, args)
        SpriteObject.init(self, grid, i, j, key, bg, delay, "dead", clr)

        self.key = key

        -- skey is solid key image
        self.skey = skey

        -- old floor
        self.of = nil
        self.on = true

        if args then
            self.bucketable = args.bucketable
            if args.sw then
                self.sx = args.sw
            end if args.sh then
                self.sy = args.sh
            end if args.no_draw then
                self.no_draw = true
            end if args.post_draw then
                self.post_draw = true
            end
        end
    end
}

function DeadSwitch:sleep()
    if not self.on then return end
    ROOM:sedate(self)
    self.on = false
end

function DeadSwitch:wakeup()
    if self.on then return end
    ROOM:wake(self)
    self.on = true
end
