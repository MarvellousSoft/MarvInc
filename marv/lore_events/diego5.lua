local Mail = require "classes.tabs.email"

local diego = {}

diego.require_puzzles = {"paul3"}
diego.wait = 10

function diego.run()
    Mail.new('diego5')
end

return diego
