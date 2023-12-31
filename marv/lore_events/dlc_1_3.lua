--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local Mail = require "classes.tabs.email"

local dlc1 = {}

dlc1.require_puzzles = {'dlc_1_t1'}
dlc1.wait = 5

function dlc1.run()
    Mail.new('dlc_1_3')
end

return dlc1