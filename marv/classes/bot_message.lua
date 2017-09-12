require "classes.primitive"
local Color = require "classes.color.color"

--Local Functions--

local getDialog

--Bot Message Class

BotMessage = Class{
    __includes = {RECT},

    init = function(self, name, message, image, image_color)

        local width, height = 280, 100
        RECT.init(self, W, H - height - 160, width, height)

        self.name = name

        self.message = message

        self.name_font = FONTS.fira(16)
        self.body_font = FONTS.fira(13)

        self.image = image
        self.image_color = image_color or Color.white()

        self.duration = 12 --How many seconds the message stay onscreen

        self.tp = "bot_message"
    end
}

function BotMessage:draw()

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
    love.graphics.draw(self.image, portrait_x - 5, portrait_y, 0, 1,1)

    --Draw message author
    love.graphics.setFont(self.name_font)
    Color.set(Color.black())
    love.graphics.print("Bot "..self.name..":", portrait_x + portrait_w + 10, portrait_y)

    --Draw message content
    love.graphics.setFont(self.body_font)
    Color.set(Color.black())
    love.graphics.printf(self.message, portrait_x + portrait_w + 10, portrait_y + 20, self.w - portrait_w - 25)

end

--Register signal to create a bot signal
Signal.register("new_bot_message",
    function()
        local bot = BotModule.current_bot
        if not bot then return end
        local message = BotMessage(bot.name, getDialog(bot), HEAD[bot.head_i], Color.new(bot.head_clr, 200, 200))

        --Add message to the game
        message:addElement(DRAW_TABLE.GUI, "bot_message")

        --Create initial effect
        message.handles["start_movement"] = MAIN_TIMER:tween(.3, message.pos, {x = message.pos.x - message.w}, "out-quad")

        --Move all other messages up
        local all_messages = Util.findSbTp("bot_message")
        for bot_m in pairs(all_messages) do
            if bot_m ~= message then
                local handle = MAIN_TIMER:tween(.5, bot_m.pos, {y = bot_m.pos.y - bot_m.h - 10}, 'out-back')
                table.insert(bot_m.handles, handle)
            end
        end

        --Start time to destroy message
        message.handles["destroy"] = MAIN_TIMER:after(message.duration,
            function()
                message.handles["leave_movement"] = MAIN_TIMER:tween(.5, message.pos, {x = message.pos.x + message.w}, "in-quad",
                    function()
                        message.death = true
                    end
                )
            end
        )

    end
)

--UTILITY FUNCTIONS

--Function returns a dialog text based on bots stats
getDialog = function(bot)
    local messages = {}

    local all_caps = false

    --Get all dialogs related to bot traits
    for _,traits in ipairs(TRAITS) do
      for _,bot_traits in ipairs(bot.traits) do
        if traits[1] == bot_traits then
          for _,dialog in ipairs(traits[2]) do
            table.insert(messages, dialog)
          end
        end
      end
    end

    --Insert regular dialogs
    for _,dialog in ipairs(REGULAR_DIALOGS) do
      table.insert(messages,dialog)
    end

    --Make special actions
    for _,bot_traits in ipairs(bot.traits) do
      if bot_traits == "TYPES IN ALL CAPS" then
        all_caps = true
      end
    end

    if all_caps then
      for i,dialog in ipairs(messages) do
          messages[i] = string.upper(dialog)
      end
    end

    return Util.randomElement(messages)
end
