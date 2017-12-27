local Mail = require "classes.tabs.email"

local jen = {}

jen.require_puzzles = {'bm1', 'jen5', 'liv5'}
jen.wait = 120

function jen.run()
    Mail.new('jen5_2')
end

return jen
