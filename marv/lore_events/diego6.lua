local Mail = require "classes.tabs.email"

local diego = {}

diego.require_puzzles = {'paul4', 'diego1', 'liv5', at_least=2}
diego.wait = 5

function diego.run()
    Mail.new('diego6')
end

return diego
