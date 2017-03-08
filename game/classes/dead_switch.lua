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
