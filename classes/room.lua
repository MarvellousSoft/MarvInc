require "classes.primitive"
local Color = require "classes.color.color"
--ROOM CLASS--

--Room functions table
local room = {}

Room = Class{
    __includes = {RECT},
    init = function(self)
        local b = 20
        RECT.init(self, W - (H - b), b, H - 2 * b, H - 2 * b, Color.orange())

        self.tp = "room"

        -- Grid
        self.grid_r = 20
        self.grid_c = 20
        self.grid_w = self.w/self.grid_r
        self.grid_h = self.h/self.grid_c
        self.grid = {}
        for i=1, self.grid_r do
          self.grid[i] = {}
          for j=1, self.grid_c do
            self.grid[i][j] = 0
          end
        end

        -- Border
        self.border_w = 2
        self.border_clr = Color.black()
        self.border_stl = "smooth"
    end
}

function Room:draw()
    -- Background
    Color.set(self.color)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.w, self.h)

    -- Border
    Color.set(self.border_clr)
    local _def_w, _def_stl = love.graphics.getLineWidth(), love.graphics.getLineStyle()
    love.graphics.setLineWidth(self.border_w)
    love.graphics.setLineStyle(self.border_stl)
    love.graphics.rectangle("line", self.pos.x, self.pos.y, self.w, self.h)
    love.graphics.setLineWidth(_def_w)
    love.graphics.setLineStyle(_def_stl)

    -- Set origin to table position
    love.graphics.push()
    love.graphics.translate(self.pos.x, self.pos.y)

    Color.set(Color.blue())
    -- Grid lines
    local _r, _c = self.grid_r - 1, self.grid_c - 1
    for i=1, _r do
      local _h = i*self.grid_h
      love.graphics.line(0, _h, self.w, _h)
    end
    for i=1, _c do
      local _w = i*self.grid_w
      love.graphics.line(_w, 0, _w, self.h)
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
