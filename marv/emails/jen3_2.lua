local FX = require('classes.fx')
local LoreManager = require('classes.lore_manager')

return {
    title = "Promotion",
    text = [[
Congratulation Employee #]]..EMPLOYEE_NUMBER..[[.

You did your task with excellence, but I can't say I'm impressed. Licking the Statue of Liberty. That would be impressive.

But I'm happy to say Franz is satisfied with your progress, and you got a well deserved promotion: Fergus position. Don t worry about him, he was a liabilty this company couldn't afford anymore, so we send him away. You won't be seeing him around anymore. I can guarantee. :)

To celebrate the occasion I've arranged one of the interns to upgrade your OS to the most recent version. Enjoy.

Things will be a lot harder from now on. Keep up the good work, you're on the right track.

Carry on, now and forever.

PS: If you were still wondering, that task objective was to create a cleaning algorithm for our cafeteria. Marvinc will be cleaner thanks to you. Good job.

Janine Leubwitz
Chief engineer at Marvellous Inc.s Robot Testing Department
]],
    author = "Janine Leubwitz (leubwitz@rtd.marv.com)",
    reply_func = function()
        FX.full_static(GS.ACT2)
        ROOM.version = "2.0"
        LoreManager.puzzle_done.act1 = true
        LoreManager.check_all()
    end
}
