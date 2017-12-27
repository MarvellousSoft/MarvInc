--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local Mail = require "classes.tabs.email"

local franz = {}

franz.require_puzzles = {'franz1'}
franz.wait = 10

function franz.run()
    Mail.new('franz1_2')
end

return franz
