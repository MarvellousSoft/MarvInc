require "classes.primitive"
local Color = require "classes.color.color"
--PC-BOX CLASS--

--PC-BOX functions table
local pcbox = {}

PcBox = Class{
    __includes = {RECT},
    init = function(self)
        local b = 20
        RECT.init(self, b, b, W - H - b, H - 2 * b, Color.red())

        self.tp = "pcbox"
    end
}

function PcBox:draw()
    local p

    p = self

    Color.set(p.color)
    love.graphics.rectangle("fill", p.pos.x, p.pos.y, p.w, p.h)

end


--UTILITY FUNCTIONS--

function pcbox.create()
    local p

    p = PcBox()
    p:addElement(DRAW_TABLE.L1, nil, "pcbox")

    return r
end

return pcbox
