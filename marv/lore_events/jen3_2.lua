local Mail = require "classes.tabs.email"

local jen = {}

jen.require_puzzles = {'jen3'}
jen.wait = 10

function jen.run()
    Mail.new('jen3_2')
end

return jen
