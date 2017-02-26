local Mail = require "classes.tabs.email"

local jen = {}

jen.require_puzzles = {'fergus4'}
jen.wait = 20

function jen.run()
    Mail.new('jen3')
end

return jen
