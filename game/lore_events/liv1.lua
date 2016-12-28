local Mail = require "classes.tabs.email"

local liv = {}

-- Add puzzle "reverse"

liv.require_puzzles = {"maze2", "lasers"}
liv.wait = 10

function liv.run()
    Mail.new('liv1')
end

return liv
