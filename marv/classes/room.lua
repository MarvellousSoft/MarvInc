--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

require "classes.primitive"
local Color = require "classes.color.color"
local Reader = require "classes.reader"

--LOCAL VARIABLES--

local max_time_between_bot_messages = 200
local min_time_between_bot_messages = 2
local bot_message_timer_handle = nil

--ROOM CLASS--

--Room functions table
local room = {}

Room = Class{
    __includes = {RECT},
    init = function(self)
        local b = WIN_BORD
        RECT.init(self, W - (H - b), b, H - 2 * b, H - 2 * b, Color.orange())

        self.tp = "room"
        -- Online or offline
        self.mode = "offline"

        -- Grid numbering
        self.grid_fnt = FONTS.fira(20)
        self.grid_fnt_clr = Color.white()
        self.grid_fnt_h = self.grid_fnt:getHeight()
        self.grid_alpha = false
        self.grid_foc_clr = Color.white()
        self.grid_trans_timer = Timer.new()
        self.grid_trans_delay = 0.01
        self.grid_transFunc = function() -- Transition function
            if self.grid_alpha then
                self.grid_foc_clr.a = self.grid_foc_clr.a + 2
                if self.grid_foc_clr.a > 255 then
                    self.grid_foc_clr.a = 255
                    self.grid_alpha = false
                end
            else
                self.grid_foc_clr.a = self.grid_foc_clr.a - 2
                if self.grid_foc_clr.a < 0 then
                    self.grid_foc_clr.a = 0
                    self.grid_alpha = true
                end
            end
        end

        -- Grid
        self.grid_clr = Color.blue()
        self.grid_r, self.grid_c = ROWS + 2, COLS + 2
        self.grid_cw = self.w/self.grid_r -- Cell width
        self.grid_ch = self.h/self.grid_c -- Cell height
        self.grid_w = self.w - 2*self.grid_cw
        self.grid_h = self.h - 2*self.grid_ch
        self.grid_x, self.grid_y = self.pos.x + self.grid_cw, self.pos.y + self.grid_ch
        self.grid_r, self.grid_c = self.grid_r - 2, self.grid_c - 2
        self.grid_floor = nil
        self.grid_obj = nil

        -- Set global vars
        ROOM_CW, ROOM_CH = self.grid_cw, self.grid_ch
        ROOM_ROWS, ROOM_COLS = self.grid_r, self.grid_c

        -- Border
        self.border_clr = Color.new(132, 20, 30)

        -- Live marker
        self.mrkr_fnt = FONTS.fira(28)
        self.mrkr_clr = Color.red()
        -- Relative to pos
        self.mrkr_x = self.w - self.grid_cw - self.mrkr_fnt:getWidth("LIVE")
        self.mrkr_offx = self.w - self.grid_cw - self.mrkr_fnt:getWidth("OFFLINE")
        self.mrkr_y = 0
        self.mrkr_drw = true
        self.mrkr_timer = MAIN_TIMER:every(1, function()
            self.mrkr_drw = not self.mrkr_drw
        end)

        -- Current tile coordinates
        self.cursor_x, self.cursor_y = -1, -1
        self.cursor_mov_dt = 0
        self.tile_coord_bg_color = Color.new(10,10,10,170,"rgb")

        -- Offline background
        self.back_fnt_sz = 50
        self.back_clr = Color.white()
        self.back_tclr = Color.white()
        self.back_img = BG_IMG
        self.back_sx = self.grid_w/BG_IMG:getWidth()
        self.back_sy = self.grid_h/BG_IMG:getHeight()

        -- Exit button
        local exit = function()
            if not IS_EXITING then
                IS_EXITING = true
                SaveManager.logout()
                FX.full_static(function() love.event.quit() end)
            end
        end
        self.exit_b = ImgButton(self.grid_x + self.grid_w - 115, self.grid_y + 10, 50, BUTS_IMG.exit, exit, "Exit")
        self.exit_b.hover_img = BUTS_IMG.exit_hover

        -- Reboot button
        local reboot = function()
            if not IS_EXITING then
                IS_EXITING = true
                SaveManager.logout()
                FX.full_static(function() love.event.quit('restart') end)
            end
        end
        self.reboot_b = ImgButton(self.grid_x + self.grid_w - 60, self.grid_y + 10, 50, BUTS_IMG.reboot, reboot, "Reboot")
        self.reboot_b.hover_img = BUTS_IMG.reboot_hover

        -- Static transition
        self.static_dhdl = nil
        self.static_rhdl = nil
        local static_img = MISC_IMG.static
        self.static_sx = self.grid_w / static_img:getWidth()
        self.static_sy = self.grid_h / static_img:getHeight()
        self.static_r = 0
        self.static_on = false

        -- Room objectives
        self.objs = nil

        -- Current puzzle id
        self.puzzle_id = nil
        -- If current puzzle is custom
        self.is_custom = nil

        -- Death

        ROOM = self

        -- Star
        self.star_color = Color.new(255, 10, 170)
        self.draw_star = false

        -- OS Version
        self.version = "0.1"
    end
}

