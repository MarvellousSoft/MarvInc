local Mail = require "classes.tabs.email"

local fergus = {}

-- Add puzzle 'fergus3'

fergus.require_puzzles = {'liv3a', 'liv3b', 'liv3c', at_least = 2}
fergus.wait = 10

function fergus.run()
    Mail.new('fergus3')
end

return fergus
