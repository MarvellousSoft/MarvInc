local Mail = require "classes.tabs.email"

local paul = {}

paul.require_puzzles = {'liv8'}
paul.wait = 12

function paul.run()
    Mail.new('paul5')
end

return paul
