require "classes.primitive"
local Color = require "classes.color.color"
require "classes.tabs.tab"

-- INFO TAB CLASS--

InfoTab = Class{
    __includes = {Tab},

    init = function(self, eps, dy)
        Tab.init(self, eps, dy)

        self.main_color =  Color.new(70, 100, 120, 60)
        self.tp = "info_tab"

        self.dead = 0

        Signal.register("death", function()
            self.dead = self.dead + 1
        end)

        -- Id file for showing the bot
        self.id_file_color = Color.new(70, 90, 240, 120)
        self.id_file_x = 10
        self.id_file_y = 10
        self.id_file_w = self.w - 2*self.id_file_x
        self.id_file_h = 200

        -- Portrat of bot
        self.id_file_color = Color.new(0, 0, 120, 240)
        self.portrait_x = 10
        self.portrait_y = 10
        self.portrait_w = 40
        self.portrait_h = 40

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
    local font

    -- Background for tab
    Color.set(self.main_color)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.w, self.h)

    -- Print bot id file
    --if ROOM:connected() then
        Color.set(self.id_file_color)
        love.graphics.rectangle("fill", self.pos.x + self.id_file_x, self.pos.y + self.id_file_y, self.id_file_w, self.id_file_h, 10)
        -- Bot number
        font = FONTS.fira(16)
        love.graphics.setFont(font)
        --text = "Test subject #"..(self.dead + 1)
        --font_w = font:getWidth(text)
        --love.graphics.print("Test subject #"..(self.dead + 1), self.pos.x + self.id_file_x + self.id_file_w - , self.pos.y + self.id_file_y + 5)
        -- Bot name
        love.graphics.setFont(FONTS.fira(20))
        --love.graphics.print("Subject name: "..ROOM.bot.name, self.pos.x + self.id_file_x + 40, self.pos.y + self.id_file_y + 30)
        -- Bot portrait
        Color.set(self.portrait_color)
        love.graphics.rectangle("fill", self.portrait_x, self.portrait_y, self.portrait_w, self.portrait_h)
        --draw bot here
    --end

    Color.set(self.txt_clr)
    local _y = self.txt_y
    _y = _y + self.txt_dh
    _y = _y + self.txt_dh
    --love.graphics.print("Room #"..ROOM.n.." \""..ROOM.name.."\"", self.txt_x, _y)
    _y = _y + self.txt_dh
    --love.graphics.printf("Objective: "..ROOM.objs[1].desc, self.txt_x, _y, 3*self.h/4, "left")
end
