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

local getFinalWords

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
        local _h = self.fnt:getHeight() + _bbord
        local _, _wh = self.fnt:getWrap(self.text, self.w - self.border)
        self.h = #_wh*self.fnt:getHeight() + self.title_fnt:getHeight() + _h + self.border + 100
        self.pos.y = (H - self.h)/2
        if b1 then
            local _w1 = 2*_bbord + self.fnt:getWidth(b1.text)
            -- Relative to popup box
            local _x1 = (self.w - _w1)/2
            local _y = self.h - _h - self.border
            local _w2 = _w1
            if b2 then
                _w2 = 2*_bbord + self.fnt:getWidth(b2.text)
                _x1 = (w/2 - _w1)/2
                local _x2 = _w1 + _x1 + (w-_w1-_x1)/2 - (2*_bbord + self.fnt:getWidth(b2.text))/2
                table.insert(self.buttons, Button(_x2 + self.pos.x, _y + self.pos.y, _w2, _h, b2.func, b2.text, self.fnt, nil,
                    nil, b2.clr))
            end
            table.insert(self.buttons, Button(self.pos.x + _x1, self.pos.y + _y, _w1, _h, b1.func, b1.text, self.fnt, nil, nil,
                b1.clr))
        end

        for _, b in ipairs(self.buttons) do b.border_clr = Color.black() end


        self.tp = "popup"

        self:addElement(DRAW_TABLE.L2, self.tp, self.tp)

        self.back_clr = Color.new(0, 0, 40, 140)
    end
}

function Popup:draw()
    Color.set(self.back_clr)
    love.graphics.rectangle("fill", -5, -5, W+5, H+5)

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

    if self.leaderboard_button then
        self.leaderboard_button:draw()
    end

    Color.set(self.text_clr)
    love.graphics.setFont(self.fnt)
    love.graphics.printf(self.text, self.pos.x + self.border, self.pos.y +
        self.title_fnt:getHeight() + 30, self.w - self.border, "left")

    for _, v in ipairs(self.buttons) do
        v:draw()
    end
end

function Popup:translate(dx, dy)
    self.pos.x = self.pos.x + dx
    self.pos.y = self.pos.y + dy
    for _, b in ipairs(self.buttons) do
        b.pos.x = b.pos.x + dx
        b.pos.y = b.pos.y + dy
        b:centralize()
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
        if self.leaderboard_button then
            self.leaderboard_button:checkCollides(x,y)
        end
    end
end

function Popup:keypressed(key)
    if (key == "return" or key == "escape" or key == "kpenter") and self.buttons[1] and not self.buttons[2] then
        PopManager.quit()
        self.buttons[1].callback()
    end
end

function Popup:addLeaderboardsButton(puzzle_id, metrics)
    -- leaderboards on workshop items and normal levels
    local icon = BUTS_IMG.leaderboards_bg
    local on_click = function()
        Gamestate.push(GS.LEADERBOARDS, puzzle_id, {"linecount", "cycles"})
    end
    local size, margin_x, margin_y = 30, 10, 12
    self.leaderboard_button = ImgButton(self.pos.x + self.w - size - margin_x, self.pos.y + margin_y, size, icon, on_click)
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
    if PopManager.pop then
        print("WARNING: Another popup was open. This will probably break the game.")
    end
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

      self.last_words = getFinalWords(self, self.bot)

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

      for _, b in ipairs(self.buttons) do b.border_clr = Color.black() end

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
    love.graphics.setColor(5,0,155)
    love.graphics.setFont(FONTS.fira(14))
    love.graphics.printf("Bot #" .. self.bot_n .. " " .. self.bot.name.. " last words:", self.pos.x + self.border,
        _h - 45, self.w - self.border, "left")

    --Draw bot
    local off = 8
    local i_x, i_y = self.pos.x + self.border + off, _h - 20 + off
    local box_h = self.bot.body:getHeight() + off
    local box_y = i_y - off/2
    Color.set(Color.black())
    love.graphics.setLineWidth(3)
    love.graphics.rectangle("line", i_x - off/2, box_y, self.w - 2*self.border, box_h, 5)
    Color.set(self.bot.body_clr)
    love.graphics.draw(self.bot.body, i_x, i_y + off)
    Color.set(self.bot.head_clr)
    love.graphics.draw(self.bot.head, i_x, i_y + off)
    Color.set(self.bot.hair_clr)
    love.graphics.draw(self.bot.hair, i_x, i_y + off)

    --Draw last words, scaling font down until it fits
    local t_x = i_x + self.bot.body:getWidth() + 20
    Color.set(self.text_clr)
    local wrap
    local wraplimit = self.w - 150
    local font_s = 25
    repeat
        font_s = font_s - 1
        _, wrap = FONTS.fira(font_s):getWrap(self.last_words, wraplimit)
    until #wrap <= 2
    local font = FONTS.fira(font_s)
    local t_y = box_y + box_h/2 - font:getHeight()*#wrap/2
    love.graphics.setFont(font)
    love.graphics.printf(self.last_words, t_x,
        t_y, wraplimit, "left")

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
    if PopManager.pop then
        print("WARNING: Another popup was open. This will probably break the game.")
    end
    -- Pop the old pop. Stick with the new pop.
    PopManager.pop = pop
    TABS_LOCK = TABS_LOCK + 1
    EVENTS_LOCK = EVENTS_LOCK + 1
