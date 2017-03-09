local Mail = require "classes.tabs.email"

local bm = {}

bm.require_puzzles = {'jen4', 'liv4'}
bm.wait = 30

function bm.run()
    Mail.new('bm1')
    LoreManager.timer:after(5, function() Mail.new('bm1_1') end)
end

return bm
