local Mail = require "classes.tabs.email"
local lore = {}

function lore.begin()
    MAIN_TIMER.after(1.5, function()
    Mail.new("Welcome to room.hack [TEMPORARY]",
[[Hello. Help save the world. There are many commands.

For now, you just need to know one: walk. You can send a direction (north, west, south, east). If you don't, your robot will walk to the direction it is facing.

This command will walk until you encounter an obstacle.

Example:
    - walk
    - walk east

Good Luck, and carry on helping the world.]], "Automated Introduction System", false,
    function() ROOM:from(Reader("puzzles/test.lua"):get()) end)
    end)
end

return lore
