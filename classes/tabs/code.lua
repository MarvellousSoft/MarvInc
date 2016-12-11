require "classes.interpreter.memory"
require "classes.img_button"
require "classes.primitive"
local Color = require "classes.color.color"
require "classes.tabs.tab"
local Parser = require "classes.interpreter.parser"
-- CODE TAB CLASS--

CodeTab = Class{
    __includes = {Tab},

    init = function(self, eps, dy)
        Tab.init(self, eps, dy)

        --Original size of code tab
        self.original_h = self.h

        -- Quantity of lines scrolled
        self.dy = 0

        self.color = Color.new(0, 0, 10)

        -- Font stuff
        self.font = FONTS.fira(18)
        self.font_h = self.font:getHeight()

        -- Lines stuff
        self.line_h = math.ceil(1.1 * self.font_h)
        self.max_char = 30 -- maximum number of chars in a line
        self.line_cur = 1 -- current number of lines
        self.line_number = 35 -- maximum number of lines
        self.lines_on_screen = 20
        self.h = self.lines_on_screen * self.line_h -- height of the code box
        self.lines = {}
        for i = 1, self.line_number do self.lines[i] = "" end


        -- Cursor stuff
        -- i - line number
        -- p - position in line -- may be one more than size of string
        self.cursor = {i = 1, p = 1}
        self.cursor2 = nil

        self.cursor_mult = 1
        self.cursor_timer = Timer.new()

        -- Stencil function for scrolling
        self.stencil = function() love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.w, self.h) end

        -- Buttons
        local bsz = 50
        local by = self.pos.y + self.original_h - bsz
        local bx = self.pos.x + self.w / 4
        self.stop_b = ImgButton(bx, by, bsz, BUTS_IMG.stop, function() StepManager:stop() end)
        bx = bx + bsz + 20
        self.pause_b = ImgButton(bx, by, bsz, BUTS_IMG.pause, function() StepManager:pause() end)
        bx = bx + bsz + 20
        self.play_b = ImgButton(bx, by, bsz, BUTS_IMG.play, function() StepManager:play() end)
        bx = bx + bsz + 20
        self.fast_b = ImgButton(bx, by, bsz, BUTS_IMG.fast, function() StepManager:fast() end)
        self.buttons = {self.play_b, self.stop_b, self.pause_b, self.fast_b}

        -- Memory
        self.memory = Memory(self.pos.x, self.pos.y + self.h + 10, self.w, by - 10 - (self.pos.y + self.h + 10), 50)

        self.tp = "code_tab"
        self:setId "code_tab"
    end
}

function CodeTab:activate()
    love.keyboard.setKeyRepeat(true)
    self.cursor_timer.after(1, function()
        self.cursor_timer.tween(.1, self, {cursor_mult = 0}, 'out-linear')
        self.cursor_timer.every(1.3, function() self.cursor_timer.tween(.1, self, {cursor_mult = 0}, 'out-linear') end)
    end)
    self.cursor_timer.every(1.3, function() self.cursor_timer.tween(.1, self, {cursor_mult = 1}, 'in-linear') end)
end

function CodeTab:deactivate()
    love.keyboard.setKeyRepeat(false)
    self.cursor_timer.clear()
end

function CodeTab:update(dt)
    self.cursor_timer.update(dt)
end

