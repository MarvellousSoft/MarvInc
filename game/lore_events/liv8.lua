local Mail = require "classes.tabs.email"

local liv = {}

-- Add puzzle 'liv8'

liv.require_puzzles = {'liv7a', 'liv7b', at_least = 1}
liv.wait = 4

function liv.run()
    Mail.new('liv8_1')

    LoreManager.timer:after(5, function() Mail.new('liv8_2') end)
end

return liv
