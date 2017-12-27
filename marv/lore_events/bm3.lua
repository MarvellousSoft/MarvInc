--Marvellous Inc.
--Copyright (C) 2017  MarvellousSoft
--See full license in file LICENSE.txt

local Mail = require "classes.tabs.email"

local bm = {}

bm.require_puzzles = {'liv7a', 'liv7b', at_least = 1}
bm.wait = 30

function bm.run()
    Mail.new('bm3')
    LoreManager.timer:after(30, function() Mail.new('bm3_1') end)
end

return bm
