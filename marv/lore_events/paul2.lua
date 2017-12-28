--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local Mail = require "classes.tabs.email"

local paul = {}

paul.require_puzzles = {'liv2', 'jen2', 'paul_invite'}
paul.wait = 4

function paul.run()
    LoreManager.timer:after(10, function() Mail.new('paul2_1') end)
    LoreManager.timer:after(20, function() Mail.new('paul2_2') end)
end

return paul
