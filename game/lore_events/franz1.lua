local Mail = require "classes.tabs.email"

local franz = {}

franz.require_puzzles = {'diego2', 'liv6', 'bm2'}
franz.wait = 10

function franz.run()
    Mail.new('franz1')
end

return franz
