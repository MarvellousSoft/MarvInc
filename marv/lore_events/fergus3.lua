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

-- Add puzzle 'fergus3'

fergus.require_puzzles = {'liv3a', 'liv3b', 'liv3c', at_least = 2}
fergus.wait = 20

function fergus.run()
    Mail.new('fergus3')
end

return fergus
