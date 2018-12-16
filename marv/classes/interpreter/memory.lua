--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local Color = require "classes.color.color"
require "classes.primitive"

local TextBos = require "classes.text_box"

Memory = Class{
    __includes =  {RECT},
    init = function(self, x, y, w, h, slots)
        RECT.init(self, x, y, w, h)
        self.tp = "memory"
        self:setId("memory")

        self.unavailable_font = FONTS.fira(50)
        self.time_since_move = 0

        self.collide_slot = -1
        -- all update functions are automatically called from code_tab
        self.tbox = TextBox(0, 0, 0, 7, 1, 1, false, FONTS.fira(13))

        -- renaming of registers
        self.str_to_num = nil
        self.num_to_str = nil

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
    self.rename_font = FONTS.fira(self.ssize * .2)

    -- actual memory
    self.vec = {}
    self.used = {}
    for i = 1, self.slots do
        self.vec[i] = 0
        self.used[i] = false
    end

    self.str_to_num = Util.findId('code_tab').renames
    self.num_to_str = Util.findId('code_tab').inv_renames
end

function Memory:reset()
    for i = 1, self.slots do
        self.vec[i] = 0
        self.used[i] = false
    end
end

function Memory:get(pos)
    if type(pos) ~= 'number' then return pos end
    if pos < 0 or pos >= self.slots then return "Trying to access invalid register " .. pos end
    self.used[pos + 1] = true
    return self.vec[pos + 1]
end

function Memory:countUsed()
    local count = 0
    for i = 1, self.slots do
        count = count + (self.used[i] and 1 or 0)
    end
    return count
end

function Memory:set(dst, src)
    if type(dst) == 'string' then return dst end
    if not dst or type(dst) ~= 'number' or dst < 0 or dst > self.slots then return "Trying to set register " .. (dst or 'nil') end
    self.used[dst + 1] = true
    self.vec[dst + 1] = src
end

function Memory:mouseMoved()
    self.time_since_move = 0
    if self.collide_slot ~= -1 then
        self.collide_slot = -1
        self.wrong_rename = false
        self.tbox:deactivate()
    end
end

function Memory:update(dt)
    if self.collide_slot ~= -1 then
        self.tbox:update(dt)
    end
    if self.time_since_move < .1 and self.time_since_move + dt >= .1 then
        -- Inefficient mouse collision check
        local mx, my = love.mouse.getPosition()
        local dx = (self.w - self.columns * self.ssize) / 2
        for i = 1, self.slots do
            local r = math.ceil(i / self.columns) - 1
            local c = i - r * self.columns - 1
            if Util.pointInRect(mx, my, self.pos.x + c * self.ssize + dx, self.pos.y + r * self.ssize, self.ssize, self.ssize) then
                self.collide_slot = i
                break
            end
        end
        if self.collide_slot == -1 then return end
        self.tbox:reset_lines(1)
        self.tbox:activate()
        self.tbox.lines[1] = self.num_to_str[self.collide_slot - 1] or ""
        self.prev_txt = self.tbox.lines[1]
        self.tbox.cursor.p = self.prev_txt:len() + 1
    end
    self.time_since_move = self.time_since_move + dt
end

function Memory:update_renames()
    local t = self.tbox.lines[1]
    self.wrong_rename = false
    if t == self.prev_txt then return end
    if self.str_to_num[t] then
        self.wrong_rename = true
        return
    end
    if self.prev_txt:len() > 0 then
        self.num_to_str[self.str_to_num[self.prev_txt]] = nil
        self.str_to_num[self.prev_txt] = nil
    end
    if t:len() > 0 then
        self.str_to_num[t] = self.collide_slot - 1
        self.num_to_str[self.collide_slot - 1] = t
    end
    self.prev_txt = t
end

function Memory:draw()
    local color = Color.white()

    if self.slots == 0 then
        Color.set(color)
        love.graphics.setLineWidth(.5)
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
        for i = 1, self.slots do
            local r = math.ceil(i / self.columns) - 1
            local c = i - r * self.columns - 1

            color.a = 255
            Color.set(color)
            love.graphics.rectangle("line", self.pos.x + c * self.ssize, self.pos.y + r * self.ssize, self.ssize, self.ssize)

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
            if self.num_to_str[i - 1] then
                love.graphics.setFont(self.rename_font)
                love.graphics.printf(self.num_to_str[i - 1], self.pos.x + 2 + c * self.ssize, self.pos.y + r * self.ssize + self.ssize * .75, self.ssize, "center")
                love.graphics.setFont(self.value_font)
            end
        end

        -- Drawing zoomed in slot
        if self.collide_slot > 0 then
            local ddx = dx
            local i, bsz = self.collide_slot, math.max(90, self.ssize)
            local r = math.ceil(i / self.columns) - 1
            local c = i - r * self.columns - 1
            local mx, my = love.mouse.getPosition()

            if mx - dx + bsz >= Util.findId('code_tab').w + Util.findId('code_tab').pos.x then ddx = ddx + bsz end

            love.graphics.setColor(0, 0, 0, 160)
            love.graphics.rectangle('fill', mx - ddx, my - bsz, bsz, bsz)
            Color.set(color)
            love.graphics.rectangle('line', mx - ddx, my - bsz, bsz, bsz)

            local index_font = FONTS.fira(bsz / 3)
            local value_font = FONTS.fira(bsz * .4)

            love.graphics.setFont(index_font)
            color.a = 100
            Color.set(color)
            love.graphics.print(i - 1, mx - ddx + 2 * bsz / self.ssize, my - bsz)
            love.graphics.setFont(value_font)
            love.graphics.printf(self.vec[i], mx - ddx + 2 * bsz / self.ssize, my - bsz + bsz / 4, bsz, "center")
            color.a = 255

            if ROOM.version >= "1.0" then
                self.tbox.w = bsz * .8
                self.tbox.pos.x, self.tbox.pos.y = mx - ddx + bsz * .1, my - self.tbox.h - bsz * .05
                self.tbox:draw()

                if self.wrong_rename then
                    love.graphics.setLineWidth(.5)
                    Color.set(Color.red())
                    love.graphics.line(mx - ddx + bsz * .1, my - bsz * .05, mx - ddx + bsz * .9, my - bsz * .05)
                end
            end
        end

        love.graphics.translate(-dx, 0)
    end
end
