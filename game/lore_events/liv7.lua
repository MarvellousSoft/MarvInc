local Mail = require "classes.tabs.email"

local liv = {}

-- Add puzzle 'liv7'

liv.require_puzzles = {} -- TODO: decide
liv.wait = 10

function liv.run()
    Mail.new('liv7_1')
    LoreManager.timer:after(10, function() Mail.new('liv7_2') end)
end

return liv
