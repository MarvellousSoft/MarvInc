local Color = require "classes.color.color"
require "classes.primitive"

Memory = Class{
    __includes =  {RECT},
    init = function(self, x, y, w, h, slots)
        RECT.init(self, x, y, w, h)
        self.tp = "memory"
        self:setId("memory")

        self.unavailable_font = FONTS.fira(50)
        self.time_since_move = 0

        self:setSlots(slots)
    end
}

function Memory:setSlots(slots)
    self.slots = slots
    -- Decide draw
    local best_r = 1
    local best_ssize = math.min(self.h, self.w / self.slots)
    for i = 2, 7 do
        local columns = math.ceil(slots / i)
        local cs = math.min(self.h / i, self.w / columns)
        if cs > best_ssize then
            best_r = i
            best_ssize = cs
        end
    end
    -- slot size
    self.ssize = best_ssize
    self.rows = best_r
    self.columns = math.ceil(slots / self.rows)

    self.index_font = FONTS.fira(self.ssize / 3)
    self.value_font = FONTS.fira(self.ssize * .4)

    -- actual memory
    self.vec = {}
    for i = 1, self.slots do self.vec[i] = 0 end
end

function Memory:reset()
    for i = 1, self.slots do self.vec[i] = 0 end
end

function Memory:get(pos)
    return type(pos) == 'number'and ((pos >= 0 and pos < self.slots) and self.vec[pos + 1] or ("Trying to access invalid register " .. pos)) or pos
end

function Memory:set(dst, src)
    if type(dst) == 'string' then return dst end
    if not dst or type(dst) ~= 'number' or dst < 0 or dst > self.slots then return "Trying to set register " .. (dst or 'nil') end
    self.vec[dst + 1] = src
end

function Memory:mouseMoved()
    self.time_since_move = 0
end

function Memory:update(dt)
    self.time_since_move = self.time_since_move + dt
end

function Memory:draw()
    local color = Color.white()

    if self.slots == 0 then
        Color.set(color)
        love.graphics.rectangle("line", self.pos.x, self.pos.y, self.w, self.h)
        Color.set(Color.red())
        love.graphics.setFont(self.unavailable_font)
        love.graphics.print("UNAVAILABLE", self.pos.x + self.w / 5, self.pos.y + self.h / 2, -math.pi / 20)
    else
        -- centering cells
        local dx = (self.w - self.columns * self.ssize) / 2
        love.graphics.translate(dx, 0)

        color.l = 230
        color.s = 140
        color.a = 255
        love.graphics.setFont(self.index_font)
        local collide_slot = -1
        for i = 1, self.slots do
            local r = math.ceil(i / self.columns) - 1
            local c = i - r * self.columns - 1

            color.a = 255
            Color.set(color)
            love.graphics.rectangle("line", self.pos.x + c * self.ssize, self.pos.y + r * self.ssize, self.ssize, self.ssize)

            -- Checking mouse colision, should probably be somewhere else.
            local mx, my = love.mouse.getPosition()
            if self.time_since_move > .1 and Util.pointInRect(mx, my, self.pos.x + c * self.ssize + dx, self.pos.y + r * self.ssize, self.ssize, self.ssize) then
                collide_slot = i
            end

            color.a = 100
            Color.set(color)
            love.graphics.print(i - 1, self.pos.x + 2 + c * self.ssize, self.pos.y + r * self.ssize)
        end

        color.a = 255
        Color.set(color)
        love.graphics.setFont(self.value_font)
        for i = 1, self.slots do
            local r = math.ceil(i / self.columns) - 1
            local c = i - r * self.columns - 1
            love.graphics.printf(self.vec[i], self.pos.x + 2 + c * self.ssize, self.pos.y + r * self.ssize + self.ssize / 4, self.ssize, "center")
        end

        -- Drawing zoomed in slot
        if collide_slot > 0 then
            local i, bsz = collide_slot, 70
            local r = math.ceil(i / self.columns) - 1
            local c = i - r * self.columns - 1
            local mx, my = love.mouse.getPosition()
            love.graphics.setColor(0, 0, 0, 160)
            love.graphics.rectangle('fill', mx - dx, my - bsz, bsz, bsz)
            Color.set(color)
            love.graphics.rectangle('line', mx - dx, my - bsz, bsz, bsz)

            local index_font = FONTS.fira(bsz / 3)
            local value_font = FONTS.fira(bsz * .4)

            love.graphics.setFont(index_font)
            color.a = 100
            Color.set(color)
            love.graphics.print(i - 1, mx - dx + 2 * bsz / self.ssize, my - bsz)
            love.graphics.setFont(value_font)
            love.graphics.printf(self.vec[i], mx - dx + 2 * bsz / self.ssize, my - bsz + bsz / 4, bsz, "center")
            color.a = 255
        end

        love.graphics.translate(-dx, 0)
    end
end
