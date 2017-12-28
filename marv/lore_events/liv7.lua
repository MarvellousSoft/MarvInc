--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local Mail = require "classes.tabs.email"

local liv = {}

-- Add puzzle 'liv7'

liv.require_puzzles = {'act2'}
liv.wait = 7

function liv.run()
    Mail.new('liv7_1')
    LoreManager.timer:after(20, function() Mail.new('liv7_2') end)
end

return liv
