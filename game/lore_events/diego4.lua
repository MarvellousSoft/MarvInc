local Mail = require "classes.tabs.email"

local diego = {}

diego.require_puzzles = {"jen4", "l4", at_least = 1}
diego.wait = 30

function diego.run()
    Mail.new('diego4')
end

return diego
