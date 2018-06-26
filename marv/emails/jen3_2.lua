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

return {
    title = "Promotion",
    text = [[
Congratulation Employee #]]..EMPLOYEE_NUMBER..[[.

You did your task with excellence, but I can't say I'm impressed. {blue}Licking the Statue of Liberty{end}. That would be impressive.

But I'm happy to say {brown}Franz{end} is satisfied with your progress, and you got a well deserved promotion: {pink}Fergus{end}'s position. Don't worry about him, he was a liabilty this company couldn't afford anymore, so we sent him away. You won't be seeing him around anymore. I can guarantee. {purple}:){end}

To celebrate the occasion I've arranged one of the interns to upgrade your {green}OS{end} to the most recent version. Enjoy.

Things will be a lot harder from now on. Keep up the good work, you're on the right track.

Carry on, now and forever.

{gray}PS: If you were still wondering, that task objective was to create a cleaning algorithm for our cafeteria. Marvinc will be cleaner thanks to you. {purple}Good job{gray}.{end}

Janine Leubwitz
Head engineer at Marvellous Inc. Robot Testing Department
]],
    author = "Janine Leubwitz (leubwitz@rtd.marv.com)",
    reply_func = function(e)
        require('classes.opened_email').close()
        FX.full_static(GS.ACT2)
        ROOM.version = "2.0"
        LoreManager.puzzle_done.act1 = true
        LoreManager.check_all()
        Mail.disableReply(e.number)
    end
}
