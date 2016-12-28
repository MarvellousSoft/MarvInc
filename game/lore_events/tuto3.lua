local LoreManager = require "classes.lore-manager"
local Mail = require "classes.tabs.email"

local turn = {}

-- Adds the puzzle that teaches turn

turn.require_puzzles = {"walkx"}
turn.wait = 4

function turn.run()
    Mail.new('tuto3_1')

    LoreManager.timer:after(4, function() Mail.new('tuto3_2') end)
end

return turn
