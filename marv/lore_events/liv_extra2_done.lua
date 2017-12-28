--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local Mail = require "classes.tabs.email"

local liv = {}

liv.require_puzzles = {'liv_extra2'}
liv.wait = 2.5

function liv.run()
    Mail.new('liv_extra2_done')
end

return liv
