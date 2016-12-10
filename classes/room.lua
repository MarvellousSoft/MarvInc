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
            self.grid_floor[i][j] = 0
            self.grid_obj[i][j] = nil -- For readability
          end
        end

        -- Border
        self.border_clr = Color.green()
    end
}

function Room:draw()
    -- Border
    Color.set(self.border_clr)
    love.graphics.push()
    love.graphics.translate(self.pos.x, self.pos.y)
    love.graphics.rectangle('fill', 0, 0, self.w, self.h)
    love.graphics.pop()

    -- Set origin to table position
    love.graphics.push()
    love.graphics.translate(self.grid_x, self.grid_y)

    -- Table background
    Color.set(self.color)
    love.graphics.rectangle("fill", 0, 0, self.grid_w, self.grid_h)

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

    -- Set origin to (0, 0)
    love.graphics.pop()
end


--UTILITY FUNCTIONS--

function room.create()
    local r

    r = Room()
    r:addElement(DRAW_TABLE.L1, nil, "room")

    return r
end

return room
