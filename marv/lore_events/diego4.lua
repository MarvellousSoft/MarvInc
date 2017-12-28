--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local Mail = require "classes.tabs.email"

local diego = {}

diego.require_puzzles = {'jen4', 'liv4', at_least = 1}
diego.wait = 30

function diego.run()
    Mail.new('diego4')
end

return diego
