--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local FX = require('classes.fx')
local LoreManager = require('classes.lore_manager')
local Mail = require('classes.tabs.email')

local you = "Employee #" .. EMPLOYEE_NUMBER
return {
    title = "A satisfactory result",
    text = you .. [[,

I have received news that you have performed your last task with excellence. I expected nothing less.

I hope that you share our vision, mine and the CEOs', of a better future. Humanity is foolish. It has been proven for centuries, millennia, that mankind is too eager, too... childish. It needs something greater to take its hand and guide it to the right direction. We are this greater being, ]] .. you .. [[. No more squabbling amongst ourselves. No more unnecessary expenses and inneficient industries. We shall create a new order! A new world! Ordnung muss sein!

I eager for the time when humanity has finally reached its peak, for it shall be glorious. And we, the Greats, the Visionaries, the Architects of the new neosapiens will be forever immortalized, and our names will be remembered and worshipped as though we were Gods!

But I digress. Your actions have shown yourself committed to this company. Maintain this loyalty and you will have a great future in this company.

In view of all of this, I congratulate you, ]] .. you .. [[, for your new position: Head Engineer. Do not worry, Ms. Janine Leubwitz will enjoy her new position as the Head of Janitorial Services. Given her recent missteps, it suits her quite well.

And do not fool yourself, ]] .. you .. [[. We are very thorough in our legal department. Any... incidents that might have happened, would be the sole responsibility of the robot operator... And might I add that you have quite a long list of such... inconveniences.

Karl Franz F. L. von Linz
General Executive Manager
]],
    author = "Karl Franz F. L. von Linz (kflinz@marv.com)",
    reply_func = function(e)
        require('classes.opened_email').close()
        FX.full_static(GS.ACT3)
        ROOM.version = "3.0"
        LoreManager.puzzle_done.act2 = true
        LoreManager.check_all()
        Mail.disableReply(e.number)
    end
}