function CodeTab:draw()
    Color.set(self.color)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.w, self.h)

    -- Set stencil for the rectangle containing the code
    love.graphics.stencil(self.stencil, "replace", 1)
    -- Only allow rendering on pixels which have a stencil value greater than 0.
    love.graphics.setStencilTest("greater", 0)

    -- Draw lines
    love.graphics.setFont(self.font)
    love.graphics.setLineWidth(.1)
    local dx = self.font:getWidth("20:") + 5
    for i = 0, self.line_number - 1 do
        Color.set(Color.green())
        love.graphics.print(string.format("%2d: %s", i + 1, self.lines[i + 1]), self.pos.x + 3, self.pos.y - self.line_h * self.dy + i * self.line_h + (self.line_h - self.font_h) / 2)
        if self.bad_lines and self.bad_lines[i + 1] and self.cursor.i ~= i + 1 then
            local c = Color.red()
            c.a = 100
            Color.set(c)
            local y = self.pos.y - self.line_h * self.dy + (i + 0.9) * self.line_h
            love.graphics.line(self.pos.x + dx + self.font:getWidth("o"), y, self.pos.x + self.font:getWidth("00: " .. self.lines[i + 1]), y)
        end
    end

    -- Draw vertical line
    local c = Color.green()
    c.l = c.l / 2
    Color.set(c)
    -- line number + vertical line size
    love.graphics.setLineWidth(.5)
    love.graphics.line(self.pos.x + dx, self.pos.y, self.pos.x + dx, self.pos.y + self.h)

    -- Draw cursor
    c.a = 150 * self.cursor_mult
    --print(self.cursor_mult)
    Color.set(c)
    local w = self.font:getWidth("a")
    local cu = self.cursor
    love.graphics.rectangle("fill", self.pos.x + dx - 2 + w * cu.p, self.pos.y - self.dy * self.line_h + (cu.i - 1) * self.line_h + (self.line_h - self.font_h) / 2, w, self.font_h)
    c.a = 80
    Color.set(c)
    local c1, c2 = self.cursor, self.cursor2 or self.cursor
    if c1.i > c2.i or (c1.i == c2.i and c1.p > c2.p) then
        c1, c2 = c2, c1
    end
    cu = {i = c1.i, p = c1.p}
    while cu.i ~= c2.i or cu.p ~= c2.p do
        love.graphics.rectangle("fill", self.pos.x + dx - 2 + w * cu.p, self.pos.y - self.dy * self.line_h + (cu.i - 1) * self.line_h + (self.line_h - self.font_h) / 2, w, self.font_h)
        cu.p = cu.p + 1
        if cu.p == #self.lines[cu.i] + 2 then
            cu.p = 1
            cu.i = cu.i + 1
        end
    end

    if self.exec_line then
        Color.set(Color.white())
        love.graphics.rectangle("fill", self.pos.x, self.pos.y - self.dy * self.line_h + (self.exec_line - 1) * self.line_h, 10, 10)
    end

    -- Remove stencil
    love.graphics.setStencilTest()

    -- Draw buttons
    for _, b in ipairs(self.buttons) do b:draw() end
    self.play_b:draw()

    -- Draw memory
    self.memory:draw()
end

-- Delete the substring s[l..r] from string s
local function processDelete(s, l, r)
    r = r or l
    local pref = l == 1 and "" or s:sub(1, l - 1)
    local suf = r == #s and "" or s:sub(r + 1)
    return pref .. suf
end

-- Adds string c before the j-th character in s
local function processAdd(s, j, c)
    local pref = j == 1 and "" or s:sub(1, j - 1)
    local suf = s:sub(j)
    return pref .. c .. suf
end

local function deleteInterval(self, c, c2)
    if c.i == c2.i then
        local mn = math.min(c.p, c2.p)
        self.lines[c.i] = processDelete(self.lines[c.i], mn, c.p + c2.p - mn - 1)
        c.p = mn
    else
        local a, b = c, c2
        if a.i > b.i then a, b = b, a end
        if a.p - 1 + #self.lines[b.i] - b.p + 1 > self.max_char then return end
        local pref = a.p == 1 and "" or self.lines[a.i]:sub(1, a.p - 1)
        local suf = b.p == #self.lines[b.i] + 1 and "" or self.lines[b.i]:sub(b.p)
        self.lines[a.i] = pref .. suf

        local rem = b.i - a.i
        for i = a.i + 1, self.line_number - rem do
            self.lines[i] = self.lines[i + rem]
        end
        for i = self.line_number - rem + 1, self.line_number do
            self.lines[i] = ""
        end

        self.cursor = a
        self.line_cur = self.line_cur - rem
    end
    self.cursor2 = nil
end

local change_cursor = {up = true, down = true, left = true, right = true, home = true, ["end"] = true}

