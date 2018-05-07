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
--BUTTON CLASS --

local button = {}

----------
--BUTTON--
----------

Button = Class{
    __includes = {RECT, WTXT},
    init = function(self, _x, _y, _w, _h, _callback, _text, _font, _overtext, _overfont, _color, _mode)

        RECT.init(self, _x, _y, _w, _h, Color.transp(), "fill") --Set atributes

        self.callback  = _callback or function()end  --Function to call when pressed

        WTXT.init(self, _text, _font, nil) --Set text

        self.overtext = _overtext --Text to appear below button if mouse is over
        self.overfont = _overfont --Font of overtext
        self.isOver = false --If mouse is over the self

        self.color = _color

        self.mode = _mode

        button.tp = "button" --Type of this class

        self:centralize()
    end,
    text_color = Color.new(117,90.6,58.5,255,"hsl", true),
    color = Color.transp()
}

function Button:isMouseOver()
    local b = self
    local x, y = love.mouse.getPosition()
    return x >= b.pos.x and
       x <= b.pos.x + b.w and
       y >= b.pos.y and
       y <= b.pos.y + b.h
end

function Button:update(dt)
    local b, x, y

    b = self

    if not b.overtext then return end

    --Fix mouse position click to respective distance
    x, y = love.mouse.getPosition()

    --If mouse is colliding with button, then show message below
    if x >= b.pos.x and
       x <= b.pos.x + b.w and
       y >= b.pos.y and
       y <= b.pos.y + b.h then
           b.isOver = true
   else
       b.isOver = false
   end
end

--Draws a given square button with text aligned to the left
function Button:draw()
    local b, x, w, y

    b = self

    --If the button is the current tab button, will draw an outline around it, that blends well with the pc-box
    if b.is_current_tab then
        --Draws button box (back)--

        --Creating stencil so it doesn't draw in the same area as the actual pc-box
        local stencil = function () love.graphics.rectangle("fill", b.pos.x, b.pos.y, b.w, b.h) end
        love.graphics.stencil(stencil, "replace", 1)
        love.graphics.setStencilTest("notequal", 1)

        local back_color = Color.new(self.color)
        back_color.l = 20
        Color.set(back_color)
        local offset = 3
        love.graphics.rectangle("fill", b.pos.x - offset, b.pos.y - offset, b.w + 2*offset, b.h)

        love.graphics.setStencilTest()
    end

    --Draws button box (front)--
    if b:isMouseOver() then
        local bk = self.color.l
        if self.color.l < 30 then
            self.color.l = self.color.l + 80
        else
            self.color.l = self.color.l * 1.2
        end
        Color.set(self.color)
        self.color.l = bk
    else
        Color.set(self.color)
    end
    love.graphics.rectangle(self.mode or "fill", b.pos.x, b.pos.y, b.w, b.h)

    --Draws button text
    Color.set(self.text_color)
    love.graphics.setFont(b.font)
    love.graphics.print(b.text, b.text_x , b.text_y)

    if b.border_clr then
        Color.set(b.border_clr)
        love.graphics.setLineWidth(3)
        love.graphics.rectangle("line", b.pos.x, b.pos.y, b.w, b.h)
    end

    --Print overtext, aligned with center of the normal text
    if b.overtext and b.isOver then
        love.graphics.setFont(b.overfont)
        x = b.pos.x + b.w/2 - b.overfont:getWidth(b.overtext)/2 --Centralize overtext with text
        y = b.pos.y + b.overfont:getHeight(b.text) + 6 --Get position below text
        love.graphics.print(b.overtext, x, y)
    end

end

function Button:checkCollides(x, y)
    if x < self.pos.x then return false end
    if x > self.pos.x + self.w then return false end
    if y < self.pos.y then return false end
    if y > self.pos.y + self.h then return false end
    self:callback()
    return true
end

-- Centralizes text on button
function Button:centralize()
    local tw, th = self.font:getWidth(self.text), self.font:getHeight()
    self.text_x = self.pos.x + self.w / 2 - tw / 2
    self.text_y = self.pos.y + self.h / 2 - th / 2
end

--UTILITY FUNCTIONS--

function button.create_warning(x, y, w, h, callback, text, font)
    return Button(x, y, w, h, callback, text, font, nil, nil, Color.new(217,2,3,255,"hsl",true))
end

function button.create_tab(x, y, w, h, callback, text, font, overtext, overfont, color, id)
    return Button(x, y, w, h, callback, text, font, overtext, overfont, color)
end


--Return functions
return button
