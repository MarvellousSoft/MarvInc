--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local state = {}

--Just a blank screen

function state:enter()
end

function state:update(dt)
end

function state:draw()

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.rectangle("fill", 0, 0, W, H)
    Draw.allTables()

end

return state
