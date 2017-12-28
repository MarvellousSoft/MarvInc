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

-- Add puzzle 'liv1'

liv.require_puzzles = {'jen1', 'paul1', 'fergus1'}
liv.wait = 8

function liv.run()
    Mail.new('liv1_1')
end

return liv