end

PopupProgress = Class {
    __includes = Popup,
}

-- get_progress is a function that returns how much progress (a number in [0, 1])
-- This popup should be manually closed using PopManager.quit
function PopupProgress:init(text, clr, get_progress)
    Popup.init(self, text, "", clr)
    self.get_progress = get_progress
end

function PopupProgress:draw()
    Popup.draw(self)
    local p = self.get_progress()
    -- Drawing progress bar
    local b_w, b_h = self.w * 0.6, 40
    local b_x, b_y = self.pos.x + (self.w - b_w) / 2, self.pos.y + (self.h - b_h) / 2
    local bb = 5 -- border
    love.graphics.setLineWidth(1)
    Color.set(self.title_clr)
    love.graphics.rectangle('line', b_x, b_y, b_w, b_h)
    love.graphics.rectangle('fill', b_x + bb, b_y + bb, (b_w - 2 * bb) * p, b_h - 2 * bb)
end

function PopManager.newProgress(...)
    -- close email if any is open, to avoid getting stuck because of our ugly code.
    OpenedEmail.close()
    local pop = PopupProgress(...)
    if PopManager.pop then
        print("WARNING: Another popup was open. This will probably break the game.")
    end
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
    if PopManager.pop then
        PopManager.pop.death = true
        PopManager.pop = nil
        TABS_LOCK = TABS_LOCK - 1
        EVENTS_LOCK = EVENTS_LOCK - 1
    end
end

function getFinalWords(popup,bot)
  local special_messages = {}
  local regular_messages = {}

  --Special flags
  local all_caps = false
  local shy = false

  --Get all messages related to bot traits
  for _,traits in ipairs(TRAITS) do
    for _,bot_traits in ipairs(bot.traits) do
      if traits[1] == bot_traits then
        for _,message in ipairs(traits[3]) do
          table.insert(special_messages, message)
        end
      end
    end
  end

  --Insert regular messages
  for _,dialog in ipairs(REGULAR_DYING_MESSAGES) do
    table.insert(regular_messages,dialog)
  end

  --Insert death-related messages
  if popup.title == FAILED_POPUP_MESSAGES["code_over"].title then
    table.insert(special_messages, "Yay!! So we finished the puzzle??")
    table.insert(special_messages, "So are we done here?")
  elseif popup.title == FAILED_POPUP_MESSAGES["lava"].title then
    table.insert(special_messages, "Did someone turn on the heat around here?")
    table.insert(special_messages, "Something about entering a pool of lava doesn't seem right...")
  elseif popup.title == FAILED_POPUP_MESSAGES["paint_container"].title then
    table.insert(special_messages, "Wait, do I REALLY need to enter giant paint container? Well, you're the boss...")
  elseif popup.title == FAILED_POPUP_MESSAGES["laser"].title then
    table.insert(special_messages, "This laser beam sure seems harmless.")
  end

  -----------------------------
  --Check for special actions--
  -----------------------------

  for _,bot_traits in ipairs(bot.traits) do
    if bot_traits == "TYPES IN ALL CAPS" then
      all_caps = true
    elseif bot_traits == "terribly shy" then
      shy = true
    end
  end

  -------------------------
  --Apply special actions--
  -------------------------

  --Transform all messages to caps
  if all_caps then
    for i,dialog in ipairs(regular_messages) do
        regular_messages[i] = string.upper(dialog)
    end
    for i,dialog in ipairs(special_messages) do
        special_messages[i] = string.upper(dialog)
    end
  end

  --Stutters in the first word (TODO: For every word have a chance to stutter)
  if shy then
    local shy_dialog
    for i,dialog in ipairs(regular_messages) do
        if dialog:sub(1,1):match("%a") then
          shy_dialog = dialog:sub(1,1) .. "-"..dialog
          regular_messages[i] = shy_dialog
        end
    end
    for i,dialog in ipairs(special_messages) do
        if dialog:sub(1,1):match("%a") then
          shy_dialog = dialog:sub(1,1) .. "-"..dialog
          special_messages[i] = shy_dialog
        end
    end
  end

  -----------------------------

  --Chances of special messages increases if there are more, capped at .6
  local chance = 0
  chance = math.min(.6, .3*#special_messages)

  --Choose between special messages or regular messages
  if love.math.random() <= chance then
      return Util.randomElement(special_messages)
  else
      return Util.randomElement(regular_messages)
  end

end

return PopManager
