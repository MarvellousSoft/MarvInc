local state = {}

function state:enter()
end

function state:update(dt)
end

function state:draw()
    love.graphics.setColor(0, 10, 10)
    love.graphics.rectangle("fill", 0, 0, W, H)
    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(FONTS.fira(200))
    love.graphics.printf("room.hack", 0, 120, W, "center")
    love.graphics.setFont(FONTS.fira(15))
    love.graphics.printf("press any key to continue...", W * .6, H - 100, W, "left")
end

function state:keypressed()
    Gamestate.switch(GS.GAME)
end

function state:mousepressed()
end

return state
