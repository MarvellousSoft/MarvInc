--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local Mail = require "classes.tabs.email"

local diego = {}

diego.require_puzzles = {"paul3"}
diego.wait = 10

function diego.run()
    Mail.new('diego5')
end

return diego
