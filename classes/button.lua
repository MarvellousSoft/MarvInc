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
    init = function(self, _x, _y, _w, _h, _func, _text, _font, _overtext, _overfont, _color)

        RECT.init(self, _x, _y, _w, _h, Color.transp(), "fill") --Set atributes

        self.func  = _func  --Function to call when pressed

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

    love.graphics.rectangle("fill", b.pos.x, b.pos.y, b.w, b.h)
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

end

-- Centralizes text on button
function Button:centralize()
    local tw, th = self.font:getWidth(self.text), self.font:getHeight()
    self.text_x = self.pos.x + self.w / 2 - tw / 2
    self.text_y = self.pos.y + self.h / 2 - th / 2
end

--UTILITY FUNCTIONS--

function button.create_gui(x, y, w, h, func, text, font, overtext, overfont, color)
    local b

    b = Button(x, y, w, h, func, text, font, overtext, overfont, color)
    b:addElement(DRAW_TABLE.GUI, "gui")

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

    if BUTTON_LOCK then return end --If buttons are locked, does nothing
    --Iterate on drawable buttons table
    for b in pairs(Util.findSbTp "gui") do
        if x  <= b.pos.x + b.w and
          x >= b.pos.x and
          y  <= b.pos.y + b.h and
          y >= b.pos.y then
            b:func()
            return
        end
    end

end

--Return functions
return button