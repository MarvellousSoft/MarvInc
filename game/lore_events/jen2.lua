local Mail = require "classes.tabs.email"

local jen = {}

-- Add puzzle "maze2"

jen.require_puzzles = {"maze1"}
jen.wait = 15

function jen.run()
    Mail.new('jen2')
end

return jen
