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
dlc0.wait = 5

function dlc0.run()
    Mail.new('dlc_1_0')
end

return dlc0