function Room:from(id, is_custom, test_i, megafast)
    if self.turn_handler then
        Signal.remove(SIGEND, self.turn_handler)
    end

    local puzzle = Reader.read(id, is_custom, test_i or 1)
    self:clear()
    self.puzzle = puzzle
    self.mode = "online"
    INIT_POS = puzzle.init_pos
    self.test_i = test_i or 1

    self.grid_obj = puzzle.grid_obj
    self.grid_floor = puzzle.grid_floor
    self.inv_wall = puzzle.inv_wall
    self.color_floor = {}
    for i = 1, self.grid_r do
        self.color_floor[i] = {}
    end

    self.bot = Bot(self.grid_obj, INIT_POS.x, INIT_POS.y)
    self.default_bot_turn = _G[puzzle.orient.."_R"]
    self.bot:turn(self.default_bot_turn)

    self.extra_info = puzzle.extra_info
    local ct = Util.findId("code_tab")
    ct:reset(puzzle)
    -- running a mega fast test
    if megafast then
        ct.fast_b:block(BUTS_IMG.fast_blocked)
        ct.superfast_b:block(BUTS_IMG.superfast_blocked)
        ct.pause_b:block(BUTS_IMG.pause_blocked)
        ct.play_b:block(BUTS_IMG.play_blocked)
    end
    ROOM.megafast = megafast or false

    self.turn_handler = puzzle.turn_handler
    if self.turn_handler then
        Signal.register(SIGEND, self.turn_handler)
    end
    self.block_bot_messages = false

    StepManager.only_play_button = false

    if puzzle.on_start then
        puzzle.on_start(self)
    end
end

function Room:paint(i, j, floor)
    self.grid_floor[i][j] = floor
end

function Room:extract(i, j)
    local _e = self.grid_obj[i][j]
    self.grid_obj[i][j] = nil
    return _e
end

function Room:clear()
    self.grid_obj = nil
    self.grid_floor = nil
    self.bot = nil
    StepManager.clear()
end

function Room:connect(id, changeToInfo, is_custom, test_i, megafast)
    if self.mode ~= "offline" then self:disconnect(false) end
    SFX.loud_static:stop()
    SFX.loud_static:play()
    self.puzzle_id = id
    self.is_custom = is_custom
    if not is_custom and id == 'ryr' then
        GS['GAME'].getBGMManager():stopBGM()
        GS['GAME'].getBGMManager():newBGM(MUSIC.final_puzzle)
    end
    self.static_on = true
    self.static_dhdl = MAIN_TIMER:after(0.0675, function()
        SFX.loud_static:stop()
        self.static_on = false
        MAIN_TIMER:cancel(self.static_rhdl)
    end)
    self.static_rhdl = MAIN_TIMER:every(0.05, function()
        self.static_r = self.static_r + math.pi/2
    end)

    self:from(id, is_custom, test_i or 1, megafast)

    local pc = Util.findId("pcbox")
    if changeToInfo == nil or changeToInfo == true then pc:changeTabs(pc.puzzle_tabs, "info") end

    self.grid_trans_handle = self.grid_trans_timer:every(self.grid_trans_delay, self.grid_transFunc)

    self:createEphemeral()
end

