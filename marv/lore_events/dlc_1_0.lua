--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local Mail = require "classes.tabs.email"

local dlc0 = {}

dlc0.require_puzzles = {'paul3'}
-- Fast so new players with DLC get it quick
dlc0.wait = 1
dlc0.dlc_needed = 2764520

function dlc0.run()
    Mail.new('dlc_1_0')
end

return dlc0
