--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local Mail = require "classes.tabs.email"

local ryr = {}

-- Add puzzle 'ryr'

ryr.require_puzzles = {'liv9'}
ryr.wait = 20

function ryr.run()
    Mail.new('ryr')
end

return ryr
