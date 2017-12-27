local Mail = require "classes.tabs.email"

local jen = {}

jen.require_puzzles = {'paul4', 'diego1', 'liv5', at_least = 2}
jen.wait = 20

function jen.run()
    Mail.new('jen5')
end

return jen
