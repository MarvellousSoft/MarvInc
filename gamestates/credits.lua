local Timer = require "hump.timer"
local FX = require "classes.fx"
local state = {}

function state:enter()
    local bg

    self.dy = H + 100
end

function state:update(dt)
    Timer.update(dt)
    self.dy = self.dy - dt * 100
    if self.dy < -1000 then Gamestate.pop() FX.intro() end
end

function state:draw()

    Draw.allTables()

    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, W, H)
    love.graphics.setColor(255, 255, 255)

    love.graphics.setFont(FONTS.fira(30))
    local x, y, w = 30, H / 2 - 100, 600
    love.graphics.printf("Installing Marvellous OS 2.0", x, y, w, "center")
    local dh = love.graphics.getFont():getHeight()
    local bh = 60
    love.graphics.rectangle("line", x, y + dh, w, bh)
    local b = 5
    local prog = (H + 100 - self.dy) / (H + 1100)
    love.graphics.rectangle("fill", x + b, y + dh + b, prog * (w - 2 * b), bh - 2 * b)

    love.graphics.setFont(FONTS.fira(15))
    love.graphics.printf("Please do not turn off your computer...", x, y + dh + bh + 2 * b, w, "center")

    love.graphics.translate(0, self.dy)

    love.graphics.setFont(FONTS.fira(50))

    love.graphics.printf([[
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
, W/2, 0, W/2, "center")

    love.graphics.translate(0, -self.dy)
end

return state
