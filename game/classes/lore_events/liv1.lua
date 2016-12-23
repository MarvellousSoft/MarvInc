local LoreManager = require "classes.lore-manager"
local Mail = require "classes.tabs.email"
local OpenedMail = require "classes.opened_email"
local Info = require "classes.tabs.info"

local liv = {}

-- Add puzzle "reverse"

liv.require_puzzles = {"maze2", "lasers"}
liv.wait = 10

function liv.run()
    LoreManager.email.reverse = Mail.new("Heard you're good",
[[
Heya

This is Liv, from Software Development. You may not know me but you know well my creation. Yep, the language you use everyday to control the bots was my idea. Hope you're liking it, it was some hard work :P. Sure, other people here helped, but let's get to the point

Your department is new, or at least using L++ to control the bots, so we need to find out what we can achieve with that, mainly to impress the higher-ups and get MOAR MONIZ in this bitch heheh

I've seen you can handle yourself with Paul and Jen, so I'll be sending some more tasks your way! This one should be pretty default, get used to working with sequences!

Remember to use the brackets operator, my most beautiful creation. It may be useful to use it more than once. I'm sure you'll figure it out.

Code on, and carry on!

-- Liv
]], "Olivia Kavanagh (liv.k@sdd.marv.com)", false,
    function()
        ROOM:connect("reverse")
        OpenedMail:close()
    end, true, function() end)
end

return liv
