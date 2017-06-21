local Timer = require "extra_libs.hump.timer"
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
    self.font = FONTS.fira(20)
    self.login = Button((W - bw) / 2, self.box.pos.y + self.box.h + 5, bw, bh, try_login, "login", self.font, nil, nil, Color.new(self.box.color))

    self:initUsernames()
end

local function drawUsername(b, x, y)
    local str = "- " .. b.user
    local f = love.graphics.getFont()
    love.graphics.setColor(255, 255, 255)
    love.graphics.print(str, x, y)
    love.graphics.setLineWidth(.5)
    local h = f:getHeight()
    Color.set(Color.red())
    b.bx, b.by, b.bsz = x + f:getWidth(str) + 10, y + h * .1, h * .8
    love.graphics.rectangle('line', b.bx, b.by, b.bsz, b.bsz)
    love.graphics.print('X', b.bx + (b.bsz - f:getWidth('X')) / 2, y)
end

function state:initUsernames()
    -- list of usernames and buttons to delete them
    self.user_buttons = {}
    local ub = self.user_buttons
    for user in pairs(SaveManager.user_data) do
        table.insert(ub, {user = user})
    end
    ub.y = H * .65 - ((#ub + 1) * self.font:getHeight()) / 2
    ub.x = W * .75
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
    local f = self.font
    love.graphics.setFont(f)
    love.graphics.print("Username:", (W - self.box.w) / 2, H - 300 - f:getHeight() - 5)
    love.graphics.setLineWidth(.5)
    love.graphics.rectangle("line", (W - self.box.w) / 2, H - 300, self.box.w, self.box.h)
    self.box:draw()

    self.login:draw()

    -- known usernames
    if #self.user_buttons > 0 then
        love.graphics.setColor(255, 255, 255)
        local cx, cy = self.user_buttons.x, self.user_buttons.y
        love.graphics.print("Known users:", cx, cy)
        for _, b in ipairs(self.user_buttons) do
            cy = cy + f:getHeight()
            drawUsername(b, cx, cy)
        end
    end

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
    if but == 1 then
        local ub = self.user_buttons
        if x >= ub.x and y >= ub.y then
            local i = math.floor((y - ub.y) / self.font:getHeight())
            if i > 0 and i <= #ub and ub[i].bx and Util.pointInRect(x, y, ub[i].bx, ub[i].by, ub[i].bsz, ub[i].bsz) then
                local press = love.window.showMessageBox("Warning", "Are you sure you want to delete user " .. ub[i].user .. "?",
                {'Yes', 'No, sorry', enterbutton = 1, escapebutton = 2}, 'warning')
                if press == 1 then
                    SaveManager.deleteUser(ub[i].user)
                    self:initUsernames()
                end
            end
        end
    end
end

function state:mousereleased(x, y, but)
    self.box:mouseReleased(x, y, but)
end

function state:update(dt)
    Timer.update(dt)
    self.box:update(dt)
end

function state:leave()
    self.box:deactivate()
end

return state
