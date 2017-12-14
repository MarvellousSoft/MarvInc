local Timer = require "extra_libs.hump.timer"
local FX = require "classes.fx"
local state = {}

-- CREDTIS SCREEN --
-- If you just want to change the duration, change the self.duration var and everything will adapt nicely
state.duration = 20

-- Changing the text is ok too, no need to change anything else
local credits = [[
Marvellous Soft. 2017

Made by:
Renato Lui Geh
Ricardo Lira da Fonseca
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

    -- number of lines + 4 to give some time before and after the text arrives
    self.scroll_size = (4 + #credits:gsub("%C", "")) * self.credits_font:getHeight() + H
    self.cur_time = 0
end

function state:update(dt)
    Timer.update(dt)
    self.cur_time = self.cur_time + dt
    if self.cur_time > self.duration  then Gamestate.pop()  end
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

    love.graphics.setFont(self.credits_font)

    love.graphics.printf(credits, 0, H + 2 * self.credits_font:getHeight(), W, "center")

    love.graphics.translate(0, dy)
end

function state:leave()
    ROOM:disconnect()
    PopManager.pop = nil
    FX.quick_static(1)
end

return state
