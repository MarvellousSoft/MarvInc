--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local Mail = require "classes.tabs.email"

local jen = {}

jen.require_puzzles = {'jen4'}
jen.wait = 10

function jen.run()
    if not _G.LoreManager.puzzle_done.jen4_fast then
        Mail.new('jen4_2')
    end
end

return jen
