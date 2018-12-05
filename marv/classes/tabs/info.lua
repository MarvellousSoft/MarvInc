--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

require "classes.primitive"
local Color = require "classes.color.color"
require "classes.tabs.tab"

local ScrollWindow = require "classes.scroll_window"

-- INFO TAB CLASS--
local info_funcs = {}

InfoTab = Class{
    __includes = {Tab},

    button_color = 150,

    init = function(self, eps, dy)
        Tab.init(self, eps, dy)

        self.name = "info"

        self.main_color =  Color.new(70, 100, 180, 60)
        self.tp = "info_tab"

        self.dead = 0

        Signal.register("death", function()
            self.dead = self.dead + 1
            AchManager.checkAchievements()
        end)

        -- Id file for showing the bot
        self.id_file_color = Color.new(70, 90, 215)
        self.id_file_text_color = Color.new(0, 80, 10)
        self.id_file_x = 10
        self.id_file_y = 10
        self.id_file_w = self.w - 4*self.id_file_x
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
        self.give_up_x, self.give_up_y = 0, 0
        self.give_up_hover = false

        self.maximum_number_lines_color = Color.new(45,140,140) --Color for maximum number of lines text

        self.line_color = Color.new(0,80,40)

        self.w = self.w - 13 / 2

        self.last_h = 0
        local obj = {
            pos = self.pos,
            getHeight = function() return self.last_h end,
            draw = function() self:trueDraw() end,
            mousePressed = function(obj, ...) self:trueMousePressed(...) end,
            mouseMoved = function(obj, ...) self:trueMouseMoved(...) end,
        }
        self.box = ScrollWindow(self.w + 5, self.h, obj)
        self.box.sw = 13
        self.box.color = {5, 10, 30}

        self:setId("info_tab")
    end
}

function InfoTab:mousePressed(x, y, but)
    self.box:mousePressed(x, y, but)
end

function InfoTab:mouseMoved(x, y)
    self.box:mouseMoved(x, y)
end

function InfoTab:trueMousePressed(x, y, but)
    local i
    i = self
    -- Disconnect Room if give up button is pressed
    if ROOM.puzzle_id ~= 'franz1' and but == 1 and ROOM:connected() and Util.pointInRect(x, y, i.give_up_x, i.give_up_y, i.give_up_w, i.give_up_h) then
        ROOM:disconnect()
    end
end

function InfoTab:trueMouseMoved(x, y)
    self.give_up_hover = Util.pointInRect(x, y, self.give_up_x, self.give_up_y, self.give_up_w, self.give_up_h)
end

function InfoTab:mouseReleased(x, y, but)
    self.box:mouseReleased(x, y, but)
end

function InfoTab:update(dt)
    self.box:update(dt)
end

function InfoTab:mouseScroll(x, y)
    self.box:mouseScroll(x, y)
end

function InfoTab:draw()
    -- Background for tab
    Color.set(self.main_color)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.w, self.h)

    self.box:draw()
end

local function makeBrighter()
    local r, g, b = love.graphics.getColor()
    love.graphics.setColor(r * 1.2, g * 1.2, b * 1.2)
end

