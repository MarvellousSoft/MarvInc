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
local OpenedEmail = require "classes.opened_email"

Popup = Class{
    __includes = {RECT},
    init = function(self, title, text, clr, b1, b2)
        RECT.init(self,-1, -1, -1, -1, Color.white())
        local w = 2*W/5

        self.border = 10
        self.fnt = FONTS.fira(20)
        self.title_fnt = FONTS.fira(30)
        self.title_h = self.title_fnt:getHeight()
        self.title_clr = clr
        self.w = w

        self.pos.x = (W - w)/2

        self.title = title
        self.text = text
        self.text_clr = Color.black()

        self.border_clr = Color.black()

        self.buttons = {}
        local _bbord = 5 -- button border
        local _w1, _h = 2*_bbord + self.fnt:getWidth(b1.text), self.fnt:getHeight() + _bbord
        -- Relative to popup box
        local _x1 = (self.w - _w1)/2
        local _, _wh = self.fnt:getWrap(self.text, self.w - self.border)
        self.h = #_wh*self.fnt:getHeight() + self.title_fnt:getHeight() + _h + self.border + 100
        local _y = self.h - _h - self.border
        local _w2 = _w1
        if b2 then _w2 = 2*_bbord + self.fnt:getWidth(b2.text) end

        self.pos.y = (H - self.h)/2

        if b2 then
            _x1 = (w/2 - _w1)/2
            local _x2 = _w1 + _x1 + (w-_w1-_x1)/2 - (2*_bbord + self.fnt:getWidth(b2.text))/2
            table.insert(self.buttons, Button(_x2 + self.pos.x, _y + self.pos.y, _w2, _h, b2.func, b2.text, self.fnt, nil,
                nil, b2.clr))
        end
        table.insert(self.buttons, Button(self.pos.x + _x1, self.pos.y + _y, _w1, _h, b1.func, b1.text, self.fnt, nil, nil,
            b1.clr))


        self.tp = "popup"

        self:addElement(DRAW_TABLE.L2, self.tp, self.tp)

        self.back_clr = Color.new(0, 0, 40, 140)
    end
}

function Popup:draw()
    Color.set(self.back_clr)
    love.graphics.rectangle("fill", -5, -5, W+5, W+5)

    Color.set(self.color)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.w, self.h)

    Color.set(self.border_clr)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", self.pos.x, self.pos.y, self.w, self.h)

    Color.set(self.title_clr)
    love.graphics.rectangle("fill", self.pos.x + 5, self.pos.y + 5, self.w - 10,
        self.title_h + 10)

    Color.set(self.color)
    love.graphics.setFont(self.title_fnt)
    love.graphics.printf(self.title, self.pos.x + self.border, self.pos.y + self.border,
        self.w - self.border, "center")

    Color.set(self.text_clr)
    love.graphics.setFont(self.fnt)
    love.graphics.printf(self.text, self.pos.x + self.border, self.pos.y +
        self.title_fnt:getHeight() + 30, self.w - self.border, "left")

    for _, v in ipairs(self.buttons) do
        v:draw()
    end
end

function Popup:mousereleased(x, y, button, touch)
    if button == 1 then
        for _, v in ipairs(self.buttons) do
            if Util.pointInRect(x, y, v) then
                PopManager.quit()
                v.callback()
                return
            end
        end
    end
end

function Popup:keypressed(key)
    if key == "return" and not self.buttons[2] then
        PopManager.quit()
        self.buttons[1].callback()
    end
end

PopManager = {
    -- Current active popup
    pop = nil
}

-- Buttons are of the type:
-- { func = action function,
--   text = button text,
--   clr  = button color }
function PopManager.new(title, text, clr, b1, b2)
    -- close email if any is open, to avoid getting stuck because of our ugly code.
    OpenedEmail.close()
    local pop = Popup(title, text, clr, b1, b2)
    -- Pop the old pop. Stick with the new pop.
    PopManager.pop = pop
    TABS_LOCK = TABS_LOCK + 1
    EVENTS_LOCK = EVENTS_LOCK + 1
end

