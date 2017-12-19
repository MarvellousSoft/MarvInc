local Mail = require "classes.tabs.email"

local paul = {}

paul.require_puzzles = {'paul2'}
paul.wait = 5

function paul.run()
    Mail.new('paul2_3')
end

return paul
