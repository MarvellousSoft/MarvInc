--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local Timer = require "extra_libs.hump.timer"
local FX = require "classes.fx"
local state = {}

-- CREDITS SCREEN --
-- If you just want to change the duration, change the self.duration var and everything will adapt nicely
state.duration = 40

-- Changing the text is ok too, no need to change anything else
local credits = [[






MADE BY:

Renato Lui Geh
Yan Soares Couto
Ricardo Lira da Fonseca



SPECIAL THANKS TO:

Yan's Mom
Mayte
Maria Clara
Fast Food
Cotuba
inguin
pgimeno
Renantc

~ You <3 ~



a game made by









]]


function state:enter()
    local bg

    self.dy = H + 100
    self.credits_font = FONTS.comfortaaBold(50)

    -- number of lines + 4 to give some time before and after the text arrives
    self.scroll_size = (4 + #credits:gsub("%C", "")) * self.credits_font:getHeight() + H
    self.cur_time = 0
end

function state:update(dt)
    Timer.update(dt)
    AUDIO_TIMER:update(dt)
    MAIN_TIMER:update(dt)
    self.cur_time = self.cur_time + dt
    if self.cur_time > self.duration  then
         Gamestate.pop()
    end
end

function state:draw()

    Draw.allTables()

    -- Black background
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, W, H)
    love.graphics.setColor(255, 255, 255)

    local prog = self.cur_time / self.duration

    -- Actual credits
    local dy = self.scroll_size * prog
    love.graphics.translate(0, -dy)

    love.graphics.draw(MISC_IMG.logo, W / 2 - MISC_IMG.logo:getWidth() * .75 / 2, 850, 0, .75)

    love.graphics.setFont(self.credits_font)

    love.graphics.printf(credits, 0, H + 2 * self.credits_font:getHeight(), W, "center")

    love.graphics.draw(MISC_IMG["marvsoft"], W / 2 - MISC_IMG["marvsoft"]:getWidth() * .75 / 2, self.scroll_size - 600, 0, .75)

    love.graphics.translate(0, dy)
end

function state:leave()
    ROOM:disconnect()
    PopManager.quit()
    FX.quick_static(1)
end

return state
