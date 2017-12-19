local Mail = require "classes.tabs.email"

local liv = {}

-- Add puzzle 'liv_extra2'

liv.require_puzzles = {'liv7a', 'liv7b'}
liv.wait = 2

function liv.run()
    Mail.new('liv_extra2')
end

return liv
