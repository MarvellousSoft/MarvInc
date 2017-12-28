--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local LoreManager = require "classes.lore_manager"
local Mail = require "classes.tabs.email"

local array_sep = {}

-- Adds the puzzle "Array Separator"

array_sep.require_puzzles = {'tuto6'}
array_sep.wait = 4

function array_sep.run()
    Mail.new('tuto7_1')

    LoreManager.timer:after(10, function() Mail.new('tuto7_2') end)

    LoreManager.timer:after(20, function() Mail.new('tuto7_3') end)
end

return array_sep
