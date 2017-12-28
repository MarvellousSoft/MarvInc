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

-- Add puzzle 'jen2'

jen.require_puzzles = {'jen1'}
jen.wait = 15

function jen.run()
    Mail.new('jen2')
end

return jen
