--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local Mail = require "classes.tabs.email"

local paul = {}

paul.require_puzzles = {'paul3'}
paul.wait = 10

function paul.run()
    Mail.new('paul4')
end

return paul
