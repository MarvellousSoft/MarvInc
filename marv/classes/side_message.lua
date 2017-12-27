--Marvellous Inc.
--Copyright (C) 2017  MarvellousSoft
--See full license in file LICENSE.txt

require "classes.primitive"
local Color = require "classes.color.color"

--Local Functions--

local getDialog

--Side Message Class

SideMessage = Class{
    __includes = {RECT},

    init = function(self, name, message, image, image_color, height)

        local width = 280
        height = height or 100
        RECT.init(self, W, H - height - 160, width, height)

        self.name = name

        self.message = message

        self.name_font = FONTS.fira(16)
        self.body_font = FONTS.fira(13)

        self.image = image
        self.image_color = image_color or Color.white()

        --Portrait values
        self.portrait_offset_x = 0
        self.portrait_offset_y = 0
        self.portrait_scale_x = 1
        self.portrait_scale_y = 1

        self.duration = 10 --How many seconds the message stay onscreen

        self.tp = "side_message"
    end
}

function SideMessage:draw()

    --Draw the background
    Color.set(Color.new(206,83,31,255,'hsl', true))
    love.graphics.rectangle("fill", self.pos.x-7, self.pos.y+7, self.w, self.h,5)
    Color.set(Color.white())
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.w, self.h,5)

    --Draw Portrait Background
    local portrait_w, portrait_h = 60, 60
    local portrait_x, portrait_y = self.pos.x + 10, self.pos.y + self.h/2 - portrait_h/2
    Color.set(Color.new(206,9,81,255,'hsl', true))
    love.graphics.rectangle("fill", portrait_x-7, portrait_y+7, portrait_w, portrait_h, 5)
    Color.set(Color.white())
    love.graphics.rectangle("fill", portrait_x, portrait_y, portrait_w, portrait_h, 5)

    --Draw portrait
    Color.set(self.image_color)
    love.graphics.draw(self.image, portrait_x + self.portrait_offset_x, portrait_y + self.portrait_offset_y, 0, self.portrait_scale_x,self.portrait_scale_y)

    local text_h = 20 + self.body_font:getHeight() * #select(2, self.body_font:getWrap(self.message, self.w - portrait_w - 25))
    local text_y = self.pos.y + self.h / 2 - text_h / 2

    --Draw message author
    love.graphics.setFont(self.name_font)
    Color.set(Color.black())
    love.graphics.print("Bot "..self.name..":", portrait_x + portrait_w + 10, text_y)

    --Draw message content
    love.graphics.setFont(self.body_font)
    Color.set(Color.black())
    love.graphics.printf(self.message, portrait_x + portrait_w + 10, text_y + 20, self.w - portrait_w - 25)

end

function SideMessage:setPortraitOffset(x,y)

    if x then self.portrait_offset_x = x end
    if y then self.portrait_offset_y = y end

end

function SideMessage:setPortraitScale(x,y)

    if x then self.portrait_scale_x = x end
    if y then self.portrait_scale_y = y end

end

function SideMessage:activate()

    --Create initial effect
    self.handles["start_movement"] = MAIN_TIMER:tween(.3, self.pos, {x = self.pos.x - self.w}, "in-out-quad")

    --Play sfx
    SFX.side_message:play()

    --Move all other messages up
    local all_messages = Util.findSbTp("side_message")
    for bot_m in pairs(all_messages) do
        if bot_m ~= self then
            local handle = MAIN_TIMER:tween(.5, bot_m.pos, {y = bot_m.pos.y - bot_m.h - 10}, 'out-back')
            table.insert(bot_m.handles, handle)
        end
    end

    --Start time to destroy message
    self.handles["destroy"] = MAIN_TIMER:after(self.duration,
          function()
              self:deactivate()
          end
    )

end

function SideMessage:deactivate()

    --Remove timer if exists
    if self.handles["destroy"] then
        MAIN_TIMER:cancel(self.handles["destroy"])
    end

    --Let animation happen if is already deactivating
    if self.handles["leave_movement"] then return end

    self.handles["leave_movement"] = MAIN_TIMER:tween(.2, self.pos, {x = self.pos.x + self.w}, "in-linear",
        function()
            self.death = true
        end
    )

end

--Deactivates a message if its clicked upon
function SideMessage:mousepressed(x,y)

    if x >= self.pos.x and x <= self.pos.x + self.w and
       y >= self.pos.y and y <= self.pos.y + self.h then
        self:deactivate()
    end

end


--Register signal to create a bot_message signal
Signal.register("new_bot_message",
    function(text, height)
        local bot = ROOM.bot
        if not bot then return end
        local message = SideMessage(bot.name, text or getDialog(bot), bot.head, Color.new(bot.head_clr.h, 200, 200), height)

        --Add message to the game
        message:addElement(DRAW_TABLE.GUI, "side_message")
        message:setPortraitOffset(-5,0) --Offset for bot portrait image

        message:activate()

        return message
    end
)

