require "classes.primitive"
local Color = require "classes.color.color"
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

        -- Grid
        self.grid_clr = Color.blue()
        self.grid_r, self.grid_c = ROWS + 2, ROWS + 2
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
        self.mrkr_timer = MAIN_TIMER.every(1, function()
            self.mrkr_drw = not self.mrkr_drw
        end)


        -- Offline background
        self.back_fnt = FONTS.fira(50)
        self.back_clr = Color.white()
        self.back_tclr = Color.white()
        self.back_img = BG_IMG
        self.back_sx = self.grid_w/BG_IMG:getWidth()
        self.back_sy = self.grid_h/BG_IMG:getHeight()

        -- Static transition
        self.static_dhdl = nil
        self.static_rhdl = nil
        self.static_img = MISC_IMG["static"]
        self.static_sx = self.grid_w / self.static_img:getWidth()
        self.static_sy = self.grid_h / self.static_img:getHeight()
        self.static_r = 0
        self.static_on = false

        -- Room number and name
        self.n = nil
        self.name = nil

        -- Room objectives
        self.objs = nil

        -- Current puzzle
        self.puzzle = nil

        Signal.register("end_turn", function()
            self:apply()
        end)
        
        -- Death

        ROOM = self


        -- OS Version
        self.version = "1.0"
    end
}


function Room:processDeath()
    StepManager:stopNoKill()
    local n = Util.findId("info_tab").dead
    local death_func = function()
        local _term = Util.findId("code_tab")
        _term:store()
        self:connect(self.puzzle, false)
        _term:retrieve()
        StepManager:check_start()
    end
    if StepManager.mrk_play then death_func() return end
    local title = self.fail_title or "Bot #"..n.." has been destroyed!"
    local text = self.fail_text or
        ("Communications with test subject #"..n.." \""..self.bot.name.."\" have been "..
        "lost. Another unit has been dispatched to replace #"..n..". A notification has "..
        "been dispatched to HR and this incident shall be added to your personal file.")
    local button = self.fail_button or "I will be more careful next time"
    self.fail_title, self.fail_text, self.fail_button = nil, nil, nil
    SFX.fail:stop()
    SFX.fail:play()
    PopManager.new(title, text,
         Color.red(), {
            func = death_func,
            text = button,
            clr = Color.blue()
        })
end

function Room:from(puzzle)
    self:clear()
    self.mode = "online"
    self.name = puzzle.name
    self.n = puzzle.n
    INIT_POS = puzzle.init_pos

    self.grid_obj = nil
    self.grid_floor = nil
    self.grid_obj = puzzle.grid_obj
    self.grid_floor = puzzle.grid_floor

    self.bot = Bot(self.grid_obj, INIT_POS.x, INIT_POS.y)
    self.default_bot_turn = _G[puzzle.orient.."_R"]
    self.bot:turn(self.default_bot_turn)

    self.objs = nil
    self.objs = {}
    for k, v in ipairs(puzzle.objs) do
        self.objs[k] = v
        v:activate()
    end

    self.extra_info = puzzle.extra_info
    Util.findId("code_tab"):reset(puzzle)
end

function Room:paint(i, j, floor)
    self.grid_floor[i][j] = floor
end

function Room:extract(i, j)
    local _e = self.grid_obj[i][j]
    self.grid_obj[i][j] = nil
    return _e
end

function Room:apply()
    while #Room.queue > 0 do
        local o = table.remove(Room.queue, 1)
        if o.tp == "obst" then
            Obstacle(self.grid_obj, o.x, o.y, o.key, o.bg)
        elseif o.tp == "bot" then
            Bot(self.grid_obj, o.x, o.y)
        elseif o.tp == "dead" then
            Dead(self.grid_obj, o.x, o.y, o.key, o.bg)
        else
            print("Type "..o.tp.." not found")
        end
    end
end

-- This is a room queue. Add a prototype of an object to the queue. At the next possible step, or
-- when Room:apply is called, Room will add this to its object grid.
Room.queue = {}
function Room.enqueue(tp, bg, img_trail, x, y)
    table.insert(Room.queue, {
        tp = tp,
        bg = bg,
        key = img_trail,
        x = x,
        y = y
    })
end

