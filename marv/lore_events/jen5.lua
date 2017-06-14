local Mail = require "classes.tabs.email"

local jen = {}

jen.require_puzzles = {'paul4', 'diego1', 'liv5', at_least = 2}
jen.wait = 20

function jen.run()
    Mail.new('jen5')
    LoreManager.timer:after(10, function() Mail.new('diego6') end)
end

return jen
