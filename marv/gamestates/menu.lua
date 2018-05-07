--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local Timer = require "extra_libs.hump.timer"
require "classes.text_box"
require "classes.button"
local ScrollWindow = require "classes.scroll_window"
local state = {}
local bgm
local user_font = FONTS.fira(22)
local delete_font = FONTS.firaBold(22)


local function try_login()
    if #state.box.lines[1] == 0 then
        SFX.buzz:stop()
        SFX.buzz:play()
    else
        Gamestate.switch(GS.GAME, state.box.lines[1])
        bgm:fadeout()
        SFX.login:stop()
        SFX.login:play()
    end
end

function state:init()
    bgm = Music(MUSIC.menu.path, "stream", MUSIC.menu.base_volume)
end

function state:enter()

    --Start menu bgm
    bgm:fadein()

    -- Create background
    local bg = IMAGE(0, 0, BG_IMG)
    bg:addElement(DRAW_TABLE.BG, nil, "background")

    -- Create logo
    local logo = IMAGE(W / 2 - MISC_IMG.logo:getWidth() * .75 / 2, 150, MISC_IMG.logo, Color.white(), .75)
    logo:addElement(DRAW_TABLE.GUI, nil, "logo")

    -- Exit button
    local exit = function()
        if not IS_EXITING then
            IS_EXITING = true
            love.event.quit()
        end
    end
    self.exit_b = ImgButton(W - 60, 10, 50, BUTS_IMG.exit, exit, "Exit")
    self.exit_b.hover_img = BUTS_IMG.exit_hover

    self.fade_in_alp = 255
    Timer.tween(.3, self, {fade_in_alp = 0})

    local w = 300

    self.box = TextBox((W - w) / 2, H - 300, w, 19, 1, 1, false, FONTS.fira(25))
    self.box:activate()

    local bw, bh = 80, 40
    self.font = FONTS.fira(20)
    local c = Color.green()
    c.l = 30
    self.login = Button((W - bw) / 2, self.box.pos.y + self.box.h + 10, bw, bh, try_login, "login", self.font, nil, nil, c)


    self:initUsernames()

    if START_USER then
        Gamestate.switch(GS.GAME, START_USER)
    end
end

local function drawUsername(b, x, y, mx, my)
    local str = "- " .. b.user
    local f = user_font
    local fw, fh = f:getWidth(b.user), f:getHeight(b.user)

    --Draw username
    love.graphics.setFont(f)
    love.graphics.setColor(255, 255, 255)
    love.graphics.print(str, x, y)
    --Draw hover effect
    if b.bx and Util.pointInRect(mx, my, x + f:getWidth("- "), y + 3, fw, fh - 5) then
        love.graphics.setColor(255, 255, 255, 90)
        love.graphics.rectangle("fill", x + f:getWidth("- "), y, fw, fh)
    end

    --Draw delete button
    love.graphics.setLineWidth(1)
    local h = f:getHeight()
    b.bx, b.by, b.bsz = x + f:getWidth(str) + 10, y + h * .1, h * .8
    --Hover effect
    if Util.pointInRect(mx, my, b.bx, b.by, b.bsz, b.bsz) then
        love.graphics.setColor(255, 95, 66, 80)
        love.graphics.rectangle('fill', b.bx, b.by, b.bsz, b.bsz)
    end
    Color.set(Color.red())
    f = delete_font
    love.graphics.rectangle('line', b.bx, b.by, b.bsz, b.bsz)
    love.graphics.setFont(f)
    love.graphics.print('X', b.bx + (b.bsz - f:getWidth('X')) / 2, y)
end

function state:usernames_draw()
    local f = love.graphics:getFont()
    if #self.user_buttons > 0 then
        love.graphics.setColor(255, 255, 255)
        mx, my = self.username_mx, self.username_my
        local cx, cy = self.user_buttons.x, self.user_buttons.y
        for _, b in ipairs(self.user_buttons) do
            drawUsername(b, cx, cy, mx, my)
            cy = cy + f:getHeight()
        end
        self.usernames_h = cy + 4 - self.user_buttons.y
    end
end

function state:usernames_mouseMoved(x, y)
    self.username_mx, self.username_my = x, y
end