function Room:clear()
    self.grid_obj = nil
    self.grid_floor = nil
    self.bot = nil
    self.n = nil
    self.name = nil
    if self.objs then
        for k, _ in pairs(self.objs) do
            StepManager:remove(k)
        end
    end
    self.objs = {}
    Room.queue = {}
    StepManager:removeAll()
    StepManager:stopNoKill()
end

function Room:connect(name, changeToInfo)
    if self.mode ~= "offline" then self:disconnect(false) end
    SFX.loud_static:play()

    self.puzzle = name
    self.static_on = true
    self.static_dhdl = MAIN_TIMER.after(0.0675, function()
        SFX.loud_static:stop()
        self.static_on = false
        MAIN_TIMER.cancel(self.static_rhdl)
    end)
    self.static_rhdl = MAIN_TIMER.every(0.05, function()
        self.static_r = self.static_r + math.pi/2
    end)

    self:from(Reader("puzzles/"..name..".lua"):get())
    if changeToInfo == nil or changeToInfo == true then Util.findId("pcbox"):changeTo("info") end
end

function Room:disconnect(wait)
    if wait == nil or wait then
        SFX.loud_static:play()

        self.static_on = true
        self.static_dhdl = MAIN_TIMER.after(0.0675, function()
            SFX.loud_static:stop()
            self.static_on = false
            MAIN_TIMER.cancel(self.static_rhdl)
        end)
        self.static_rhdl = MAIN_TIMER.every(0.05, function()
            self.static_r = self.static_r + math.pi/2
        end)
    end
    self.mode = "offline"
    self:clear()
end

function Room:connected()
    return self.mode == "online"
end

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
                    local img = TILES_IMG[cell]
                    local _y = (j-1)*self.grid_ch
                    local _sx, _sy = self.grid_cw/img:getWidth(), self.grid_ch/img:getHeight()
                    Color.set(Color.white())
                    love.graphics.draw(img, _x, _y, nil, _sx, _sy)
                end
                if obj ~= nil then
                    obj:draw()
                end
            end
        end

    else
        Color.set(self.back_clr)
        love.graphics.draw(self.back_img, 0, 0, nil, self.back_sx, self.back_sy)
        love.graphics.setFont(self.back_fnt)
        Color.set(self.back_tclr)
        love.graphics.printf("Marvellous OS", 0, (self.grid_h - self.back_fnt:getHeight())/2, self.w, "center")

        local dy = self.back_fnt:getHeight()
        love.graphics.setFont(FONTS.fira(25))
        love.graphics.printf(self.version, self.w * .75, (self.grid_h - self.back_fnt:getHeight()) / 2 + dy + 10, self.w / 4)
    end
    if self.static_on then
        Color.set(self.back_clr)
        love.graphics.push()
        love.graphics.origin()
        love.graphics.draw(self.static_img,
            self.grid_x + self.grid_w/2, self.grid_h/2 + self.grid_y,
            self.static_r, self.static_sx, self.static_sy,
            self.static_img:getWidth()/2, self.static_img:getHeight()/2)
        love.graphics.pop()
    end

    -- Set origin to (0, 0)
    love.graphics.pop()

    --Draw camera screen
    Color.set(Color.white())
    love.graphics.draw(ROOM_CAMERA_IMG, self.pos.x- 45, self.pos.y - 45)
end

function Room:update()
    if self.mode == "online" then
        for _, v in pairs(self.grid_obj) do
            if v.death and v.destroy then
                v.destroy()
            end
        end
    end
end

function Room:keyPressed(key)
    if key == "f8" then
        self:disconnect()
    end
end

function Room:kill()
    self.bot:kill(self.grid_obj)
end

function Room:walk(dir)
    if dir then self:turn(dir) end
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
            self:kill()
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
    self.bot:pickup(self.grid_obj, self.grid_r, self.grid_c)
end

function Room:drop()
    self.bot:drop(self.grid_obj, self.grid_r, self.grid_c)
end

function Room:blocked()
    return self.bot:blocked(self.grid_obj, self.grid_r, self.grid_c)
end

function Room:next_block()
    return self.bot:next_block(self.grid_obj, self.grid_r, self.grid_c)
end

--UTILITY FUNCTIONS--

function room.create()
    local r

    r = Room()
    r:addElement(DRAW_TABLE.L1, nil, "room")

    return r
end

return room
