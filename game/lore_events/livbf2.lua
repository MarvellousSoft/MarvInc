local Mail = require "classes.tabs.email"

local liv = {}

-- Add puzzle 'livbf2' -- change name

liv.require_puzzles = {'livbf1'} -- temporary name
liv.wait = 4

function liv.run()
    Mail.new('livbf2_1')
    LoreManager.timer:after(5, function() Mail.new('livbf2_2') end)
end

return liv