function Room:disconnect(wait)
    self.grid_trans_timer:cancel(self.grid_trans_handle)

    if self.turn_handler then
        Signal.remove(SIGEND, self.turn_handler)
        self.turn_handler = nil
    end

    Util.findId('code_tab'):saveCurrentCode()
    self.prev_puzzle_id = self.puzzle_id
    self.mode = "offline"

    if not self.is_custom and self.puzzle_id == 'franz1' then
        local Mail = require 'classes.tabs.email'
        if not Mail.exists('Tread very carefully') and not LoreManager.puzzle_done.franz1 then
            Mail.new('franz1_1')
        end
    elseif not self.is_custom and self.puzzle_id == 'ryr' then
        GS['GAME'].getBGMManager():stopBGM()
        GS['GAME'].getBGMManager():newBGM()
    end

    if wait == nil or wait then
        SFX.loud_static:stop()
        SFX.loud_static:play()

        self.static_on = true
        self.static_dhdl = MAIN_TIMER:after(0.0675, function()
            SFX.loud_static:stop()
            self.static_on = false
            MAIN_TIMER:cancel(self.static_rhdl)
        end)
        self.static_rhdl = MAIN_TIMER:every(0.05, function()
            self.static_r = self.static_r + math.pi/2
        end)
        Util.findId("pcbox"):changeTabs(Util.findId("pcbox").menu_tabs, "email")
    end
    if self.puzzle.on_end then
        self.puzzle.on_end(self)
    end
    self.puzzle_id = nil
    self.is_custom = nil

    --Handle bots messages--

    --Remove handle for creating a new bot message
    if(bot_message_timer_handle) then
      MAIN_TIMER:cancel(bot_message_timer_handle)
    end
    bot_message_timer_handle = nil

    --Remove any message still active
    local messages = Util.findSbTp("bot_message")
    if messages then
      for message in pairs(messages) do
        if message.handles["destroy"] then
          MAIN_TIMER:cancel(message.handles["destroy"])
        end
        if not message.handles["leave_movement"] then
          message.handles["leave_movement"] = MAIN_TIMER:tween(.5, message.pos, {x = message.pos.x + message.w}, "in-quad",
              function()
                  message.death = true
              end
          )
        end
      end
    end

    -- If custom puzzle, remove assets.
    CUST_OBJS_IMG = {}
    CUST_TILES_IMG = {}
    CUST_SHEET_IMG = {}

    self:clear()
end

function Room:connected()
    return self.mode == "online"
end

local black = Color.black()

