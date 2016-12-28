local LoreManager = require "classes.lore-manager"
local Mail = require "classes.tabs.email"

local register = {}

-- Adds the puzzle that teaches using registers

register.require_puzzles = {"pickup"}
register.wait = 4

function register.run()
    Mail.new('tuto6_1.lua')

    LoreManager.timer:after(8, function() Mail.new('tuto6_2') end)

    LoreManager.timer:after(12, function() Mail.new('tuto6_3') end)
end

return register
