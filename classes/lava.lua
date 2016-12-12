require "classes.primitive"

-- Lava class

Lava = Class{
    __includes = {SpriteObject, Dead},
    init = function(self, grid, i, j, key, bg, delay, clr, skey)
        SpriteObject.init(self, grid, i, j, key, bg, delay, "dead", clr)

        -- skey is solid key image
        self.skey = skey
        print(self.tp)
    end
}

function Lava:solidify()
    print(self.skey)
    ROOM:paint(self.pos.x, self.pos.y, self.skey)
    ROOM:extract(self.pos.x, self.pos.y)
end
