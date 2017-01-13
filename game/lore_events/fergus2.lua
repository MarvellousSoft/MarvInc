local Mail = require "classes.tabs.email"

local fergus = {}

-- Add puzzle 'fergus2'

fergus.require_puzzles = {'fergus1'}
fergus.wait = 6

function fergus.run()
    Mail.new('fergus2')
end

return fergus
