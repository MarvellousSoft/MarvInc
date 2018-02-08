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

-- Add Jen

-- tutorial is a fake puzzle
jen.require_puzzles = {'tutorial'}
jen.wait = 30

function jen.run()
    Mail.new('jen1')
end

return jen
