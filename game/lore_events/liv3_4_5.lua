local Mail = require "classes.tabs.email"

local liv = {}

-- Add puzzles 'liv3', 'liv4', 'liv5'

liv.require_puzzles = {'liv2'}
liv.wait = 3

function liv.run()
    Mail.new('liv3')

    LoreManager.timer:after(20, function() Mail.new('liv4') end)

    LoreManager.timer:after(25, function() Mail.new('liv5') end)
end

return liv
