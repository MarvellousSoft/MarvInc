local Mail = require "classes.tabs.email"

local franz = {}

franz.require_puzzles = {'franz1'}
franz.wait = 10

function franz.run()
    Mail.new('franz1_2')
end

return franz
