require "classes.primitive"
local Color = require "classes.color.color"

--Local Functions--

local getDialog

--Bot Message Class

BotMessage = Class{
    __includes = {RECT},

    init = function(self, name, message, image)

        local width, height = 200, 100
        RECT.init(self, W, H - height - 160, width, height)

        self.name = name

        self.message = message

        self.font = FONTS.fira(17)

        self.image = image

        self.duration = 6 --How many seconds the message stay onscreen

        self.tp = "bot_message"
    end
}

function BotMessage:draw()

    --Draw the background
    Color.set(Color.white())
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.w, self.h)

    --Draw message content
    love.graphics.setFont(self.font)
    Color.set(Color.black())
    love.graphics.printf(self.message, self.pos.x + 10, self.pos.y + 10, self.w - 20)

end

--Register signal to create a bot signal
Signal.register("new_bot_message",
    function()
        local bot = BotModule.current_bot
        local message = BotMessage(bot.name, getDialog(bot), bot.head)

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
    table.insert(messages, "hello there")


    return Util.randomElement(messages)
end
