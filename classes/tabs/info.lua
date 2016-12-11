require "classes.primitive"
local Color = require "classes.color.color"
require "classes.tabs.tab"

-- INFO TAB CLASS--

InfoTab = Class{
    __includes = {Tab},

    init = function(self, eps, dy)
        Tab.init(self, eps, dy)

        self.main_color =  Color.new(150, 200, 120)
        self.tp = "info_tab"

        self.dead = 0

        Signal.register("death", function()
            self.dead = self.dead + 1
        end)

        self.fnt = FONTS.fira(28)
        -- Relative to self.pos
        self.txt_x = 50
        self.txt_y = 50
        self.txt_h = self.fnt:getHeight()
        self.txt_dh = self.txt_h + 10
        self.txt_clr = Color.black()
    end
}

function InfoTab:draw()
    Color.set(self.main_color)

    love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.w, self.h)

    Color.set(self.txt_clr)
    love.graphics.setFont(self.fnt)
    love.graphics.push()
    love.graphics.translate(self.pos.x, self.pos.y)
    local _y = self.txt_y
    love.graphics.print("Test subject #"..(self.dead + 1), self.txt_x, _y)
    _y = _y + self.txt_dh
    love.graphics.print("Subject name: "..ROOM.bot.name, self.txt_x, _y)
    _y = _y + self.txt_dh
    love.graphics.print("Room #"..ROOM.n.." \""..ROOM.name.."\"", self.txt_x, _y)
    _y = _y + self.txt_dh
    love.graphics.printf("Objective: "..ROOM.objs[1].desc, self.txt_x, _y, 3*self.h/4, "left")
    love.graphics.pop()
end
