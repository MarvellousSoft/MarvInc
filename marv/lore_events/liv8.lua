local Mail = require "classes.tabs.email"

local liv = {}

-- Add puzzle 'liv8'

liv.require_puzzles = {'bm3'}
liv.wait = 10

function liv.run()
    Mail.new('liv8_1')

    LoreManager.timer:after(20, function() Mail.new('liv8_2') end)
end

return liv
