local Mail = require "classes.tabs.email"

local liv = {}

-- Add puzzle 'livbf1' -- change name

liv.require_puzzles = {} -- decide when this will be added
liv.wait = 4

function liv.run()
    Mail.new('livbf1_1')
    LoreManager.timer:after(5, function() Mail.new('livbf1_2') end)
end

return liv
