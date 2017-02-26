local Mail = require "classes.tabs.email"

local paul = {}

-- Add paul

paul.require_puzzles = {'fergus1', 'jen1', at_least = 1}
paul.wait = 10

function paul.run()
    Mail.new('paul1')
end

return paul
