local Mail = require "classes.tabs.email"

local diego = {}

diego.require_puzzles = { 'fergus1', 'jen1' }
diego.wait = 5

function diego.run()
    Mail.new('diego1')
end

return diego
