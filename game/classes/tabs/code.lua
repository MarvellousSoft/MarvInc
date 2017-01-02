require "classes.interpreter.memory"
require "classes.img_button"
require "classes.primitive"
local Color = require "classes.color.color"
require "classes.tabs.tab"
local Parser = require "classes.interpreter.parser"
require "classes.text_box"
-- CODE TAB CLASS--

CodeTab = Class{
    __includes = {Tab},

    init = function(self, eps, dy)
        Tab.init(self, eps, dy)

        -- chars accepted in terminal
        local acc = {}
        for i = 1, 26 do
            local c_lower, c_upper = string.char(97 + i - 1), string.char(65 + i - 1)
            acc[c_lower] = c_lower
            acc[c_upper] = c_lower
        end
        local other = "+-: []0123456789#"
        for c in other:gmatch(".") do
            acc[c] = c
        end

        self.term = TextBox(self.pos.x, self.pos.y, self.w, 30, 20, 30, true, FONTS.fira(18), acc)

        -- Buttons
        local bsz = 50
        local by = self.pos.y + self.h - bsz
        local bx = self.pos.x + self.w / 10
        local hf = function(self) return StepManager.state == self.highlight_state and (not self.how_fast or self.how_fast == StepManager.how_fast)  end
        self.stop_b = ImgButton(bx, by, bsz, BUTS_IMG.stop, function() StepManager.stop() end)
        self.stop_b.highlight, self.stop_b.highlight_state = hf, 'stopped'

        bx = bx + bsz + 20
        self.pause_b = ImgButton(bx, by, bsz, BUTS_IMG.pause, function() StepManager.pause() end)
        self.pause_b.highlight, self.pause_b.highlight_state = hf, 'paused'

        bx = bx + bsz + 20
        self.play_b = ImgButton(bx, by, bsz, BUTS_IMG.play, function() StepManager.play() end)
        self.play_b.highlight, self.play_b.highlight_state, self.play_b.how_fast = hf, 'playing', 1

        bx = bx + bsz + 20
        self.step_b = ImgButton(bx, by, bsz, BUTS_IMG.step, function() StepManager.step() end)

        bx = bx + bsz + 20
        self.fast_b = ImgButton(bx, by, bsz, BUTS_IMG.fast, function() StepManager.fast() end)
        self.fast_b.highlight, self.fast_b.highlight_state, self.fast_b.how_fast = hf, 'playing', 2

        bx = bx + bsz + 20
        self.superfast_b = ImgButton(bx, by, bsz, BUTS_IMG.superfast, function() StepManager.superfast() end)
        self.superfast_b.highlight, self.superfast_b.highlight_state, self.superfast_b.how_fast = hf, 'playing', 3

        self.buttons = {self.stop_b, self.pause_b, self.play_b, self.step_b, self.fast_b, self.superfast_b}

        -- Inventory slot
        self.inv_slot = nil
        self.inv_x = bx + bsz + 40
        self.inv_y = by
        self.inv_w = 50
        self.inv_h = 50
        self.inv_fnt = FONTS.fira(14)
        self.inv_clr = Color.white()
        self.inv_txt = "INVENTORY"
        self.inv_txt_w = self.inv_fnt:getWidth(self.inv_txt)
        self.inv_txt_h = self.inv_fnt:getHeight()

        -- Memory
        self.memory = Memory(self.pos.x, self.pos.y + self.term.h + 10, self.w, by - 10 - (self.pos.y + self.term.h + 10), 12)

        self.tp = "code_tab"
        self:setId "code_tab"
    end
}

function CodeTab:activate()
    self.term:activate()
end

function CodeTab:deactivate()
    self.term:deactivate()
end

function CodeTab:update(dt)
    self.term:update(dt)
end

function CodeTab:draw()
    if self.err_msg and self.err_line ~= self.term.cursor.i then
        love.graphics.setColor(100, 0, 0)
        love.graphics.setFont(FONTS.fira(13))
        love.graphics.print("Line " .. self.err_line .. ": " .. self.err_msg, self.term.pos.x, self.term.pos.y - FONTS.fira(13):getHeight())
    end
    self.term:draw(self.bad_lines)

    -- Draw buttons
    for _, b in ipairs(self.buttons) do b:draw() end

    love.graphics.rectangle("line", self.inv_x, self.inv_y, self.inv_w, self.inv_h)
    love.graphics.setFont(self.inv_fnt)
    love.graphics.print(self.inv_txt, self.inv_x + self.inv_w/2 - self.inv_txt_w/2,
        self.inv_y + self.inv_h)
    if ROOM.bot and ROOM.bot.inv then
        local _img = ROOM.bot.inv.img
        local _sx, _sy = self.inv_w/_img:getWidth(), self.inv_h/_img:getHeight()
        love.graphics.draw(_img, self.inv_x, self.inv_y, nil, _sx, _sy)
    end

    -- Draw memory
    self.memory:draw()
end

function CodeTab:keyPressed(key)
    if self.lock then
        if key == 'space' then
            if StepManager.running then
                StepManager.pause()
            else StepManager.play() end
        elseif key == 'escape' then
            StepManager.stop()
        end
        return
    end
    if key == 'return' then
        if love.keyboard.isDown("lctrl", "rctrl") then
            if StepManager.running then
                StepManager.pause()
            else
                StepManager.play()
            end
            return
        end
    end
    self.term:keyPressed(key)

    self:checkErrors()
end

function CodeTab:textInput(t)
    if t == '>' then
        StepManager.increase()
        return
    elseif t == '<' then
        StepManager.decrease()
        return
    end

    if self.lock then return end
    self.term:textInput(t)
    self:checkErrors()
end

function CodeTab:mousePressed(x, y, but)
    for _, b in ipairs(self.buttons) do b:mousePressed(x, y, but) end

    if self.lock then return end
    self.term:mousePressed(x, y, but)
    self:checkErrors()
end

function CodeTab:mouseScroll(x, y)
    self.term:mouseScroll(x, y)
end

function CodeTab:mouseReleased(x, y, but)
    self.term:mouseReleased(x, y, but)
end

-- Check invalid lines
function CodeTab:checkErrors()
    local c, err_l, err_m = Parser.parseAll(self.term.lines)
    if err_l or not c then
        self.bad_lines = c
        self.err_line = err_l
        self.err_msg = err_m
    else
        self.bad_lines = nil
        self.err_line = nil
        self.err_msg = nil
    end
end

-- Resets screen for a new puzzle
function CodeTab:reset(puzzle)
    self.term:reset_lines(puzzle.lines_on_terminal)
    self.term:typeString(puzzle.code)
    self.memory:setSlots(puzzle.memory_slots)
end

function CodeTab:getLines()
    local l = {}
    for i = 1, self.term.line_cur do
        l[i] = self.term.lines[i]
    end
    return l
end

function CodeTab:showLine(i)
    self.term.exec_line = i
end
