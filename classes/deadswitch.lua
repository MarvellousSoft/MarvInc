require "classes.primitive"

-- DeadSwitch class

DeadSwitch = Class{
    __includes = {SpriteObject, Dead},
    init = function(self, grid, i, j, key, bg, delay, clr, skey)
        SpriteObject.init(self, grid, i, j, key, bg, delay, "dead", clr)

        -- skey is solid key image
        self.skey = skey

        -- old floor
        self.of = nil
    end
}

function DeadSwitch:sleep()
    ROOM:sedate(self)
end

function DeadSwitch:wakeup()
    ROOM:wake(self)
end
