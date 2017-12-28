--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local Mail = require "classes.tabs.email"
local LoreManager = require 'classes.lore_manager'

local diego = {}

diego.require_puzzles = {'liv3b'}
diego.wait = 4

function diego.run()
    if not LoreManager.puzzle_done.diego_died then
        Mail.new('diego2_2')
    end
end

return diego