function state:usernames_mousePressed(x, y, but)
    if but == 1 then
        local ub = self.user_buttons
        if x >= ub.x and y >= ub.y then
            local i = math.floor((y - ub.y) / self.font:getHeight()) + 1
            if i > 0 and i <= #ub and ub[i].bx and Util.pointInRect(x, y, ub[i].bx, ub[i].by, ub[i].bsz, ub[i].bsz) then
                WarningWindow.show("Warning", "Are you sure you want to delete user " ..'"'..ub[i].user ..'"'.."?",
                    {'Yes', function()
                                SaveManager.deleteUser(ub[i].user)
                                self:initUsernames()
                            end,
                     'No, sorry', nil, enter = 1, escape = 2
                    }
                )
            --If clicking on username, write username on login
            elseif i > 0 and i <= #ub and ub[i].bx and Util.pointInRect(x, y, ub[i].bx - user_font:getWidth(ub[i].user) - 10, ub[i].by, user_font:getWidth(ub[i].user), user_font:getHeight(ub[i].user)) then
                self.box:reset_lines(1)
                for c = 1, #ub[i].user do
                    self:textinput(ub[i].user:sub(c,c))
                end
            end
        end
    end
end

function state:initUsernames()
    -- list of usernames and buttons to delete them
    self.user_buttons = {}
    local ub = self.user_buttons
    for user in pairs(SaveManager.user_data) do
        table.insert(ub, {user = user})
    end
    ub.y = H * .60
    ub.x = W * .65
    self.username_mx, self.username_my = 0, 0
    local usernames = {
        pos = {x = ub.x, y = ub.y},
        getHeight = function() return self.usernames_h end,
        mousePressed = function(obj, ...) self:usernames_mousePressed(...) end,
        draw = function() self:usernames_draw() end,
        mouseMoved = function(obj, ...) self:usernames_mouseMoved(...) end,
    }
    self.known_usernames = ScrollWindow(300, H - 10 - ub.y, usernames)
    self.known_usernames.sw = 8
    self.known_usernames.color = {200, 200, 200, 100}
    self.usernames_h = H - 10 - ub.y
end

function state:update(dt)
    Timer.update(dt)
end

function state:draw()

    Draw.allTables()

    -- username box
    local f = self.font
    love.graphics.setFont(f)
    love.graphics.print("Username:", (W - self.box.w) / 2, H - 300 - f:getHeight() - 5)

    love.graphics.print('v' .. VERSION, W - f:getWidth('v' .. VERSION) - 10, H - f:getHeight() - 10)

    love.graphics.setLineWidth(.5)
    love.graphics.rectangle("line", (W - self.box.w) / 2, H - 300, self.box.w, self.box.h)
    self.box:draw()

    self.login:draw()

    -- known usernames
    love.graphics.setColor(255, 255, 255)
    love.graphics.print("Known users:", self.user_buttons.x + 20, self.user_buttons.y - f:getHeight() * 1.2)
    self.known_usernames:draw()

    -- fade in
    love.graphics.setColor(0, 0, 0, self.fade_in_alp)
    love.graphics.rectangle("fill", 0, 0, W, H)

    --exit button
    self.exit_b:draw()

end

function state:keypressed(key)
    --Toggle fullscreen
    if key == 'f11' then
        if not love.window.getFullscreen() then
            PREV_WINDOW = {love.window.getMode()}
            love.window.setFullscreen(true, "desktop")
            love.resize(love.window.getMode())
        else
            love.window.setFullscreen(false, "desktop")
            if PREV_WINDOW then
                love.window.setMode(unpack(PREV_WINDOW))
            end
            love.resize(love.window.getMode())
        end
        local set = Util.findId("settings_tab")
        if set then set:refresh() end
    end
    if key == 'return' or key == 'kpenter' then
        try_login()
        return
    end
    self.box:keyPressed(key)
end

function state:textinput(t)
    local new_t = string.lower(t) --Force lowercase letters only
    self.box:textInput(new_t)
end

function state:mousepressed(x, y, but)
    self.box:mousePressed(x, y, but)
    self.known_usernames:mousePressed(x, y, but)
    self.exit_b:mousePressed(x, y, but)
    if but == 1 then self.login:checkCollides(x, y) end
end

function state:mousemoved(...)
    self.known_usernames:mouseMoved(...)
end

function state:mousereleased(x, y, but)
    self.box:mouseReleased(x, y, but)
    self.known_usernames:mouseReleased(x, y)
end

function state:wheelmoved(...)
    self.known_usernames:mouseScroll(...)
end

function state:update(dt)
    self.known_usernames:update(dt)
    Timer.update(dt)
    AUDIO_TIMER:update(dt)
    self.box:update(dt)
end

function state:leave()
    Util.findId("logo"):kill()
    self.box:deactivate()
end

return state
