local state = {}

function state:enter()
    local bg

    -- Create background
    bg = IMAGE(0, 0, BG_IMG)
    bg:addElement(DRAW_TABLE.BG, nil, "background")

end

function state:update(dt)
end

function state:draw()

    Draw.allTables()
    
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
