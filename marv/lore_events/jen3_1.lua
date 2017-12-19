local Mail = require "classes.tabs.email"

local jen = {}

jen.require_puzzles = {'fergus4'}
jen.wait = 10

function jen.run()
    Mail.new('jen3_1')
end

return jen
