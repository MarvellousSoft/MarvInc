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

diego.require_puzzles = {'paul4', 'diego1', 'liv5', at_least=2}
diego.wait = 5

function diego.run()
    Mail.new('diego6')
end

return diego