function Room:draw()

    -- Border
    love.graphics.push()
    love.graphics.translate(self.pos.x, self.pos.y)
    Color.set(self.border_clr)
    love.graphics.rectangle('fill', 0, 0, self.w, self.h)

    -- Live marker
    love.graphics.setFont(FONTS.fira(28))
    Color.set(self.mrkr_clr)
    if self.mode == "online" then
        love.graphics.print("LIVE", self.mrkr_x, self.mrkr_y)
        if self.mrkr_drw then
            love.graphics.circle("fill", self.mrkr_x - 25, self.mrkr_y + 17, 10)
        end
    else
        love.graphics.print("OFFLINE", self.mrkr_offx, self.mrkr_y)
    end
    love.graphics.pop()

    -- Set origin to table position
    love.graphics.push()
    love.graphics.translate(self.grid_x, self.grid_y)

    if self.mode == "online" then
        -- Floor
        for i=1, self.grid_r do
            local _x = (i-1)*self.grid_cw
            for j=1, self.grid_c do
                local obj = self.grid_obj[i][j]
                local _bg = true
                if obj ~= nil then
                  _bg = obj.bg
                end
                local cell = self.grid_floor[i][j]
                if cell ~= nil and _bg then
                    local img = CUST_TILES_IMG[cell]
                    if img == nil then
                        img = TILES_IMG[cell]
                    end
                    local _y = (j-1)*self.grid_ch
                    local _sx, _sy = self.grid_cw/img:getWidth(), self.grid_ch/img:getHeight()
                    Color.set(self.color_floor[i][j] or Color.white())
                    love.graphics.draw(img, _x, _y, nil, _sx, _sy)
                end
                if obj ~= nil then
                    obj:draw()
                end
            end
        end
        -- post draw (for drawing things on top of the other objs)
        for i=1, self.grid_r do
            for j=1, self.grid_c do
                local obj = self.grid_obj[i][j]
                if obj ~= nil and obj.postDraw then
                    obj:postDraw()
                end
            end
        end

        if self.puzzle.postDraw then
            self.puzzle.postDraw()
        end

    else
        Color.set(self.back_clr)
        love.graphics.draw(self.back_img, 0, 0, nil, self.back_sx, self.back_sy)
        local fnt = self.version <= "1.0" and FONTS.comfortaaBold or self.version <= "2.0" and FONTS.comfortaa or FONTS.comfortaaLight
        local back_fnt = fnt(self.back_fnt_sz)
        love.graphics.setFont(back_fnt)
        Color.set(self.back_tclr)
        love.graphics.printf("Marvellous OS", 0, (self.grid_h - back_fnt:getHeight())/2, self.w, "center")

        local dy = back_fnt:getHeight()
        love.graphics.setFont(back_fnt)
        love.graphics.printf(self.version, self.w * .75, (self.grid_h - back_fnt:getHeight()) / 2 + dy + 10, self.w / 4)
    end

    if self.static_on then
        Color.set(self.back_clr)
        love.graphics.push()
        love.graphics.origin()
        local s = MISC_IMG.static
        love.graphics.draw(s,
            self.grid_x + self.grid_w/2, self.grid_h/2 + self.grid_y,
            self.static_r, self.static_sx, self.static_sy,
            s:getWidth()/2, s:getHeight()/2)
        love.graphics.pop()
    end

    -- Grid numbering
    Color.set(black)
    -- black borders
    --love.graphics.rectangle('fill', -self.grid_cw - 10, -2 * self.grid_ch ,10 +  self.grid_cw, self.grid_ch * (3 + self.grid_r))
    --love.graphics.rectangle('fill', self.grid_cw * self.grid_c, 0, 2 * self.grid_cw, self.grid_ch * (1 + self.grid_r))
    --love.graphics.rectangle('fill', -self.grid_cw, self.grid_ch * self.grid_r, self.grid_cw * (1 + self.grid_c), self.grid_ch)
    --love.graphics.rectangle('fill', -self.grid_cw, -2 * self.grid_ch, self.grid_cw * (2 + self.grid_c), 2 * self.grid_ch)
    Color.set(self.grid_fnt_clr)
    love.graphics.setFont(self.grid_fnt)
    love.graphics.setLineWidth(.5)
    for i=1, self.grid_r do
        local _s = tostring(i)
        --if i < 10 then _s = '0'.._s end
        if self.mode == "online" and i == self.bot.pos.y then Color.set(self.grid_foc_clr) end
        love.graphics.printf(_s, -self.grid_cw, self.grid_ch*(i-1) + self.grid_fnt_h/2 - 5,
            30, "right")
        if self.mode == "online" and i == self.bot.pos.y then Color.set(self.grid_fnt_clr) end
        love.graphics.line(-self.grid_cw, self.grid_ch*(i-1), 0, self.grid_ch*(i-1))
    end
    love.graphics.line(-self.grid_cw, self.grid_ch*self.grid_r, 0, self.grid_ch*self.grid_r)
    for i=1, self.grid_c do
        local _s = tostring(i)
        --if i < 10 then _s = '0'.._s end
        if self.mode == "online" and i == self.bot.pos.x then Color.set(self.grid_foc_clr) end
        love.graphics.print(_s, self.grid_cw*(i-0.5) - self.grid_fnt:getWidth(_s)/2,
            self.grid_h + self.grid_ch/2 - self.grid_fnt_h/2)
        if self.mode == "online" and i == self.bot.pos.x then Color.set(self.grid_fnt_clr) end
        love.graphics.line(self.grid_cw*(i-1), self.grid_h+2,
            self.grid_cw*(i-1), self.grid_h+self.grid_ch)
    end
    love.graphics.line(self.grid_cw*self.grid_c, self.grid_h+2,
        self.grid_cw*self.grid_c, self.grid_h+self.grid_ch)


    -- Set origin to (0, 0)
    love.graphics.pop()

    --Draw exit and reboot buttons
    if self.mode == "offline" then
        self.exit_b:draw()
        self.reboot_b:draw()
    end

    --Draw camera screen
    Color.set(Color.white())
    love.graphics.draw(ROOM_CAMERA_IMG, self.pos.x- 45, self.pos.y - 45)


    -- Star
    if self.draw_star then
        Color.set(self.star_color)
        local star = MISC_IMG.star
        local sz = 50
        love.graphics.draw(star, self.pos.x + sz / 2, self.pos.y + self.mrkr_y + sz / 2, -1, sz / star:getWidth(), nil, star:getWidth() / 2, star:getHeight() / 2)
    end

    -- Cursor tile coordinates
    if self.cursor_mov_dt > 0.1 then
        if self.cursor_x > 0 and self.cursor_y > 0 then
            local cx, cy = love.mouse.getPosition()
            local text_x, text_y = cx+10, cy+10
            local text = "(" .. self.cursor_y .. ", " .. self.cursor_x .. ")"
            local font = self.grid_fnt
            local margin = 5
            local w, h = font:getWidth(text) + 2*margin, font:getHeight(text) + 2*margin
            --Draw background
            Color.set(self.tile_coord_bg_color)
            love.graphics.rectangle("fill", text_x - margin, text_y - margin, w, h, 5)
            --Draw coordinates
            love.graphics.setFont(font)
            Color.set(Color.green())
            love.graphics.print(text, text_x, text_y)
        end
    end
end

