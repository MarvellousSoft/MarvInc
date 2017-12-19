local Mail = require "classes.tabs.email"

local fergus = {}

-- Add puzzle 'fergus1'

fergus.require_puzzles = {'tutorial'}
fergus.wait = 30

function fergus.run()
    Mail.new('fergus1')
end

return fergus
