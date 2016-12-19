local LoreManager = require "classes.lore-manager"
local Mail = require "classes.tabs.email"
local OpenedMail = require "classes.opened_email"
local Info = require "classes.tabs.info"

local end_alpha = {}

-- Add puzzle "simple_sort"

end_alpha.require_puzzles = {"maze2", "lasers"}
end_alpha.wait = 1

function end_alpha.run()
    LoreManager.email.simple_sort = Mail.new("The End?",
[[
On behalf of Marvellous Inc., we would like to thank you for playing this alpha version.

We will (possibly) add more content in the near future, so keep tuned to the github page or annoy us by sending emails.

This last puzzle is the hardest so far, but many harder will come later. Play on!

And, as always, carry on.
]], "Marvellous Soft", false,
    function()
        ROOM:connect("simple_sort")
        OpenedMail:close()
    end, true, function() end)
end

return end_alpha
