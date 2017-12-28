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
local OpenedMail = require "classes.opened_email"
local Info = require "classes.tabs.info"

local walkx = {}

-- Adds the puzzle that teaches using walk X

walkx.require_puzzles = {'tuto1'}
walkx.wait = 4

function walkx.run()
    Mail.new('tuto2_1')

    LoreManager.timer:after(10, function() Mail.new('tuto2_2') end)
end

return walkx
