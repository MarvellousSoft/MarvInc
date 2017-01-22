local Mail = require "classes.tabs.email"

local liv = {}

-- Add puzzle 'liv6'

liv.require_puzzles = {'liv5'}
liv.wait = 5

function liv.run()
    Mail.new('liv6_1')
    LoreManager.timer:after(10, function() Mail.new('liv6_2') end)
end

return liv
