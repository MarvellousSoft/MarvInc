local Mail = require "classes.tabs.email"

local liv = {}

-- Add puzzle 'liv9'

liv.require_puzzles = {'liv8'}
liv.wait = 5

function liv.run()
    Mail.new('liv9_1')

    LoreManager.timer:after(5, function() Mail.new('liv9_2') end)
end

return liv
