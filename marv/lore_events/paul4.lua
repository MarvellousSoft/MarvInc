local Mail = require "classes.tabs.email"

local paul = {}

paul.require_puzzles = {'paul3'}
paul.wait = 10

function paul.run()
    Mail.new('paul4')
end

return paul
