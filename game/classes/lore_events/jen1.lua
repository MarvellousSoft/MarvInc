local LoreManager = require "classes.lore-manager"
local Mail = require "classes.tabs.email"
local OpenedMail = require "classes.opened_email"
local Info = require "classes.tabs.info"

local jen = {}

-- Add Jen

-- tutorial is a fake puzzle
jen.require_puzzles = {"tutorial"}
jen.wait = 6

function jen.run()
    LoreManager.email.maze1 = Mail.new("Congraaaaattts!!1!",
[[
Hey theeeere!

congrats on nailing the job man,  been a while since we had new slavs coming here kkkk jsut kiddin ;P

im ur new boss, but no need to formalities right? hahaha call me jenny btw

u probly realized we updated your OS to the 2.0 ver. it should have downloaded 1TB of RAM, so everything should run waaaay more smooth (y) .oh!and the updated office packge is off the roooof man! hahaha

aaanywho, youre probably itching for some ~real~ work huh?? we r tryin to tweak some details on the nav sys of the "robots" kk, but we are having some tech troubles.The main test room is still 2 unstable for u to handle right now, but we can send u the beta version and see if you can handle. btw this one can only handle 4 lines of code soooooo yeahh can u handle this job??

don't forget to carry on ;))).

jeNny Leubwoot
chief astronaut at marvellous soft.s KICKASS dojo
]], "Janine Leubwitz", false,
    function()
        ROOM:connect("maze1")
        OpenedMail:close()
    end, true, function() end)
end

return jen
