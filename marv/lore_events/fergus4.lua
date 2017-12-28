--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local Mail = require "classes.tabs.email"

local fergus = {}

-- Add puzzle 'fergus4'

fergus.require_puzzles = {'fergus3'}
fergus.wait = 2

function fergus.run()
    Mail.new('fergus4_1')
    LoreManager.timer:after(10, function() Mail.new('fergus4_2') end)
end

return fergus
