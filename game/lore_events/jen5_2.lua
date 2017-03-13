local Mail = require "classes.tabs.email"

local jen = {}

jen.require_puzzles = {"jen5", "bm1"} --TODO Change this to be correct
jen.wait = 120

function jen.run()
    Mail.new('jen5_2')
end

return jen
