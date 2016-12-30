local LoreManager = require "classes.lore-manager"
local Mail = require "classes.tabs.email"

local array_sep = {}

-- Adds the puzzle "Array Separator"

array_sep.require_puzzles = {'tuto6'}
array_sep.wait = 4

function array_sep.run()
    Mail.new('tuto7_1')

    LoreManager.timer:after(5, function() Mail.new('tuto7_2') end)

    LoreManager.timer:after(11, function() Mail.new('tuto7_3') end)
end

return array_sep
