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

-- unlocks at the same time as dlc_1_4
dlc1.require_puzzles = {'dlc_1_x1'}
dlc1.wait = 60

function dlc1.run()
    Mail.new('dlc_1_5')
end

return dlc1