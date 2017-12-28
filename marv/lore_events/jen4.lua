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

jen.require_puzzles = {'act1'}
jen.wait = 20

function jen.run()
    Mail.new('jen4')
end

-- called after jen email is read
function jen.after_email()

    LoreManager.timer:after(15, function() Mail.new('binary') end) -- Send explanation

end


return jen
