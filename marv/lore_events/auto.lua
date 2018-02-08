--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local Mail = require "classes.tabs.email"

local auto = {}

auto.require_puzzles = {'tutorial'}
auto.wait = 5

function auto.run()
    Mail.new('auto')
end

return auto
