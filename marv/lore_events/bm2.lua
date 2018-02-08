--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local Mail = require "classes.tabs.email"

local bm = {}

bm.require_puzzles = {'bm1', 'jen5', 'liv5'}
bm.wait = 20

function bm.run()
    Mail.new('bm2')
    LoreManager.timer:after(10, function() Mail.new('bm2_1') end)
end

return bm
