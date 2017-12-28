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

local turn = {}

-- Adds the puzzle that teaches turn

turn.require_puzzles = {'tuto2'}
turn.wait = 4

function turn.run()
    Mail.new('tuto3_1')

    LoreManager.timer:after(10, function() Mail.new('tuto3_2') end)
end

return turn