function CodeTab:keyPressed(key)
    if self.lock then return end
    local c = self.cursor
    if change_cursor[key] then
        if love.keyboard.isDown("lshift", "rshift") then
            self.cursor2 = self.cursor2 or {i = c.i, p = c.p}
        else
            self.cursor2 = nil
        end
    end
    if key == 'escape' then self.cursor2 = nil end
    local c2 = self.cursor2
    if not c2 and key == 'backspace' then
        if c.p == 1 and c.i == 1 then return end
        if c.p == 1 then
            if #self.lines[c.i - 1] + #self.lines[c.i] > self.max_char then return end
            c.p = #self.lines[c.i - 1] + 1
            self.lines[c.i - 1] = self.lines[c.i - 1] .. self.lines[c.i]
            for i = c.i, self.line_number - 1 do self.lines[i] = self.lines[i + 1] end
            self.lines[self.line_number] = ""
            self.line_cur = self.line_cur - 1
            c.i = c.i - 1
        else
            c.p = c.p - 1
            self.lines[c.i] = processDelete(self.lines[c.i], c.p)
        end

    elseif not c2 and key == 'delete' then
        if c.p == #self.lines[c.i] + 1 and c.i == self.line_cur then return end
        if c.p == #self.lines[c.i] + 1 then
            if #self.lines[c.i] + #self.lines[c.i + 1] > self.max_char then return end
            self.line_cur = self.line_cur - 1
            self.lines[c.i] = self.lines[c.i]  .. self.lines[c.i + 1]
            for i = c.i + 1, self.line_number - 1 do
                self.lines[i] = self.lines[i + 1]
            end
            self.lines[self.line_number] = ""
        else
            self.lines[c.i] = processDelete(self.lines[c.i], c.p)
        end

    elseif c2 and (key == 'delete' or key == 'backspace') then
        deleteInterval(self, c, c2)

    elseif key == 'return' then
        if self.line_cur == self.line_number then return end
        self.line_cur = self.line_cur + 1
        for i = self.line_number, c.i + 2, -1 do
            self.lines[i] = self.lines[i - 1]
        end
        self.lines[c.i + 1] = c.p == #self.lines[c.i] + 1 and "" or self.lines[c.i]:sub(c.p)
        self.lines[c.i] = c.p == 1 and "" or self.lines[c.i]:sub(1, c.p - 1)
        c.p = 1
        c.i = c.i + 1
    elseif key == 'left' then
        if c.p > 1 then c.p = c.p - 1 end

    elseif key == 'right' then
        if c.p < #self.lines[c.i] + 1 then c.p = c.p + 1 end

    elseif key == 'up' then
        if c.i > 1 then
            c.i = c.i - 1
            if c.p > #self.lines[c.i] + 1 then
                c.p = #self.lines[c.i] + 1
            end
        end

    elseif key == 'down' then
        if c.i < self.line_cur then
            c.i = c.i + 1
            if c.p > #self.lines[c.i] + 1 then
                c.p = #self.lines[c.i] + 1
            end
        else
            c.p = #self.lines[c.i] + 1
        end

    elseif key == 'home' then
        c.p = 1

    elseif key == 'end' then
        c.p = #self.lines[c.i] + 1

    elseif key == 'tab' then
        if #self.lines[c.i] + 2 > self.max_char then return end
        self.lines[c.i] = processAdd(self.lines[c.i], c.p, "  ")
        c.p = c.p + 2

    end
    if self.cursor.i - 1 < self.dy then self.dy = self.cursor.i - 1 end
    if self.cursor.i - self.lines_on_screen > self.dy then self.dy = self.cursor.i - self.lines_on_screen end

    self:checkErrors()
end

function CodeTab:textInput(t)
    if self.lock then return end
    -- First, should check if it is valid
    local c = self.cursor
    if #t + #self.lines[c.i] > self.max_char or
       #t > 1 or not t:match("[a-zA-Z0-9: ]")
        then return end
    if self.cursor2 then deleteInterval(self, c, self.cursor2) end
    t = t:lower()
    self.lines[c.i] = processAdd(self.lines[c.i], c.p, t)
    c.p = c.p + 1
    self:checkErrors()
end

function CodeTab:mousePressed(x, y, but)
    for _, b in ipairs(self.buttons) do b:mousePressed(x, y, but) end

    if self.lock then return end
    if but ~= 1 or not Util.pointInRect(x, y, self) then return end

    -- mouse click on editor
    y = y + self.dy * self.line_h
    local dx = self.font:getWidth("20:") + 5
    if x < self.pos.x + dx - 2 then return end
    local w = self.font:getWidth("a")
    local i = math.floor((y - self.pos.y) / self.line_h) + 1
    local p = math.max(1, math.floor((x - self.pos.x - dx + 2) / w))
    if i <= 0 or p <= 0 then return end
    self.cursor.i = math.min(i, self.line_cur)
    self.cursor.p = math.min(p, #self.lines[self.cursor.i] + 1)
    self:checkErrors()
end

function CodeTab:mouseScroll(x, y)
    local mx, my = love.mouse.getPosition()
    if Util.pointInRect(mx, my, self) then
        self.dy = self.dy - y
    end
    self.dy = math.min(self.dy, self.line_cur - 1)
    self.dy = math.max(self.dy, -self.lines_on_screen + 1)
end

-- Check invalid lines
function CodeTab:checkErrors()
    local c = Parser.parseAll(self.lines)
    if type(c) == 'table' and c.type ~= 'code' then
        self.bad_lines = c
    else
        self.bad_lines = nil
    end
end
