local Mail = require "classes.tabs.email"

local bm = {}

bm.require_puzzles = {'liv7a', 'liv7b', at_least = 1}
bm.wait = 30

function bm.run()
    Mail.new('bm3')
end

return bm
