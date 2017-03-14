local Mail = require "classes.tabs.email"

local bm = {}

bm.require_puzzles = {'bm1', 'jen5', 'liv5'}
bm.wait = 20

function bm.run()
    Mail.new('bm2')
    LoreManager.timer:after(5, function() Mail.new('bm2_2') end)
end

return bm
