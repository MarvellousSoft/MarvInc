--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local Mail = require "classes.tabs.email"

local spam = {}

spam.require_puzzles = {'diego1'}
spam.wait = 20

function spam.run()
    Mail.new('spam2')
end

return spam
