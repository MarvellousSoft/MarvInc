local Mail = require "classes.tabs.email"

local liv = {}

-- Add puzzle 'liv4'

liv.require_puzzles = {'act1'}
liv.wait = 50

function liv.run()
    Mail.new('liv4')
end

return liv
