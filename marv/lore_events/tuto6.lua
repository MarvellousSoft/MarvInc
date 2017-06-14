local LoreManager = require "classes.lore_manager"
local Mail = require "classes.tabs.email"

local register = {}

-- Adds the puzzle that teaches using registers

register.require_puzzles = {'tuto5'}
register.wait = 4

function register.run()
    Mail.new('tuto6_1')

    LoreManager.timer:after(10, function() Mail.new('tuto6_2') end)

    LoreManager.timer:after(20, function() Mail.new('tuto6_3') end)
end

return register
