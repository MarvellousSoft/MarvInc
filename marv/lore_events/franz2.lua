local Mail = require "classes.tabs.email"

local franz = {}

franz.require_puzzles = {'jen6', 'bm3'}
franz.wait = 15

function franz.run()
    Mail.new('franz2')
end

return franz
