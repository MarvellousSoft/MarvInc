local Mail = require "classes.tabs.email"

local diego = {}

diego.require_puzzles = {false} --TODO: fazer dependencias certas
diego.wait = 5

function diego.run()
    Mail.new('diego6')
end

return diego
