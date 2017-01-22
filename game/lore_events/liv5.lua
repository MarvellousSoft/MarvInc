local Mail = require "classes.tabs.email"

local liv = {}

-- Add puzzle 'liv5'

liv.require_puzzles = {'liv4'} -- change to start of Act 2
liv.wait = 5

function liv.run()
    Mail.new('liv5_1')
    LoreManager.timer:after(5, function() Mail.new('liv5_2') end)
end

return liv
