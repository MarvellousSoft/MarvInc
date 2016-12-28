local LoreManager = require "classes.lore-manager"
local Mail = require "classes.tabs.email"

local square = {}

-- Adds the puzzle "Squaring"

square.require_puzzles = {"array_sep"}
square.wait = 4

function square.run()
    Mail.new('tuto8_1')

    LoreManager.timer:after(5, function() Mail.new('tuto8_2') end)
end

return square
