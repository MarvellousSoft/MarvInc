local Mail = require "classes.tabs.email"

local jen = {}

-- Add Jen

-- tutorial is a fake puzzle
jen.require_puzzles = {"tutorial"}
jen.wait = 6

function jen.run()
    Mail.new('jen1')
end

return jen
