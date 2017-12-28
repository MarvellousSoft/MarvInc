--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local Mail = require "classes.tabs.email"

local paul = {}

paul.require_puzzles = {'liv8'}
paul.wait = 12

function paul.run()
    Mail.new('paul5')
end

return paul
