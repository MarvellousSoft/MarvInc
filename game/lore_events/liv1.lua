local Mail = require "classes.tabs.email"

local liv = {}

-- Add puzzle 'liv1'

liv.require_puzzles = {'jen2', 'paul1'}
liv.wait = 10

function liv.run()
    Mail.new('liv1')
end

return liv
