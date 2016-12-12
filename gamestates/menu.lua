local Timer = require "hump.timer"
local state = {}

function state:enter()
    local bg

    -- Create background
    bg = IMAGE(0, 0, BG_IMG)
    bg:addElement(DRAW_TABLE.BG, nil, "background")

    self.fade_in_alp = 255
    Timer.tween(.3, self, {fade_in_alp = 0})

end

function state:update(dt)
    Timer.update(dt)
end

function state:draw()

    Draw.allTables()

    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(FONTS.fira(200))
    love.graphics.printf("room.hack", 0, 120, W, "center")
    love.graphics.setFont(FONTS.fira(15))
    love.graphics.printf("press any key to continue...", W * .6, H - 100, W, "left")

    -- fade in
    love.graphics.setColor(0, 0, 0, self.fade_in_alp)
    love.graphics.rectangle("fill", 0, 0, W, H)

end

function state:keypressed()
    Gamestate.switch(GS.GAME)
end

function state:mousepressed()
    Gamestate.switch(GS.GAME)
end

return state
