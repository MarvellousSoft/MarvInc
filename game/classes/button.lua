require "classes.primitive"
local Color = require "classes.color.color"
--BUTTON CLASS --

local button = {}

------------
--INV BUTTON
------------

--[[Text button with an invisible box behind (for collision)]]
Button = Class{
    __includes = {RECT, WTXT},
    init = function(self, _x, _y, _w, _h, _callback, _text, _font, _overtext, _overfont, _color)

        RECT.init(self, _x, _y, _w, _h, Color.transp(), "fill") --Set atributes

        self.callback  = _callback  --Function to call when pressed

        WTXT.init(self, _text, _font, nil) --Set text

        self.overtext = _overtext --Text to appear below button if mouse is over
        self.overfont = _overfont --Font of overtext
        self.isOver = false --If mouse is over the self

        self.color = _color

        --Variables for "new email notification" bounce effect
        self.bounce_y = 0 --Bounce value to add to email notification
        self.bounce_speed = 22 --Speed of bounce motion
        self.bounce_min = -10 --Max value of bounce
        self.bounce_max = 0 --Min value of bounce
        self.bounce_motion = "up" --Direction bounce is doing

        button.tp = "button" --Type of this class

        self:centralize()
    end,
    text_color = Color.green(),
    color = Color.transp()
}

function Button:update(dt)
    local b, x, y

    b = self

    --"New email" effect for Email Tab
    if b.text == "email" then
        if b.bounce_motion == "up" then
            b.bounce_y = b.bounce_y - dt*b.bounce_speed
            if b.bounce_y < b.bounce_min then
                b.bounce_motion = "down"
            end
        else
            b.bounce_y = b.bounce_y + dt*b.bounce_speed
            if b.bounce_y > b.bounce_max then
                b.bounce_motion = "up"
            end
        end
    end

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

    --Draws button text
    Color.set(self.color)

    love.graphics.rectangle("fill", b.pos.x, b.pos.y, b.w, b.h, 10)
    Color.set(self.text_color)
    love.graphics.setFont(b.font)
    love.graphics.print(b.text, b.text_x , b.text_y)

    --Print overtext, aligned with center of the normal text
    if b.overtext and b.isOver then
        love.graphics.setFont(b.overfont)
        x = b.pos.x + b.w/2 - b.overfont:getWidth(b.overtext)/2 --Centralize overtext with text
        y = b.pos.y + b.overfont:getHeight(b.text) + 6 --Get position below text
        love.graphics.print(b.overtext, x, y)
    end

    --Display unread emails notification
    if b.text == "email" and UNREAD_EMAILS > 0 then
        local text --Text will be "new!" if outside a puzzle, else just "!"
        if ROOM.mode == "online" then
            text = "!"
        else
            text = "new!"
        end
        local font = FONTS.fira(20)
        local fx = font:getWidth(text)
        local fy = font:getHeight(text)
        local x, y, w, h = b.pos.x + 10, b.pos.y + b.bounce_y - 5, fx + 14, fy + 5

        -- Draw red box
        Color.set(Color.new(354,90,61,255,"hsl",true))
        love.graphics.rectangle("fill", x, y, w, h, 9)

        -- Draw "new email' text
        Color.set(Color.new(354,0,100,255,"hsl",true))

        love.graphics.setFont(font)
        love.graphics.print(text, x + (w - fx)/2, y + (h - fy)/2)
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

function button.create_tab(x, y, w, h, callback, text, font, overtext, overfont, color, id)
    return Button(x, y, w, h, callback, text, font, overtext, overfont, color)
end


--Return functions
return button
