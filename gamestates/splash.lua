local state = {}

function state:enter()
    img = love.graphics.newImage("assets/images/Marvellous Soft.png")
    cur_time = 0
end

function state:update(dt)
    cur_time = cur_time + dt
    if cur_time > 1.5 then
        Gamestate.switch(GS.MENU)
    end
end

function state:draw()
    love.graphics.rectangle("fill", 0, 0, W, H)
    love.graphics.draw(img, 0, 0)
end

function state:keypressed()
    Gamestate.switch(GS.MENU)
end

function state:mousepressed()
    Gamestate.switch(GS.MENU)
end

return state