--Register signal to create a custom side message
Signal.register("new_side_message",
    function(name, text, image, offset, scale)

        local message = SideMessage(name, text, image, Color.white())

        --Add message to the game
        message:addElement(DRAW_TABLE.GUI, "side_message")
        message:activate()

        if offset then
            message:setPortraitOffset(unpack(offset))
        end

        if scale then
            message:setPortraitScale(unpack(scale))
        end

        return message
    end
)

--UTILITY FUNCTIONS

--Function returns a dialog text based on bots stats
getDialog = function(bot)
    local special_messages = {}
    local regular_messages = {}
    local intro_messages = {}

    --Special flags
    local all_caps = false
    local lost_an_eye = false
    local hates_bears = false
    local underachiever = false
    local overachiever = false
    local shy = false
    local sexual_innuendos = false
    local pirate = false

    --Get all dialogs related to bot traits
    for _,traits in ipairs(TRAITS) do
      for _,bot_traits in ipairs(bot.traits) do
        if traits[1] == bot_traits then
          for _,dialog in ipairs(traits[2]) do
            table.insert(special_messages, dialog)
          end
        end
      end
    end

    --Insert regular dialogs
    for _,dialog in ipairs(REGULAR_DIALOGS) do
      table.insert(regular_messages,dialog)
    end

    if bot.first_time then
      --Insert introduction dialogs, replacing {bot_name} with actual name
      for _,dialog in ipairs(INTRO_DIALOGS) do
        local text = ""
        for w in dialog:gmatch("{?[^{}]+}?") do
          if w == "{bot_name}" then
            text = text .. bot.name
          else
            text = text .. w
          end
        end
        table.insert(intro_messages,text)
      end
    end

    -----------------------------
    --Check for special actions--
    -----------------------------

    for _,bot_traits in ipairs(bot.traits) do
      if bot_traits == "TYPES IN ALL CAPS" then
        all_caps = true
      elseif bot_traits == "lost an eye in a bear accident" then
        lost_an_eye = true
      elseif bot_traits == "hates bears" then
        hates_bears = true
      elseif bot_traits == "overachiever" then
        overachiever = true
      elseif bot_traits == "underachiever" then
        underachiever = true
      elseif bot_traits == "accidently makes sexual innuendos" then
        sexual_innuendos = true
      elseif bot_traits == "thinks it's a pirate" then
        pirate = true
      elseif bot_traits == "terribly shy" then
        shy = true
      end
    end

    ---------------------------------
    --Add ~really~ special messages--
    ---------------------------------

    if hates_bears and lost_an_eye then
      table.insert(special_messages, "Come to think of it, I hated bears long after the eye accident...huh")
      table.insert(special_messages, "Come to think of it, I hated bears long after the eye accident...huh")
    end

    if overachiever and underachiever then
      table.insert(special_messages, "I'm living a paradox!!")
      table.insert(special_messages, "I'm living a paradox!!")
    end

    if sexual_innuendos and bot.name == "Fanny" then
      table.insert(special_messages, "Mother would always say how her little Fanny was the most beautiful thing.")
      table.insert(special_messages, "Mother would always say how her little Fanny was the most beautiful thing.")
    end

    if pirate and lost_an_eye then
      table.insert(special_messages, "Funny thing is I was already wearing an eye patch before the accident!")
      table.insert(special_messages, "Funny thing is I was already wearing an eye patch before the accident!")
    end

    if pirate and bot.first_time then
      table.insert(intro_messages, "Ahoy matey! Call me captain "..bot.name..".")
      table.insert(intro_messages, "Ahoy matey! Call me captain "..bot.name..".")
      table.insert(intro_messages, "Ahoy matey! Call me captain "..bot.name..".")
      table.insert(intro_messages, "Ahoy matey! Call me captain "..bot.name..".")
    end

    if bot.name == "Gerry" then
      table.insert(intro_messages, "Hey I'm Gerry! But you can call me Gary if you want...")
      table.insert(intro_messages, "Hey I'm Gerry! But you can call me Gary if you want...")
      table.insert(intro_messages, "Hey I'm Gerry! But you can call me Gary if you want...")
      table.insert(intro_messages, "Hey I'm Gerry! But you can call me Gary if you want...")
    end

    if shy then
      table.insert(intro_messages, "....hi")
      table.insert(intro_messages, "....hi")
      table.insert(intro_messages, "....hi")
      table.insert(intro_messages, "....hi")
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
      for i,dialog in ipairs(intro_messages) do
          intro_messages[i] = string.upper(dialog)
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
      for i,dialog in ipairs(intro_messages) do
          if dialog:sub(1,1):match("%a") then
            shy_dialog = dialog:sub(1,1) .. "-"..dialog
            intro_messages[i] = shy_dialog
          end
      end

    end

    -----------------------------

    --If its bot first time appearing
    if bot.first_time then
      BotModule.current_bot.first_time = false
      return Util.randomElement(intro_messages)
    end

    --Chances of special messages increases if there are more, capped at .6
    local chance = 0
    chance = math.min(.6, .08*#special_messages)

    --Choose between special messages or regular messages
    if love.math.random() <= chance then
        return Util.randomElement(special_messages)
    else
        return Util.randomElement(regular_messages)
    end

end
