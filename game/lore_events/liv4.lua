local Mail = require "classes.tabs.email"

local liv = {}

-- Add puzzle 'liv4'

liv.require_puzzles = {'jen3'}
liv.wait = 15

function liv.run()
    Mail.new('liv4')
end

return liv
