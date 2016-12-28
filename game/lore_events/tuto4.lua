local Mail = require "classes.tabs.email"

local jump = {}

-- Adds the puzzle that teaches jmp

jump.require_puzzles = {"turn"}
jump.wait = 4

function jump.run()
    Mail.new('tuto4')
end

return jump
