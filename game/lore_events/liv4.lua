local Mail = require "classes.tabs.email"

local liv = {}

-- Add puzzle 'liv4'

liv.require_puzzles = {'liv3a', 'liv3b', 'liv3c', at_least = 2}
liv.wait = 2

function liv.run()
    Mail.new('liv4_1')

    LoreManager.timer:after(30, function() Mail.new('liv4_2') end)
end

return liv
