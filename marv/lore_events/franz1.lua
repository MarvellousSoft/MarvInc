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

franz.require_puzzles = {'diego_died'}
franz.wait = 13

function franz.run()
    Mail.new('franz1')
end

return franz
