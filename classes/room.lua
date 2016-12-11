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

        -- Grid
        self.grid_clr = Color.blue()
        self.grid_r, self.grid_c = 20, 20
        self.grid_cw = self.w/self.grid_r -- Cell width
        self.grid_ch = self.h/self.grid_c -- Cell height
        self.grid_w = self.w - 2*self.grid_cw
        self.grid_h = self.h - 2*self.grid_ch
        self.grid_x, self.grid_y = self.pos.x + self.grid_cw, self.pos.y + self.grid_ch
        self.grid_r, self.grid_c = self.grid_r - 2, self.grid_c - 2
        self.grid_floor = {}
        self.grid_obj = {}

        -- Set global vars
        ROOM_CW, ROOM_CH = self.grid_cw, self.grid_ch
        ROOM_ROWS, ROOM_COLS = self.grid_r, self.grid_c
        INIT_POS = Vector(10, 10)

        for i=1, self.grid_r do
            self.grid_floor[i] = {}
            self.grid_obj[i] = {}
            for j=1, self.grid_c do
                -- For readability
                self.grid_floor[i][j] = "white_floor"
                self.grid_obj[i][j] = love.math.random() < 1/10. and
                    Obstacle(self.grid_obj, i, j, "wall_o", false) or nil
            end
        end

        -- Initial bot
        self.bot = Bot(self.grid_obj, INIT_POS.x, INIT_POS.y)
        Signal.register("death", function()
            self.bot = Bot(self.grid_obj, INIT_POS.x, INIT_POS.y)
        end)
        -- Death obj
        Dead(self.grid_obj, 12, 10, "black_block", false)

        -- Border
        self.border_clr = Color.new(132, 20, 30)

        -- Live marker
        self.mrkr_txt = "LIVE"
        self.mrkr_online = true
        self.mrkr_fnt = FONTS.fira(28)
        self.mrkr_clr = Color.red()
        -- Relative to pos
        self.mrkr_x = self.w - self.grid_cw - self.mrkr_fnt:getWidth(self.mrkr_txt)
        self.mrkr_y = 0
        self.mrkr_timer = MAIN_TIMER.every(1, function()
            self.mrkr_drw = not self.mrkr_drw
        end)
        self.mrkr_drw = true

        -- Room number and name
        self.n = 1
        self.name = "Minesweeper"

        ROOM = self
    end
}

function Room:draw()

    -- Border
    love.graphics.push()
    love.graphics.translate(self.pos.x, self.pos.y)
    Color.set(self.border_clr)
    love.graphics.rectangle('fill', 0, 0, self.w, self.h)

    -- Live marker
    love.graphics.setFont(FONTS.fira(28))
    Color.set(self.mrkr_clr)
    love.graphics.print(self.mrkr_txt, self.mrkr_x, self.mrkr_y)
    if self.mrkr_drw then
        love.graphics.circle("fill", self.mrkr_x - 25, self.mrkr_y + 17, 10)
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

    -- Grid lines
    --Color.set(self.grid_clr)
    --local _r, _c = self.grid_r - 1, self.grid_c - 1
    --for i=1, _r do
        --local _h = i*self.grid_ch
        --love.graphics.line(0, _h, self.grid_w, _h)
    --end
    --for i=1, _c do
        --local _w = i*self.grid_cw
        --love.graphics.line(_w, 0, _w, self.grid_h)
    --end

    -- Set origin to (0, 0)
    love.graphics.pop()

    --Draw camera screen
    Color.set(Color.white())
    love.graphics.draw(ROOM_CAMERA_IMG, self.pos.x- 45, self.pos.y - 45)
end

function Room:kill()
    self.bot:kill(self.grid_obj)
end

function Room:walk()
    self.bot:move(self.grid_obj, self.grid_r, self.grid_c)
end

function Room:clock()
    self.bot:clock()
end

function Room:anti()
    self.bot:anti()
end

function Room:turn(o)
    self.bot:turn(o)
end

function Room:blocked()
    return self.bot:blocked(self.grid_obj)
end

--UTILITY FUNCTIONS--

function room.create()
    local r

    r = Room()
    r:addElement(DRAW_TABLE.L1, nil, "room")

    return r
end

return room
