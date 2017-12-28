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

-- Add puzzle 'liv_extra1'

liv.require_puzzles = {'liv3a', 'liv3b', 'liv3c'}
liv.wait = 1

function liv.run()
    Mail.new('liv_extra1')
end

return liv
