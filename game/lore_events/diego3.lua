local Mail = require "classes.tabs.email"

local diego = {}

diego.require_puzzles = { } --TODO: fazer dependencias de transição de ato
diego.wait = 5

function diego.run()
    Mail.new('diego3')
end

return diego
