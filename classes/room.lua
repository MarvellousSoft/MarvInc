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
        for i=1, self.grid_r do
            self.grid_floor[i] = {}
            self.grid_obj[i] = {}
            for j=1, self.grid_c do
                -- For readability
                self.grid_floor[i][j] = love.math.random(2) % 2 == 0 and "white_floor" or "black_floor"
                self.grid_obj[i][j] = nil
            end
        end
        -- Set global vars
        ROOM_CW, ROOM_CH = self.grid_cw, self.grid_ch
        ROOM_ROWS, ROOM_COLS = self.grid_r, self.grid_c


        -- Initial bot
        self.bot = Bot(self.grid_obj, math.floor(self.grid_c/2), math.floor(self.grid_c/2))

        -- Border
        self.border_clr = Color.new(132, 137, 59)

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

    end
}

function Room:draw()
    -- Border
    Color.set(self.border_clr)
    love.graphics.push()
    love.graphics.translate(self.pos.x, self.pos.y)
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

    -- Table background
    Color.set(self.color)
    love.graphics.rectangle("fill", 0, 0, self.grid_w, self.grid_h)

    -- Floor
    for i=1, self.grid_r do
        local _x = (i-1)*self.grid_cw
        for j=1, self.grid_c do
            local cell = self.grid_floor[i][j]
            if cell ~= nil then
                local img = TILES_IMG[cell]
                local _y = (j-1)*self.grid_ch
                local _sx, _sy = self.grid_cw/img:getWidth(), self.grid_ch/img:getHeight()
                Color.set(Color.white())
                love.graphics.draw(img, _x, _y, nil, _sx, _sy)
            end
        end
    end

    -- Grid lines
    Color.set(self.grid_clr)
    local _r, _c = self.grid_r - 1, self.grid_c - 1
    for i=1, _r do
        local _h = i*self.grid_ch
        love.graphics.line(0, _h, self.grid_w, _h)
    end
    for i=1, _c do
        local _w = i*self.grid_cw
        love.graphics.line(_w, 0, _w, self.grid_h)
    end

    -- Objects
    for i=1, self.grid_r do
          for j=1, self.grid_c do
              local obj = self.grid_obj[i][j]
              if obj ~= nil then
                  obj:draw()
              end
        end
    end

    -- Set origin to (0, 0)
    love.graphics.pop()
end

function Room:keyPressed(key)
    if key == "space" then
        self.bot:move(self.grid_obj, self.grid_r, self.grid_c)
    elseif key == "left" then
        self.bot:clock()
    elseif key == "right" then
        self.bot:anti()
    end
end

--UTILITY FUNCTIONS--

function room.create()
    local r

    r = Room()
    r:addElement(DRAW_TABLE.L1, nil, "room")

    return r
end

return room
