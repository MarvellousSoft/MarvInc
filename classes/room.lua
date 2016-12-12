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
        self.mode = "online"

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

        -- Initial bot
        Signal.register("death", function()
            self.bot = Bot(self.grid_obj, INIT_POS.x, INIT_POS.y)
            if self.default_bot_turn then
                self.bot:turn(self.default_bot_turn)
            end
        end)

        -- Border
        self.border_clr = Color.new(132, 20, 30)

        -- Live marker
        self.mrkr_fnt = FONTS.fira(28)
        self.mrkr_clr = Color.red()
        -- Relative to pos
        self.mrkr_x = self.w - self.grid_cw - self.mrkr_fnt:getWidth("LIVE")
        self.mrkr_y = 0
        self.mrkr_drw = true
        self.mrkr_timer = MAIN_TIMER.every(1, function()
            self.mrkr_drw = not self.mrkr_drw
        end)

        -- Room number and name
        self.n = nil
        self.name = nil

        -- Room objectives
        self.objs = nil

        Signal.register("end_turn", function()
            self:apply()
        end)

        self:from(Reader("puzzles/test.lua"):get())

        ROOM = self
    end
}

function Room:from(puzzle)
    self:clear()
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

    Util.findId("code_tab"):reset(puzzle)
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
    self.objs = {}
    Room.queue = {}
    StepManager:stopNoKill()
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
        love.graphics.print("OFFLINE", self.mrkr_x, self.mrkr_y)
    end
    love.graphics.pop()

    -- Set origin to table position
    love.graphics.push()
    love.graphics.translate(self.grid_x, self.grid_y)

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

    -- Set origin to (0, 0)
    love.graphics.pop()

    --Draw camera screen
    Color.set(Color.white())
    love.graphics.draw(ROOM_CAMERA_IMG, self.pos.x- 45, self.pos.y - 45)
end

function Room:update()
    for _, v in pairs(self.grid_obj) do
        if v.death and v.destroy then
            v.destroy()
        end
    end
end

function Room:kill()
    self.bot:kill(self.grid_obj)
end

function Room:walk(dir)
    if dir then self:turn(dir) end
    self.bot:move(self.grid_obj, self.grid_r, self.grid_c)
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

function Room:blocked()
    return self.bot:blocked(self.grid_obj, self.grid_r, self.grid_c)
end

--UTILITY FUNCTIONS--

function room.create()
    local r

    r = Room()
    r:addElement(DRAW_TABLE.L1, nil, "room")

    return r
end

return room
