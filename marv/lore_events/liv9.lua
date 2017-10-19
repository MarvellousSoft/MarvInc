local Mail = require "classes.tabs.email"

local liv = {}

-- Add puzzle 'liv9'

liv.require_puzzles = {'paul5', 'jen7'}
liv.wait = 27

function liv.run()
    Mail.new('liv9_1')

    LoreManager.timer:after(25, function() Mail.new('liv9_2') end)
    LoreManager.timer:after(45, function() Mail.new('liv9_3') end)
end

return liv
