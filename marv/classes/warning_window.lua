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

--[[
Format of argument _buttonlist:
    Must best a sequence of tuples (text, function), and for each it will created
a button on the warning window using the text and function as callback when the
button is pressed.
    Additionally, you can provide two arguments in the hash part of the table:
    "escape": provide a button index, and it will call his callback when "escape" key is pressed
    "enter": provide a button index, and it will call his callback when "enter" key is pressed

]]

local WarningWindow = Class{
    __includes = {RECT, WTXT},
    init = function(self, _title, _message, _buttonlist)
        self.title_font = FONTS.firaBold(40)
        self.message_font = FONTS.fira(20)
        self.h_gap = 10 --Horizontal gap between title/message/buttons and border of window
        self.v_title_gap = 3 --Vertical gap above and below title
        self.v_message_gap = 9 --Vertical gap above and below message
        self.v_bottom_gap = 20 --Vertical gap below buttons
        self.title = _title
        self.message = _message
        self.h_button_gap = 7 --Gaps between buttons
        self.button_font = FONTS.fira(22)
        self.button_height = 30
        self.buttons = {}
        local total_button_width = 0
        for i = 1, #_buttonlist, 2 do
            local button_text = _buttonlist[i]
            local button_func = _buttonlist[i+1]
            local extra_space = 20 --Extra space to add to buttons width
            local w = extra_space + self.button_font:getWidth(button_text)
            table.insert(self.buttons, But.create_warning(0, 0, w, self.button_height, button_func, button_text, self.button_font))
            total_button_width = total_button_width + w
        end
        total_button_width = total_button_width + (math.max(0,#self.buttons-1)*self.h_button_gap)
        self.message_limit = math.max(400,self.title_font:getWidth(_title) + 2*self.h_gap, total_button_width + 2*self.h_gap) --Limit for wrapping the message text
        self.real_message_w, self.wraptext = self.message_font:getWrap(_message, self.message_limit)

        local width = math.max(self.title_font:getWidth(_title) + 2*self.h_gap, self.real_message_w + 2*self.h_gap, total_button_width + 2*self.h_gap)
        local height = self.title_font:getHeight(_title) + 2*self.v_title_gap + self.message_font:getHeight(_message)*#self.wraptext +2*self.v_message_gap + self.button_height + self.v_bottom_gap
        RECT.init(self, W/2 - width/2, H/2 - height/2, width, height) --Set rect attributes

        --Fix buttons positions
        local but_x = self.pos.x + width/2 - total_button_width/2
        local but_y = self.pos.y + height - self.v_bottom_gap - self.button_height + self.v_message_gap
        for _,but in ipairs(self.buttons) do
            but.pos.x = but_x
            but.pos.y = but_y
            but:centralize()
            but_x = but_x + but.w + self.h_button_gap
        end

        self.bg_color = Color.new(13, 100, 96, 255, "hsl", true)
        self.bg_title_color = Color.new(13, 100, 56, 255, "hsl", true)
        self.bg_contour_color = Color.red()
        self.bg_contour_line_width = 3

        self.escape = _buttonlist.escape
        self.enter = _buttonlist.enter

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
    love.graphics.setColor(30, 0, 0, 130)
    love.graphics.rectangle("fill", 0, 0, W, H)

    love.graphics.push()

    love.graphics.translate(w.pos.x, w.pos.y)

    --Draw background
    Color.set(w.bg_color)
    love.graphics.rectangle("fill", 0, 0, w.w, w.h, 5)
    Color.set(w.bg_title_color)
    love.graphics.rectangle("fill", 0, 0, w.w, w.title_font:getHeight(w.title) + 2*w.v_title_gap, 5)
    love.graphics.setLineWidth(w.bg_contour_line_width)
    Color.set(w.bg_contour_color)
    love.graphics.rectangle("line", 0, 0, w.w, w.h, 5)

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
    Color.set(w.bg_contour_color)
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

    --Draw buttons
    for _, but in ipairs(self.buttons) do
        but:draw()
    end

end

--UTILITY FUNCTIONS--

function funcs.create(title, message, buttonlist)
    local w = WarningWindow(title, message, buttonlist)

    return w
end

local _has_active_window = false
local _dont_pop
--Pushes the Warning Window state
function funcs.show(title, message, buttonlist, dont_pop)
    if _has_active_window == true then
        funcs.deactivate()
    end

    Gamestate.push(GS.WARNINGWIN, title, message, buttonlist, dont_pop)
    _has_active_window = true

end

function funcs.deactivate(dont_pop)
    if not dont_pop then
        Gamestate.pop()
    end
    _has_active_window = false
end


--Return functions
return funcs
