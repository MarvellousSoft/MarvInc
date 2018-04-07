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

-- Add Jen Extra 1

jen.require_puzzles = {'jen4_fast'}
jen.wait = 10

function jen.run()
    Mail.new('jen_extra1')
end

return jen
