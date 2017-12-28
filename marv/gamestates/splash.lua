--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local Timer = require "extra_libs.hump.timer"
local state = {}

function state:enter()
    img = love.graphics.newImage("assets/images/Marvellous Soft.png")
    sound = love.audio.newSource("assets/sound/marvellous.mp3", "static")
    sound:play()
    cur_time = 0
    self.alp = 0
    Timer.after(1, function() Timer.tween(.5, self, {alp = 255}) end )
end

local function leave()
    if sound then sound:stop() end
    Timer.clear()
    Gamestate.switch(GS.MENU)
end

function state:update(dt)
    Timer.update(dt)
    cur_time = cur_time + dt
    if cur_time > 1.7 then
        leave()
    end
end

function state:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("fill", 0, 0, W, H)
    love.graphics.draw(img, 0, 0)
    love.graphics.setColor(0, 0, 0, self.alp)
    love.graphics.rectangle("fill", 0, 0, W, H)
end

state.keypressed = leave

state.mousepressed = leave

return state
