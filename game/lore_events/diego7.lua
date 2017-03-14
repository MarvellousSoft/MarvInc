local Mail = require "classes.tabs.email"

local diego = {}

diego.require_puzzles = {'paul4', 'diego1', 'liv5', 'jen5'}
diego.wait = 7

function diego.run()
    Mail.new('diego7')
end

return diego
