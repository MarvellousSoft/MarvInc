require "classes.primitive"
local Color = require "classes.color.color"
require "classes.tabs.tab"

-- INFO TAB CLASS--
local info_funcs = {}

InfoTab = Class{
    __includes = {Tab},

    init = function(self, eps, dy)
        Tab.init(self, eps, dy)

        self.main_color =  Color.new(70, 100, 180, 60)
        self.tp = "info_tab"

        self.dead = 0

        Signal.register("death", function()
            self.dead = self.dead + 1
        end)

        -- Id file for showing the bot
        self.id_file_color = Color.new(70, 90, 240, 110)
        self.id_file_text_color = Color.new(0, 80, 10)
        self.id_file_x = 10
        self.id_file_y = 10
        self.id_file_w = self.w - 2*self.id_file_x
        self.id_file_h = 200

        -- Portrat of bot
        self.portrait_color = Color.new(0, 0, 200)
        self.portrait_x = 10
        self.portrait_y = 10
        self.portrait_w = 80
        self.portrait_h = 80

        -- Colors
        self.text_color1 = Color.new(45,140,140)
        self.text_color2 = Color.new(80,140,140)
        self.text_color3 = Color.new(35,140,140)

        -- Known commands table
        self.commands = {}

        -- Give up button
        self.give_up_button_color = Color.new(0,80,120) --Color for give up button box
        self.give_up_button_text_color = Color.new(0,20,220) --Color for give up button text
        self.give_up_w = 95 -- Width value of give up button
        self.give_up_h = 40 -- Height value of give up button
        self.give_up_x = self.pos.x + self.w - self.give_up_w - 10 -- X position value of give up button (related to opened email pos)
        self.give_up_y = self.pos.y + self.h - self.give_up_h - 10 -- Y position value of give up button (related to opened email pos)

        self.line_color = Color.new(0,80,40)

    end
}

function InfoTab:mousePressed(x, y, but)
    local i

    i = self

    -- Disconnect Room if give up button is pressed
    if but == 1 and ROOM:connected() and Util.pointInRect(x, y, {pos = {x = i.give_up_x, y = i.give_up_y}, w = i.give_up_w, h = i.give_up_h}) then
        ROOM:disconnect()
    end

end

