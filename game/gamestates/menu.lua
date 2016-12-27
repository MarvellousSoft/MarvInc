local Timer = require "hump.timer"
require "classes.text_box"
require "classes.button"
local state = {}

local function try_login()
    if #state.box.lines[1] == 0 then
        SFX.buzz:stop()
        SFX.buzz:play()
    else
        Gamestate.switch(GS.GAME, state.box.lines[1])
    end
end

function state:enter()
    local bg

    -- Create background
    bg = IMAGE(0, 0, BG_IMG)
    bg:addElement(DRAW_TABLE.BG, nil, "background")

    self.fade_in_alp = 255
    Timer.tween(.3, self, {fade_in_alp = 0})

    local w = 300

    self.box = TextBox((W - w) / 2, H - 300, w, 19, 1, 1, false, FONTS.fira(25))
    self.box:activate()

    local bw, bh = 80, 40
    self.login = Button((W - bw) / 2, self.box.pos.y + self.box.h + 5, bw, bh, try_login, "login", FONTS.fira(20), nil, nil, Color.new(self.box.color))
end

function state:update(dt)
    Timer.update(dt)
end

function state:draw()

    Draw.allTables()

    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(FONTS.fira(120))
    love.graphics.printf("Marvellous Inc.", 0, 200, W, "center")

    -- username box
    local f = FONTS.fira(20)
    love.graphics.setFont(f)
    love.graphics.print("Username:", (W - self.box.w) / 2, H - 300 - f:getHeight() - 5)
    love.graphics.setLineWidth(.5)
    love.graphics.rectangle("line", (W - self.box.w) / 2, H - 300, self.box.w, self.box.h)
    self.box:draw()

    self.login:draw()

    -- fade in
    love.graphics.setColor(0, 0, 0, self.fade_in_alp)
    love.graphics.rectangle("fill", 0, 0, W, H)

end

function state:keypressed(key)
    if key == 'return' or key == 'kpenter' then
        try_login()
        return
    end
    self.box:keyPressed(key)
end

function state:textinput(t)
    self.box:textInput(t)
end

function state:mousepressed(x, y, but)
    self.box:mousePressed(x, y, but)
    if but == 1 then self.login:checkCollides(x, y) end
end

function state:update(dt)
    Timer.update(dt)
    self.box:update(dt)
end

function state:leave()
    self.box:deactivate()
end

return state
