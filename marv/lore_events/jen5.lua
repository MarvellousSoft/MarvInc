--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local Mail = require "classes.tabs.email"

local jen = {}

jen.require_puzzles = {'paul4', 'diego1', 'liv5', at_least = 2}
jen.wait = 20

function jen.run()
    Mail.new('jen5')
end

return jen
