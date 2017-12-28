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

-- Add puzzles 'liv3a', 'liv3b', 'liv3c'

liv.require_puzzles = {'paul2', 'fergus2'}
liv.wait = 3

function liv.run()
    Mail.new('liv3_1')

    LoreManager.timer:after(10, function() Mail.new('diego2_1') end)
    LoreManager.timer:after(20, function() Mail.new('liv3_2') end)

    LoreManager.timer:after(25, function() Mail.new('liv3_3') end)
end

return liv
