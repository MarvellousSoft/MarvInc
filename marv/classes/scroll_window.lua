--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

--[[
  Scroll Window

  A scroll window has an object and draws part of that object, with a vertical scrollbar if necessary.
  The object is received as the 3rd argument of its constructor and should contain the following fields:
    - getHeight: function that returns the TRUE height of the object (not the height after cutting it)
    - pos: a Vector with the position of the object
    - draw: a function that draws the object, starting on (pos.x, pos.y) as usual, not caring about the scrollbar or possible translation

  You must call the functions draw, mouseMoved, mousePressed, mouseReleased, mouseScroll and update of the ScrollWindow. The window will then call these methods in the object, if the object has them (the coordinates will be fixed according to the translation).
]]

local ResManager = require "res_manager"

local ScrollWindow = Class {
    __includes = {ELEMENT},
    default_width = 15
}

function ScrollWindow:init(w, h, obj, scroll_min, scroll_speed)
    ELEMENT.init(self)
    self.w = w
    self.h = h
    self.obj = obj

    self.scrolled = 0 -- [0, 1] how much it scrolled
    self.sw = ScrollWindow.default_width -- scrollbar width
    self.on_grab = false -- currently mouse is grabbing scrollbar
    self.scroll_min = scroll_min -- minimum scroll size, if nil there is no minimum
    self.scroll_speed = scroll_speed -- how much the scroll wheel affects scrolling (defaults to 10)
end

local function scrollBarBounds(self)
    local sh = self.h / self.obj:getHeight() * self.h
    return
        self.obj.pos.x + self.w, -- x
        self.obj.pos.y + self.scrolled * (self.h - sh), -- y
        self.sw, -- width
        sh -- height
end


function ScrollWindow:draw()
    local oh = self.obj:getHeight()
    -- In this case, just draw it normally
    if oh <= self.h then
        self.obj:draw()
        return
    end

    -- Need to be careful because scissors are not affected by translation, etc.
    local x, y = ResManager.toRealCoords(self.obj.pos.x, self.obj.pos.y)
    local sc = ResManager.scale()
    love.graphics.setScissor(x, y, self.w * sc, self.h * sc)
    love.graphics.translate(0, -(oh - self.h) * self.scrolled)
    self.obj:draw()
    love.graphics.translate(0, (oh - self.h) * self.scrolled)
    love.graphics.setScissor()

    local normalAlpha, hoverAlpha, grabAlpha = 200, 230, 255

    local r, g, b
    if self.color then
        r, g, b = unpack(self.color)
    else
        r, g, b = 50, 50, 50
    end

    -- Drawing scroll bar
    if self.on_grab then
        love.graphics.setColor(r, g, b, grabAlpha)
    elseif self.on_hover then
        love.graphics.setColor(r, g, b, hoverAlpha)
    else
        love.graphics.setColor(r, g, b, normalAlpha)
    end
    love.graphics.rectangle('fill', scrollBarBounds(self))
end

-- translates this scrollwindow by dy
-- dy is actually how much the SCROLL BAR will move, not how
-- much the actual object being drawn will move.
local function translate(self, dy)
    local oh = self.obj:getHeight()
    local sx, sy, sw, sh = scrollBarBounds(self)
    if self.scroll_min then
        local s = self.scroll_min * (self.h - sh) / (oh - self.h)
        if dy > 0 then dy = math.floor(dy / s) * s
        else dy = math.ceil(dy / s) * s end
    end
    sy = sy - self.obj.pos.y
    local max_y = self.h - sh
    sy = math.min(math.max(sy + dy, 0), max_y)
    self.scrolled = sy / max_y
    return dy
end

-- translates the OBJECT being drawn by dy
function ScrollWindow:translateScreen(dy)
    local sx, sy, sw, sh = scrollBarBounds(self)
    local oh = self.obj:getHeight()
    local s = dy * (self.h - sh) / (oh - self.h)
    translate(self, s)
end

function ScrollWindow:update(dt)
    if not love.mouse.isDown(1) then self.on_grab = false end
    if self.on_grab then
        local mx, my = love.mouse.getPosition()
        self.base_y = self.base_y + translate(self, my - self.base_y)
    end
end

function ScrollWindow:mousePressed(x, y, but)
    if not Util.pointInRect(x, y, self.obj.pos.x, self.obj.pos.y, self.w, self.h)
        and not Util.pointInRect(x, y, scrollBarBounds(self)) then return end
    local oh = self.obj:getHeight()
    if self.obj.mousePressed then
        if oh <= self.h then self.obj:mousePressed(x, y, but)
        else self.obj:mousePressed(x, y + self.scrolled * (oh - self.h), but) end
    end
    if oh <= self.h or but ~= 1 or not Util.pointInRect(x, y, scrollBarBounds(self)) then return end
    self.on_grab = true
    self.base_y = y
end

function ScrollWindow:mouseReleased(x, y, but)
    if not Util.pointInRect(x, y, self.obj.pos.x, self.obj.pos.y, self.w, self.h)
        and not Util.pointInRect(x, y, scrollBarBounds(self)) then return end
    if self.obj.mouseReleased then
        local oh = self.obj:getHeight()
        if oh <= self.h then self.obj:mouseReleased(x, y, but)
        else self.obj:mouseReleased(x, y + self.scrolled * (oh - self.h), but) end
    end
end

function ScrollWindow:mouseMoved(x, y, dx, dy)
    local oh = self.obj:getHeight()
    if oh > self.h and Util.pointInRect(x, y, scrollBarBounds(self)) then self.on_hover = true
    else self.on_hover = false end
    if not Util.pointInRect(x, y, self.obj.pos.x, self.obj.pos.y, self.w, self.h) then return end
    if self.obj.mouseMoved then
        if oh <= self.h then self.obj:mouseMoved(x, y, dx, dy)
        else self.obj:mouseMoved(x, y + self.scrolled * (oh - self.h), dx, dy) end
    end
end

function ScrollWindow:mouseScroll(x, y)
    if self.obj.mouseScroll then self.obj:mouseScroll(x, y) end
    local mx, my = love.mouse.getPosition()
    if Util.pointInRect(mx, my, self.obj.pos.x, self.obj.pos.y, self.w, self.h) then
        self:translateScreen((self.scroll_min or self.scroll_speed or 10) * -y)
    end
end

return ScrollWindow
