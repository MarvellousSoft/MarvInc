--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

require "classes.primitive"
require "classes.color.color"
local Color = require "classes.color.color"

local funcs = {}

------------------------
--Warning Window Class--
------------------------

local WarningWindow = Class{
    __includes = {RECT, WTXT},
    init = function(self, _title, _message, _buttonlist)

        self.title_font = FONTS.firaBold(40)
        self.message_font = FONTS.fira(20)
        self.h_gap = 10 --Horizontal gap between title/message and border of window
        self.v_title_gap = 2 --Vertical gap above and below title
        self.v_message_gap = 3 --Vertical gap above and below message
        self.message_limit = 400 --Limit for wrapping the message text
        self.real_message_w, self.wraptext = self.message_font:getWrap(_message, self.message_limit)

        local width = math.max(self.title_font:getWidth(_title) + 2*self.h_gap, self.real_message_w + 2*self.h_gap)
        local height = self.title_font:getHeight(_title) + 2*self.v_title_gap + self.message_font:getHeight(_message)*#self.wraptext +2*self.v_message_gap
        RECT.init(self, W/2 - width/2, H/2 - height/2, width, height) --Set rect attributes

        self.title = _title
        self.message = _message

        self.bg_color = Color.white()
        self.bg_contour_color = Color.black()
        self.bg_contour_line_width = 3

        self.text_color = Color.black()

        self.tp = "warning_window" --Type of this class

    end,
}

function WarningWindow:update(dt)

end

--Draws a given square button with text aligned to the left
function WarningWindow:draw()
    local w = self
    local x, y

    --Draw black filter
    love.graphics.setColor(0, 0, 0, 120)
    love.graphics.rectangle("fill", 0, 0, W, H)

    love.graphics.push()

    love.graphics.translate(w.pos.x, w.pos.y)

    --Draw background
    Color.set(w.bg_color)
    love.graphics.rectangle("fill", 0, 0, w.w, w.h)
    love.graphics.setLineWidth(w.bg_contour_line_width)
    Color.set(w.bg_contour_color)
    love.graphics.rectangle("line", 0, 0, w.w, w.h)

    --Draw title
    love.graphics.translate(0, w.v_title_gap)
    x = w.w/2 - w.title_font:getWidth(w.title)/2
    y = 0
    Color.set(w.text_color)
    love.graphics.setFont(w.title_font)
    love.graphics.print(w.title, x , y)

    --Draw title separator
    love.graphics.translate(0, w.title_font:getHeight(w.title) + w.v_title_gap)
    love.graphics.setLineWidth(2)
    Color.set(Color.black())
    local gap = 3
    love.graphics.line(gap, 0, w.w - gap, 0)

    --Draw Message
    love.graphics.translate(0, w.v_message_gap)
    x = w.w/2 - w.real_message_w/2
    y = 0
    Color.set(w.text_color)
    love.graphics.setFont(w.message_font)
    love.graphics.printf(w.message, x , y, w.message_limit)

    love.graphics.pop()
end

--UTILITY FUNCTIONS--

function funcs.create(title, message, buttonlist)
    local w = WarningWindow(title, message, buttonlist)

    w:addElement(DRAW_TABLE.WRNG, nil, "warning_window")

    return w
end

function funcs.show(title, message, buttonlist)

    funcs.create(title,message,buttonlist)

    return 0
end


--Return functions
return funcs
