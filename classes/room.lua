require "classes.primitive"
local Color = require "classes.color.color"
--ROOM CLASS--

--Room functions table
local room = {}

Room = Class{
    __includes = {RECT},
    init = function(self)
        local b = 20
        RECT.init(self, W - (H - b), b, H - 2 * b, H - 2 * b, Color.orange())

        self.tp = "room"
    end
}

function Room:draw()
    local r

    r = self

    Color.set(r.color)
    love.graphics.rectangle("fill", r.pos.x, r.pos.y, r.w, r.h)

end


--UTILITY FUNCTIONS--

function room.create()
    local r

    r = Room()
    r:addElement(DRAW_TABLE.L1, nil, "room")

    return r
end

return room
