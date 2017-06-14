local Mail = require "classes.tabs.email"

local franz = {}

franz.require_puzzles = {'diego_died'}
franz.wait = 13

function franz.run()
    Mail.new('franz1')
end

return franz
