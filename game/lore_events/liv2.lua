local Mail = require "classes.tabs.email"

local liv = {}

-- Add puzzle 'liv2'

liv.require_puzzles = {'liv1'}
liv.wait = 4

function liv.run()
    Mail.new('liv2')
end

return liv
