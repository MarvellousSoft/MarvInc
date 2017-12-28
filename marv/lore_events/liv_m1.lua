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

-- Thanks for helping with franz

liv.require_puzzles = {'liv3a', 'liv3b', 'liv3c', at_least = 2}
liv.wait = 3

function liv.run()
    Mail.new('liv_m1')
end

return liv
