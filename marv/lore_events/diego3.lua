local Mail = require "classes.tabs.email"

local diego = {}

diego.require_puzzles = {'act1'}
diego.wait = 15

function diego.run()
    Mail.new('diego3')
end

return diego
