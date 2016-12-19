local LoreManager = require "classes.lore-manager"
local Mail = require "classes.tabs.email"
local OpenedMail = require "classes.opened_email"
local Info = require "classes.tabs.info"

local jen = {}

-- Add puzzle "maze2"

jen.require_puzzles = {"maze1"}
jen.wait = 15

function jen.run()
    LoreManager.email.maze2 = Mail.new("My sincere apologies",
[[
Hello Employee #]]..EMPLOYER_NUMBER..[[

First of all, I own you my sincere apologies for my previous email. I had a little wine at my break hours, and I got carried away for a bit.

If you could erase it and pretend that it never happened, I would be grateful.

But at least the record show you have completed the beta version of our latest nIf Navigation System test room with perfection. I think you can handle the real deal now. Please let me know if you are willing to try it.

Again, I'm sorry for my lack of profissionalism, it will not happen again.
And please call me Janine at the work enviroment.

Carry on, now and forever.

Janine Leubwitz
Chief engineer at Marvellous Inc.s Robot Testing Department
]], "Janine Leubwitz (leubwitz@rtd.marv.com)", false,
    function()
        ROOM:connect("maze2")
        OpenedMail:close()
    end, true, function() end)
end

return jen
