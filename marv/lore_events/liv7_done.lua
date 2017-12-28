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

liv.require_puzzles = {'liv7a', 'liv7b', at_least = 1}
liv.wait = 10

function liv.run()
    Mail.new('liv7_3')
end

return liv
