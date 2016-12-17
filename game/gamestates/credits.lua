local Timer = require "hump.timer"
local FX = require "classes.fx"
local state = {}

-- CREDTIS SCREEN --
-- If you just want to change the duration, change the self.duration var and everything will adapt nicely


-- Changing the text is ok too, no need to change anything else
local credits = [[
Marvellous Soft. 2016

Made by:
Renato Lui Geh
Ricardo Lira Fonseca
Yan Soares Couto

Thanks to:
Yan's Mom
Fast Food
Mayte
Maria Clara
Cotuba
]]

function state:enter()
    local bg

    self.dy = H + 100
    self.credits_font = FONTS.fira(50)

    self.duration = 15
    -- number of lines + 4 to give some time before and after the text arrives
    self.scroll_size = (4 + #credits:gsub("%C", "")) * self.credits_font:getHeight() + H
    self.cur_time = 0
end

function state:update(dt)
    Timer.update(dt)
    self.cur_time = self.cur_time + dt
    if self.cur_time > self.duration  then Gamestate.pop() FX.intro() end
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

    -- Actual credits
    local dy = self.scroll_size * prog
    love.graphics.translate(0, -dy)

    love.graphics.setFont(self.credits_font)

    love.graphics.printf(credits, W/2, H + 2 * self.credits_font:getHeight(), W/2, "center")

    love.graphics.translate(0, dy)
end

return state