function InfoTab:draw()
    local font, text

    -- Background for tab
    Color.set(self.main_color)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.w, self.h)

    -- Print bot id file
    if ROOM:connected() then
        Color.set(self.id_file_color)
        love.graphics.rectangle("fill", self.pos.x + self.id_file_x, self.pos.y + self.id_file_y, self.id_file_w, self.id_file_h, 10)


        -- Bot number
        font = FONTS.fira(16)
        love.graphics.setFont(font)
        text = "Test subject #"..(self.dead + 1)
        font_w = font:getWidth(text)
        Color.set(self.id_file_text_color)
        love.graphics.print("Test Subject #"..(self.dead + 1), self.pos.x + self.id_file_x + self.id_file_w - font_w - 10, self.pos.y + self.id_file_y + 5)

        -- Bot name
        love.graphics.setFont(FONTS.fira(25))
        Color.set(self.id_file_text_color)
        love.graphics.print("Subject Name:", self.pos.x + self.id_file_x + 110, self.pos.y + self.id_file_y + 30)
        love.graphics.setFont(FONTS.fira(20))
        love.graphics.print(ROOM.bot.name, self.pos.x + self.id_file_x + 310, self.pos.y + self.id_file_y + 35)

        -- Bot portrait
        Color.set(self.portrait_color)
        love.graphics.rectangle("fill", self.pos.x + self.portrait_x + 20, self.pos.y + self.portrait_y + 28, self.portrait_w, self.portrait_h, 5)
        Color.set(ROOM.bot.body_clr)
        love.graphics.draw(ROOM.bot.body, self.pos.x + self.portrait_x + 25, self.pos.y + self.portrait_y + 33)
        Color.set(ROOM.bot.head_clr)
        love.graphics.draw(ROOM.bot.head, self.pos.x + self.portrait_x + 25, self.pos.y + self.portrait_y + 33)

        -- Bot traits
        love.graphics.setFont(FONTS.fira(25))
        Color.set(self.id_file_text_color)
        love.graphics.print("Subject Traits:", self.pos.x + self.id_file_x + 110, self.pos.y + self.id_file_y + 75)
        love.graphics.setFont(FONTS.fira(20))
        text = ROOM.bot.traits[1]
        for i,trait in ipairs(ROOM.bot.traits) do
            if i > 1 then
                text = text..", " ..trait
            end
        end
        love.graphics.printf(text, self.pos.x + self.id_file_x + 10, self.pos.y + self.id_file_y + 120, self.id_file_w - 20, "center")

        -- Room number
        font = FONTS.fira(30)
        text = "ROOM #"..ROOM.n
        font_w = font:getWidth(text)
        love.graphics.setFont(font)
        Color.set(self.text_color1)
        love.graphics.print(text, self.pos.x + self.w/2 - font_w/2, self.pos.y + 220)

        -- Room name
        font = FONTS.fira(24)
        text = "\""..ROOM.name.."\""
        font_w = font:getWidth(text)
        love.graphics.setFont(font)
        Color.set(self.text_color1)
        love.graphics.print(text, self.pos.x + self.w/2 - font_w/2, self.pos.y + 260)

        -- Objective
        font = FONTS.fira(24)
        love.graphics.setFont(font)
        Color.set(self.text_color2)
        love.graphics.print("Objective:", self.pos.x + 10, self.pos.y + self.id_file_y + 300)
        font = FONTS.fira(18)
        love.graphics.setFont(font)
        local h = 0
        local _, wraptext

        Color.set(self.text_color3)
        -- Print all objectives descriptions
        for i,t in ipairs(ROOM.objs) do
            text = "- "..t.desc
            love.graphics.printf(text, self.pos.x + 10, self.pos.y + self.id_file_y + 350 + h, self.w - 20)
            _, wraptext = font:getWrap(text, self.w - 20)
            h = h + #wraptext*font:getHeight()
        end

        -- Extra Info
        if ROOM.extra_info and ROOM.extra_info ~= "" then
            font = FONTS.fira(24)
            love.graphics.setFont(font)
            Color.set(self.text_color2)
            love.graphics.print("Extra info:", self.pos.x + 10, self.pos.y + self.id_file_y + 360 + h)
            font = FONTS.fira(18)
            love.graphics.setFont(font)
            Color.set(self.text_color3)
            -- Print the info
            love.graphics.printf("- "..ROOM.extra_info, self.pos.x + 10, self.pos.y + self.id_file_y + 415 + h, self.w - 20)
        end

        -- Draw give up button

        -- Make button box
        Color.set(self.give_up_button_color)
        love.graphics.rectangle("fill", self.give_up_x, self.give_up_y, self.give_up_w, self.give_up_h)
        Color.set(self.line_color)
        love.graphics.setLineWidth(2)
        love.graphics.rectangle("line", self.give_up_x, self.give_up_y, self.give_up_w, self.give_up_h)

        -- Make button text
        love.graphics.setFont(FONTS.fira(20))
        Color.set(self.give_up_button_text_color)
        love.graphics.print("give up", self.give_up_x + 6, self.give_up_y + 6)

    else
        --Outside a puzzle

        -- Tab title
        font = FONTS.fira(30)
        text = "KNOWN COMMANDS"
        font_w = font:getWidth(text)
        font_h = font:getHeight()
        love.graphics.setFont(font)
        Color.set(self.text_color3)
        love.graphics.print(text, self.pos.x + self.w/2 - font_w/2, self.pos.y + 20)
        -- Draw line
        love.graphics.line(self.pos.x + self.w/2 - font_w/2 - 10, self.pos.y + 20 + font_h + 5, self.pos.x + self.w/2 - font_w/2 + font_w + 10, self.pos.y + 20 + font_h + 5)

        -- List known commands
        local h = 0
        font = FONTS.fira(18)
        love.graphics.setFont(font)
        Color.set(self.text_color2)
        for i,t in ipairs(self.commands) do
            text = "- "..t
            love.graphics.print(text, self.pos.x + 10, self.pos.y + self.id_file_y + 60 + h)
            h = h + font:getHeight(text)
        end

    end

end

-- UTILITY FUNCTIONS --
function info_funcs.addCommand(string)
    table.insert(Util.findId("info_tab").commands, string)
end

return info_funcs
