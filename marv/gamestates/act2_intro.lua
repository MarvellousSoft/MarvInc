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

-- ACT 2 TRANSITION SCREEN -- Similar to credits
-- If you just want to change the duration, change the self.duration var and everything will adapt nicely
state.duration = 10

-- Changing the text is ok too, no need to change anything else
local text = love.filesystem.read('assets/text/install_act2.log')

function state:enter()
    local bg

    self.dy = H + 100
    self.text_font = FONTS.fira(15)

    -- number of lines + 4 to give some time before and after the text arrives
    self.scroll_size = (4 + #text:gsub("%C", "")) * self.text_font:getHeight()
    self.last_scroll = 0
    self.real_scroll = 0
    self.cur_time = 0
end

function state:update(dt)
    Timer.update(dt)
    self.cur_time = self.cur_time + dt
    if self.cur_time > self.duration  then Gamestate.pop() FX.intro() end
end

-- semi-random scroll
function state:setScroll(sc)
    if self.last_scroll == sc then return end
    self.last_scroll = sc
    local x = { 0,  1,   2,  3,    4,   5}
    local p = {.5, .2, .2, .02, .04, 999}
    local c = love.math.random()
    for i, pp in ipairs(p) do
        if pp >= c then
            local fh = self.text_font:getHeight()
            self.real_scroll = math.min(self.real_scroll + x[i] * fh, self.scroll_size)
            break
        else
            c = c - pp
        end
    end
end

function state:draw()

    Draw.allTables()

    -- Black background
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, W, H)
    love.graphics.setColor(255, 255, 255)

    -- Installation progress bar
    love.graphics.setFont(FONTS.fira(30))
    local x, y, w = 30, H / 2 - 100, 600
    love.graphics.printf("Installing Marvellous OS 2.0", x, y, w, "center")
    local dh = love.graphics.getFont():getHeight()
    local bh = 60
    love.graphics.rectangle("line", x, y + dh, w, bh)
    local b = 5
    local prog = self.cur_time / self.duration
    love.graphics.rectangle("fill", x + b, y + dh + b, prog * (w - 2 * b), bh - 2 * b)

    love.graphics.setFont(FONTS.fira(15))
    love.graphics.printf("Please do not turn off your computer...", x, y + dh + bh + 2 * b, w, "center")

    -- Title text
    love.graphics.setFont(FONTS.fira(150))
    love.graphics.printf("ACT 2", x, 50, w, 'center')

    -- Actual text
    local fh = self.text_font:getHeight()
    self:setScroll(math.floor(self.scroll_size * prog / fh))
    local dy = self.real_scroll * fh

    love.graphics.translate(0, -self.real_scroll)

    love.graphics.setFont(self.text_font)

    love.graphics.printf(text, W/2, H + 2 * fh, W/2, "left")

    love.graphics.translate(0, self.real_scroll)
end

return state