function Room:update(dt)
    if self.mode == "online" then

        --Create a bot message to popup for the player
        if not self.block_bot_messages and not bot_message_timer_handle then
            local d = love.math.random(min_time_between_bot_messages, max_time_between_bot_messages)
            bot_message_timer_handle = MAIN_TIMER:after(d,
                function()
                    Signal.emit("new_bot_message")
                    bot_message_timer_handle = nil
                end
            )
        end

        -- Get cursor's tile coordinates.
        self.cursor_mov_dt = self.cursor_mov_dt + dt
        local cx, cy = love.mouse.getPosition()
        if cx > self.grid_x and cx < self.grid_x + self.grid_w and
            cy > self.grid_y and cy < self.grid_y + self.grid_h then
            local px, py = cx - self.grid_x, cy - self.grid_y
            self.cursor_x, self.cursor_y = math.floor(px/self.grid_cw)+1, math.floor(py/self.grid_ch)+1
        else
            self.cursor_x, self.cursor_y = -1, -1
        end

        self.grid_trans_timer:update(dt)
        for _, v in pairs(self.grid_obj) do
            if v.death and v.destroy then
                v.destroy()
            end
        end

        if self.puzzle.update then
            self.puzzle.update(dt)
        end
    end
end

function Room:keyPressed(key)
end

function Room:mouseMoved()
    self.cursor_mov_dt = 0
end

function Room:mousePressed(x, y, but)
    if self.mode == "offline" then
        self.exit_b:mousePressed(x, y, but)
        self.reboot_b:mousePressed(x, y, but)
    end
end

function Room:kill(keep_bot)
    self.bot:cleanAndKill(keep_bot)
end

-- Careful when calling this function!
function Room:put(obj, i, j)
    obj:teleport(self.grid_obj, i, j)
end

function Room:walk()
    self.bot:move(self.grid_obj, self.grid_r, self.grid_c)
end

-- Dorment objects (DeadSwitch).
Room.dorments = {}

function Room:sedate(ds, y)
    if not y then
        local px, py = ds.pos.x, ds.pos.y
        if ds.bg then
            ds.of = self.grid_floor[px][py]
        end
        if ds.skey then
            self:paint(px, py, ds.skey)
        end
        self:extract(px, py)
        self.grid_obj[ds.pos.x][ds.pos.y] = nil
        Room.dorments[ds] = ds
    else
        local _d = self.grid_obj[ds][y]
        if _d then
            self:sedate(_d)
        end
    end
end

function Room:wakeup(ds, y)
    if not y then
        local px, py = ds.pos.x, ds.pos.y
        if self.bot.pos.x == px and self.bot.pos.y == py then
            -- this will be handled by Bot:dieIfStay
        end
        self:paint(px, py, ds.of)
        self.grid_obj[px][py] = ds
        Room.dorments[ds] = nil
    else
        local px, py = ds, y
        for k, _ in pairs(Room.dorments) do
            if k.pos.x == px and k.pos.y == py then
                if self.grid_obj[px][py] then
                    self.grid_obj[px][py] = nil
                end
                self:wakeup(k)
                return
            end
        end
    end
end

-- Creates 1-turn stuff (e.g. lasers)
function Room:createEphemeral()
    for i = 1, ROWS do
        for j = 1, COLS do
            if self.grid_obj[j][i] and self.grid_obj[j][i].tp == 'emitter' then
                self.grid_obj[j][i]:createRays(self.grid_obj)
            end
        end
    end
end

-- Deletes 1-turn stuff (e.g. lasers)
function Room:deleteEphemeral()
    for i = 1, ROWS do
        for j = 1, COLS do
            if self.grid_obj[j][i] and self.grid_obj[j][i].is_ephemeral then
                self.grid_obj[j][i] = nil
            end
        end
    end
end

function Room:clock()
    self.bot:clock()
end

function Room:counter()
    self.bot:counter()
end

function Room:turn(dir)
    self.bot:turn(_G[dir:upper() .. "_R"])
end

function Room:pickup()
    return self.bot:pickup(self.grid_obj, self.grid_r, self.grid_c)
end

function Room:drop()
    return self.bot:drop(self.grid_obj, self.grid_r, self.grid_c)
end

function Room:blocked(o, notify)
    return self.bot:blocked(self.grid_obj, self.grid_r, self.grid_c, o, notify)
end

function Room:next_block(o)
    return self.bot:next_block(self.grid_obj, self.grid_r, self.grid_c, o)
end

--UTILITY FUNCTIONS--

function room.create()
    local r

    r = Room()
    r:addElement(DRAW_TABLE.L1, nil, "room")

    return r
end

return room
