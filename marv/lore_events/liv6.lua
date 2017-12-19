local Mail = require "classes.tabs.email"

local liv = {}

-- Add puzzle 'liv6'

liv.require_puzzles = {'jen5', 'liv5', 'bm1'}
liv.wait = 5

function liv.run()
    Mail.new('liv6_1')
    LoreManager.timer:after(30, function() Mail.new('liv6_2') end)
end

return liv
