local Mail = require "classes.tabs.email"

local jen = {}

-- Add Jen

-- tutorial is a fake puzzle
jen.require_puzzles = {'tutorial'}
jen.wait = 10

function jen.run()
    Mail.new('jen1')
end

return jen
