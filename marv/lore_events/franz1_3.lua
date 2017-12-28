--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local Mail = require "classes.tabs.email"

local franz = {}

franz.require_puzzles = {'liv7a', 'liv7b', at_least = 1}
franz.wait = 60

function franz.run()
    Mail.new('franz1_3')
end

return franz
