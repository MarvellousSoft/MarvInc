require "classes.primitive"
local Color = require "classes.color.color"

--Local Functions--

local getDialog

--Bot Message Class

BotMessage = Class{
    __includes = {RECT},

    init = function(self, name, message, image)

        local width, height = 200, 90
        RECT.init(self, W, H - height, width, height)

        self.name = name

        self.message = message

        self.image = image

        self.duration = 2 --How many seconds the message stay onscreen

        self.tp = "bot_message"
    end
}

function BotMessage:draw()

    Color.set(Color.white())
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.w, self.h)

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

        --Start time to destroy message
        message.handles["destroy"] = MAIN_TIMER:after(message.duration,
            function()
                message.handles["leave_movement"] = MAIN_TIMER:tween(.3, message.pos, {x = message.pos.x + message.w}, "in-quad",
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
    return "oh hi mark"
end
