local LoreManager = require "classes.lore-manager"
local Mail = require "classes.tabs.email"
local OpenedMail = require "classes.opened_email"
local Info = require "classes.tabs.info"

local pickup = {}

-- Adds the puzzle that teaches pickup/drop

pickup.require_puzzles = {"jump"}
pickup.wait = 4

function pickup.run()
    LoreManager.email.pickup = Mail.new("Working with a backpack",
[[
Did you know you have an inventory?

You can pickup and drop objects, such as giant buckets, with the commands pickup and drop. They both receive the same optional argument, a direction. When provided, the pickup command will make the robot turn and pick any object facing that direction. If you don't provide a direction, the subject will try to pick something in the direction he is facing. In both cases he puts the object in your inventory, located below your notepad in the terminal.

The same is analogous for the drop command, but instead of picking objects, the robot will try to drop whatever he is holding in the inventory.

Example that makes the bot pickup an object from his left and placing on his right:
- pickup left
- drop right

The same example as above, if the robot was facing north:
- turn counter
- pickup
- turn right
- drop

Happy adventuring, and carry on.
]], "Automated Introduction System", false,
    function()
        ROOM:connect("pickup")
        OpenedMail:close()
    end, true,
    function()
        Info.addCommand("pickup")
        Info.addCommand("pickup <direction>")
        Info.addCommand("drop")
        Info.addCommand("drop <direction>")
    end)
end

return pickup
