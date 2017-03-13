local Mail = require "classes.tabs.email"

local diego = {}

diego.require_puzzles = { } --TODO: fazer dependencias certas
diego.wait = 5

function diego.run()
    Mail.new('diego4')
end

return diego
