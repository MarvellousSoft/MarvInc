local Mail = require "classes.tabs.email"

local jen = {}

jen.require_puzzles = {} --TODO Change this to be correct
jen.wait = 20

function jen.run()
    Mail.new('jen5')
end

return jen
