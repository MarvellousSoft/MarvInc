--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local Color = require "classes.color.color"
require "classes.primitive"

-- Assumes it is a square
ImgButton = Class{
    __include = {RECT},
    init = function(self, x, y, sz, img, callback, hvr_txt)
        RECT.init(self, x, y, sz, sz, Color.white())

        self.call = callback
        self.img = img
        self.hover_text = hvr_txt

        self.scale = sz / img:getWidth()

        self.tp = "img_button"
    end
}


function ImgButton:draw()
    local mx, my = love.mouse.getPosition()
    local hover = Util.pointInRect(self.mx or mx, self.my or my, self)


    if self.highlight and self:highlight() then
        love.graphics.setColor(128, 255, 128, 255)
        love.graphics.rectangle('line', self.pos.x, self.pos.y, self.w, self.h)
    end

    self.color.l = 255
    self.color.a = 255
    Color.set(self.color)
    local img = self.img
    if hover and self.hover_img and Gamestate.current() ~= GS.WARNINGWIN and not Util.findId("opened_email") then img = self.hover_img end
    love.graphics.draw(img, self.pos.x, self.pos.y, 0, self.scale, self.scale)

    if hover and Gamestate.current() ~= GS.WARNINGWIN and not Util.findId("opened_email") then
        self.color.l = 50
        self.color.a = 90
        Color.set(self.color)
        love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.w, self.h)
    end
    if hover and self.hover_text and Gamestate.current() ~= GS.WARNINGWIN and not Util.findId("opened_email") then
        local f = FONTS.fira(17)
        Color.set(Color.black())
        local x, y = self.pos.x + (self.w - f:getWidth(self.hover_text)) / 2, self.pos.y + self.h + 1
        if not self.hover_img then
            love.graphics.rectangle("fill", x - 2, y - 2, f:getWidth(self.hover_text) + 4, f:getHeight() + 4)
        end
        Color.set(self.color)
        love.graphics.setFont(f)
        love.graphics.print(self.hover_text, x, y)
    end
end

function ImgButton:block(block_img)
    assert(not self.blocked)
    self.blocked = true
    self.unblocked_img = self.img
    self.img = block_img
end

function ImgButton:unblock()
    if not self.blocked then return end
    self.blocked = false
    self.img = self.unblocked_img
end

function ImgButton:checkCollides(x, y)
    if Util.pointInRect(x, y, self) then
        if self.blocked then
            SFX.buzz:play()
        else
            self.call()
        end
    end
end

function ImgButton:mousePressed(x, y, but)
    if Util.findId("opened_email") then return end
    if but == 1 and Util.pointInRect(x, y, self) then
        if self.blocked then
            SFX.buzz:play()
        else
            self.call()
        end
    end
end