PopupFailed = Class{
  __includes = {RECT, Popup},
  init = function(self, title, text, b1, bot, bot_n)
      local clr = Color.red()
      RECT.init(self,-1, -1, -1, -1, Color.white())
      local w = 2*W/5
      self.bot = bot
      self.bot_n = bot_n
      self.border = 10
      self.fnt = FONTS.fira(20)
      self.title_fnt = FONTS.fira(30)
      self.title_h = self.title_fnt:getHeight()
      self.title_clr = clr
      self.w = w

      self.pos.x = (W - w)/2

      self.title = title
      self.text = text
      self.text_clr = Color.black()

      self.border_clr = Color.black()

      self.buttons = {}
      local _bbord = 5 -- button border
      local _w1, _h = 2*_bbord + self.fnt:getWidth(b1.text), self.fnt:getHeight() + _bbord
      -- Relative to popup box
      local _x1 = (self.w - _w1)/2
      local _, _wh = self.fnt:getWrap(self.text, self.w - self.border)
      self.h_fix = 100
      self.h = #_wh*self.fnt:getHeight() + self.title_fnt:getHeight() + _h + self.border + 100 + self.h_fix
      local _y = self.h - _h - self.border
      local _w2 = _w1
      if b2 then _w2 = 2*_bbord + self.fnt:getWidth(b2.text) end

      self.pos.y = (H - self.h)/2

      if b2 then
          _x1 = (w/2 - _w1)/2
          local _x2 = _w1 + _x1 + (w-_w1-_x1)/2 - (2*_bbord + self.fnt:getWidth(b2.text))/2
          table.insert(self.buttons, Button(_x2 + self.pos.x, _y + self.pos.y, _w2, _h, b2.func, b2.text, self.fnt, nil,
              nil, b2.clr))
      end
      table.insert(self.buttons, Button(self.pos.x + _x1, self.pos.y + _y, _w1, _h, b1.func, b1.text, self.fnt, nil, nil,
          b1.clr))


      self.tp = "popup"

      self:addElement(DRAW_TABLE.L2, self.tp, self.tp)

      self.back_clr = Color.new(0, 0, 40, 140)
  end,
  mousereleased = Popup.mousereleased,
  keypressed = Popup.keypressed,
  draw = function(self)
    Color.set(self.back_clr)
    love.graphics.rectangle("fill", -5, -5, W+5, W+5)

    Color.set(self.color)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.w, self.h)

    Color.set(self.border_clr)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", self.pos.x, self.pos.y, self.w, self.h)

    Color.set(self.title_clr)
    love.graphics.rectangle("fill", self.pos.x + 5, self.pos.y + 5, self.w - 10,
        self.title_h + 10)

    --Draw title
    Color.set(self.color)
    love.graphics.setFont(self.title_fnt)
    love.graphics.printf(self.title, self.pos.x + self.border, self.pos.y + self.border,
        self.w - self.border, "center")

    --Draw sentence
    Color.set(self.text_clr)
    love.graphics.setFont(self.fnt)
    love.graphics.printf(self.text, self.pos.x + self.border, self.pos.y +
        self.title_fnt:getHeight() + 30, self.w - self.border, "left")

    local _h = self.buttons[1].pos.y - 115
    --Draw bot last words "preview"
    Color.set(self.text_clr)
    love.graphics.setFont(FONTS.fira(14))
    love.graphics.printf("Bot #" .. self.bot_n .. " " .. self.bot.name.. " last words:", self.pos.x + self.border,
        _h - 45, self.w - self.border, "left")

    --Draw bot
    local off = 8
    local i_x, i_y = self.pos.x + self.border + off, _h - 20 + off
    Color.set(Color.black())
    love.graphics.setLineWidth(3)
    love.graphics.rectangle("line", i_x - off/2, i_y - off/2, self.w - 2*self.border, self.bot.body:getHeight() + off, 5)
    Color.set(self.bot.body_clr)
    love.graphics.draw(self.bot.body, i_x, i_y + off)
    Color.set(self.bot.head_clr)
    love.graphics.draw(self.bot.head, i_x, i_y + off)
    Color.set(self.bot.hair_clr)
    love.graphics.draw(self.bot.hair, i_x, i_y + off)

    --Draw last words
    local t_x, t_y = i_x + self.bot.body:getWidth() + 20, i_y + self.bot.body:getHeight()/2 - 20
    Color.set(self.text_clr)
    love.graphics.setFont(FONTS.fira(18))
    love.graphics.printf("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaAA", t_x,
        t_y, self.w - 150, "left")

    --Draw last sentence
    Color.set(self.text_clr)
    love.graphics.setFont(self.fnt)
    love.graphics.printf("A new bot had been dispatched", self.pos.x + self.border,
        _h + 80, self.w - self.border, "center")


    for _, v in ipairs(self.buttons) do
        v:draw()
    end
  end
}


--Creates a "failed puzzle" popup
function PopManager.newFailed(title, sentence, b, bot, bot_n)
    -- close email if any is open, to avoid getting stuck because of our ugly code.
    OpenedEmail.close()
    local pop = PopupFailed(title, sentence, b, bot, bot_n)
    -- Pop the old pop. Stick with the new pop.
    PopManager.pop = pop
    TABS_LOCK = TABS_LOCK + 1
    EVENTS_LOCK = EVENTS_LOCK + 1
end


function PopManager.mousereleased(x, y, button, touch)
    if not PopManager.pop then return end
    PopManager.pop:mousereleased(x, y, button, touch)
end

function PopManager.keypressed(key)
    if not PopManager.pop then return end
    PopManager.pop:keypressed(key)
end

function PopManager.quit()
    PopManager.pop.death = true
    PopManager.pop = nil
    TABS_LOCK = TABS_LOCK - 1
    EVENTS_LOCK = EVENTS_LOCK - 1
end

return PopManager
