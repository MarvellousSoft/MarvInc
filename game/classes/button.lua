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

        button.tp = "button" --Type of this class

        self:centralize()
    end
}

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

    --Draws button text
    Color.set(self.color)

    love.graphics.rectangle("fill", b.pos.x, b.pos.y, b.w, b.h, 10)
    Color.set(Color.green())
    love.graphics.setFont(b.font)
    love.graphics.print(b.text, b.text_x , b.text_y)

    --Print overtext, aligned with center of the normal text
    if b.overtext and b.isOver then
        love.graphics.setFont(b.overfont)
        x = b.pos.x + b.w/2 - b.overfont:getWidth(b.overtext)/2 --Centralize overtext with text
        y = b.pos.y + b.overfont:getHeight(b.text) + 6 --Get position below text
        love.graphics.print(b.overtext, x, y)
    end

    -- Display unread emails notification
    if b.id == "email_tab_but" and UNREAD_EMAILS > 0 then
        -- Draw number of unread emails
        Color.set(Color.new(255,0,230))
        love.graphics.setFont(FONTS.fira(14))
        love.graphics.print("new!", b.pos.x + 140, b.pos.y + 6)
    end

end

function Button:checkCollides(x, y)
    if x < self.pos.x then return false end
    if x > self.pos.x + self.w then return false end
    if y < self.pos.y then return false end
    if y > self.pos.y + self.h then return false end
    self:callback()
end

-- Centralizes text on button
function Button:centralize()
    local tw, th = self.font:getWidth(self.text), self.font:getHeight()
    self.text_x = self.pos.x + self.w / 2 - tw / 2
    self.text_y = self.pos.y + self.h / 2 - th / 2
end

--UTILITY FUNCTIONS--

function button.create_tab(x, y, w, h, callback, text, font, overtext, overfont, color, id)
    local b

    b = Button(x, y, w, h, callback, text, font, overtext, overfont, color)
    b:addElement(DRAW_TABLE.L1u, "tabs", id)

    return b
end


---------------------
--COLLISION FUNCTIONS
---------------------

--Check if a mouse click collides with any button
function button.checkCollision(x,y)
    --Fix mouse position click to respective distance

    checkButtonCollision(x,y)

end

--Check if a mouse click collides with any inv button
function checkButtonCollision(x,y)

    if TABS_LOCK then return end --If buttons are locked, does nothing
    --Iterate on drawable buttons table
    if not Util.findSbTp "tabs" then return end
    for b in pairs(Util.findSbTp "tabs") do
        b:checkCollides(x, y)
    end

end

--Return functions
return button
