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

        self.term = TextBox(self.pos.x, self.pos.y, self.w, 30, 20, 30, true)

        -- Buttons
        local bsz = 50
        local by = self.pos.y + self.h - bsz
        local bx = self.pos.x + self.w / 5
        self.stop_b = ImgButton(bx, by, bsz, BUTS_IMG.stop, function() StepManager:stop() end)
        bx = bx + bsz + 20
        self.pause_b = ImgButton(bx, by, bsz, BUTS_IMG.pause, function() StepManager:pause() end)
        bx = bx + bsz + 20
        self.play_b = ImgButton(bx, by, bsz, BUTS_IMG.play, function() StepManager:play() end)
        bx = bx + bsz + 20
        self.fast_b = ImgButton(bx, by, bsz, BUTS_IMG.fast, function() StepManager:fast() end)
        bx = bx + bsz + 20
        self.superfast_b = ImgButton(bx, by, bsz, BUTS_IMG.superfast, function() StepManager:superfast() end)
        self.buttons = {self.play_b, self.stop_b, self.pause_b, self.fast_b, self.superfast_b}

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
    if key == 'c' then self.term.show_line_num = not self.term.show_line_num end
    if self.lock then
        if key == 'space' then
            if StepManager.running then
                StepManager:pause()
            else StepManager:play() end
        elseif key == 'escape' then
            StepManager:stop()
        end
        return
    end
    if key == 'return' then
        if love.keyboard.isDown("lctrl", "rctrl") then
            if StepManager.running then
                StepManager:pause()
            else
                StepManager:play()
            end
            return
        end
    end
    self.term:keyPressed(key)

    self:checkErrors()
end

function CodeTab:textInput(t)
    if t == '>' then
        StepManager:increase()
        return
    elseif t == '<' then
        StepManager:decrease()
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

-- Check invalid lines
function CodeTab:checkErrors()
    local c = Parser.parseAll(self.term.lines)
    if type(c) == 'table' and c.type ~= 'code' then
        self.bad_lines = c
    else
        self.bad_lines = nil
    end
end

-- Resets screen for a new puzzle
function CodeTab:reset(puzzle)
    self.term:reset_lines(puzzle.lines_on_terminal)
    self.memory:setSlots(puzzle.memory_slots)
end

function CodeTab:getLines()
    return self.term.lines
end

function CodeTab:showLine(i)
    self.term.exec_line = i
end


-- Gambs
local bak
-- Store code data
function CodeTab:store()
    bak = {self.term.lines, self.term.line_cur, self.term.cursor, self.term.cursor2}
end

-- Retrieve code data
function CodeTab:retrieve()
    self.term.lines, self.term.line_cur, self.term.cursor, self.term.cursor2 = unpack(bak)
end