function InfoTab:trueDraw()
    local font, text

    -- Print bot id file
    if ROOM:connected() then
        local offset = 4
        love.graphics.setColor(0,0,0,180)
        love.graphics.rectangle("fill", self.pos.x + self.id_file_x - offset, self.pos.y + self.id_file_y + offset, self.id_file_w, self.id_file_h, 10)
        Color.set(self.id_file_color)
        love.graphics.rectangle("fill", self.pos.x + self.id_file_x, self.pos.y + self.id_file_y, self.id_file_w, self.id_file_h, 10)


        -- Bot number
        font = FONTS.fira(16)
        love.graphics.setFont(font)
        text = "Test subject #"..self.dead
        font_w = font:getWidth(text)
        Color.set(self.id_file_text_color)
        love.graphics.print(text, self.pos.x + self.id_file_x + self.id_file_w - font_w - 10, self.pos.y + self.id_file_y + 5)

        -- Bot name
        love.graphics.setFont(FONTS.fira(25))
        Color.set(self.id_file_text_color)
        love.graphics.print("Subject Name:", self.pos.x + self.id_file_x + 110, self.pos.y + self.id_file_y + 30)
        love.graphics.setFont(FONTS.fira(20))
        love.graphics.print(ROOM.bot.name, self.pos.x + self.id_file_x + 310, self.pos.y + self.id_file_y + 35)

        -- Bot portrait
        local offset = 3
        love.graphics.setColor(0,0,0,180)
        love.graphics.rectangle("fill", self.pos.x + self.portrait_x + 20-offset, self.pos.y + self.portrait_y + 28+offset, self.portrait_w, self.portrait_h, 5)
        Color.set(self.portrait_color)
        love.graphics.rectangle("fill", self.pos.x + self.portrait_x + 20, self.pos.y + self.portrait_y + 28, self.portrait_w, self.portrait_h, 5)
        Color.set(ROOM.bot.body_clr)
        local fx, fy = self.pos.x + self.portrait_x + 25, self.pos.y + self.portrait_y + 33
        love.graphics.draw(ROOM.bot.body, fx, fy)
        Color.set(ROOM.bot.head_clr)
        love.graphics.draw(ROOM.bot.head, fx, fy)
        Color.set(ROOM.bot.hair_clr)
        love.graphics.draw(ROOM.bot.hair, fx, fy)

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
        local font
        local size = 20
        repeat -- reduces font until all text fits
            font = FONTS.fira(size)
            size = size - 1
            _, t = font:getWrap(text, self.id_file_w - 20)
        until #t <= 3
        love.graphics.setFont(font)
        love.graphics.printf(text, self.pos.x + self.id_file_x + 10, self.pos.y + self.id_file_y + 120, self.id_file_w - 20, "center")

        -- Room number
        font = FONTS.fira(30)
        text = "ROOM #" .. ROOM.puzzle.n
        font_w = font:getWidth(text)
        love.graphics.setFont(font)
        Color.set(self.text_color1)
        love.graphics.print(text, self.pos.x + self.w/2 - font_w/2, self.pos.y + 220)

        -- Room name
        font = FONTS.fira(24)
        text = '"' .. ROOM.puzzle.name .. '"'
        font_w = font:getWidth(text)
        love.graphics.setFont(font)
        Color.set(self.text_color1)
        love.graphics.print(text, self.pos.x + self.w/2 - font_w/2, self.pos.y + 260)

        -- Objective
        font = FONTS.fira(24)
        love.graphics.setFont(font)
        Color.set(self.text_color2)
        local txt = "Objective:"
        love.graphics.print(txt, self.pos.x + 10, self.pos.y + self.id_file_y + 300)
        local line_y = self.pos.y + self.id_file_y + 300 + font:getHeight() + 2
        love.graphics.line(self.pos.x + 10, line_y, self.pos.x + 10 + font:getWidth(txt),line_y)
        font = FONTS.fira(18)
        love.graphics.setFont(font)
        local h = 0
        local _, wraptext

        Color.set(self.text_color3)
        text = "- " .. ROOM.puzzle.objective_text
        love.graphics.printf(text, self.pos.x + 10, self.pos.y + self.id_file_y + 350 + h, self.w - 20)
        _, wraptext = font:getWrap(text, self.w - 20)
        h = h + #wraptext*font:getHeight()

        --Draw maximum number of lines permitted
        font = FONTS.fira(20)
        love.graphics.setFont(font)
        Color.set(self.maximum_number_lines_color)
        local txt = "Lines available for puzzle: " .. ROOM.puzzle.lines_on_terminal
        love.graphics.print(txt, self.pos.x + 10, self.pos.y + self.id_file_y + 370 + h)

        h = h + font:getHeight() + 20

        -- Extra Info
        if ROOM.extra_info and ROOM.extra_info ~= "" then
            font = FONTS.fira(24)
            love.graphics.setFont(font)
            Color.set(self.text_color2)
            local txt = "Extra info:"
            love.graphics.print(txt, self.pos.x + 10, self.pos.y + self.id_file_y + 360 + h)
            local line_y = self.pos.y + self.id_file_y + 360 + h + font:getHeight() + 2
            love.graphics.line(self.pos.x + 10, line_y, self.pos.x + 10 + font:getWidth(txt),line_y)
            font = FONTS.fira(18)
            love.graphics.setFont(font)
            Color.set(self.text_color3)
            -- Print the info
            text = "- "..ROOM.extra_info
            love.graphics.printf(text, self.pos.x + 10, self.pos.y + self.id_file_y + 415 + h, self.w - 20)
            h = h + #(select(2, font:getWrap(text, self.w - 20))) * font:getHeight()
            self.last_h = self.id_file_y + 415 + h
        else
            self.last_h = self.id_file_y + 350 + h
        end


        -- Draw give up button

        -- Make button box
        if ROOM.puzzle_id ~= 'franz1' then
          self.give_up_x = self.pos.x + self.w - self.give_up_w - 10
          self.give_up_y = self.pos.y + self.last_h + 10
          Color.set(self.give_up_button_color)
          if self.give_up_hover then makeBrighter() end
          love.graphics.rectangle("fill", self.give_up_x, self.give_up_y, self.give_up_w, self.give_up_h)
          Color.set(self.line_color)
          love.graphics.setLineWidth(3)
          love.graphics.rectangle("line", self.give_up_x, self.give_up_y, self.give_up_w, self.give_up_h)

          self.last_h = self.last_h + 20 + self.give_up_h

          -- Make button text
          love.graphics.setFont(FONTS.fira(20))
          Color.set(self.give_up_button_text_color)
          love.graphics.print("give up", self.give_up_x + 6, self.give_up_y + 6)
        end

    else
        -- This is useless now
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

        self.last_h = self.id_file_y + 60 + h

    end

end

return info_funcs
