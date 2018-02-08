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

-- Add puzzle 'fergus1'

fergus.require_puzzles = {'tutorial'}
fergus.wait = 50

function fergus.run()
    Mail.new('fergus1')
end

return fergus
