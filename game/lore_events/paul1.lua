local Mail = require "classes.tabs.email"

local paul = {}

-- Add paul

-- tutorial is a fake puzzle
paul.require_puzzles = {'tutorial'}
paul.wait = 30

function paul.run()
    Mail.new('paul1')
end

return paul
