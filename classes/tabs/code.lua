require "classes.primitive"
local Color = require "classes.color.color"
require "classes.tabs.tab"
-- CODE TAB CLASS--

CodeTab = Class{
    __includes = {Tab},

    init = function(self, eps, dy)
        Tab.init(self, eps, dy)


        self.color = Color.new(0, 0, 10)

        -- Font stuff
        self.font = FONTS.fira(15)
        self.font_h = self.font:getHeight()

        -- Lines stuff
        self.line_h = math.ceil(1.2 * self.font_h)
        self.max_char = 30 -- maximum number of chars in a line
        self.line_cur = 1 -- current number of lines
        self.line_number = 25 -- maximum number of lines
        self.h = self.line_number * self.line_h
        self.lines = {}
        for i = 1, self.line_number do self.lines[i] = "" end

        -- Cursor stuff
        -- i - line number
        -- p - position in line -- may be one more than size of string
        self.cursor = {i = 1, p = 1}

        self.tp = "code_tab"
    end
}

function CodeTab:activate()
    love.keyboard.setKeyRepeat(true)
end

function CodeTab:deactivate()
    love.keyboard.setKeyRepeat(false)
end

function CodeTab:draw()
    Color.set(self.color)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.w, self.h)

    -- Draw lines
    Color.set(Color.green())
    love.graphics.setFont(self.font)
    for i = 0, self.line_number - 1 do
        love.graphics.print(string.format("%2d: %s", i + 1, self.lines[i + 1]), self.pos.x + 3, self.pos.y + i * self.line_h + (self.line_h - self.font_h) / 2)
    end

    -- Draw vertical line
    local c = Color.green()
    c.l = c.l / 2
    Color.set(c)
    -- line number + vertical line size
    local dx = self.font:getWidth("20:") + 5
    love.graphics.setLineWidth(.5)
    love.graphics.line(self.pos.x + dx, self.pos.y, self.pos.x + dx, self.pos.y + self.h)

    -- Draw cursor
    c.a = 100
    Color.set(c)
    local w = self.font:getWidth("a")
    love.graphics.rectangle("fill", self.pos.x + dx + 7 + w * (self.cursor.p - 1), self.pos.y + (self.cursor.i - 1) * self.line_h + (self.line_h - self.font_h) / 2, w, self.font_h)
end

-- Delete the j-th character from string s (1-indexed)
local function processDelete(s, j)
    local pref = j == 1 and "" or s:sub(1, j - 1)
    local suf = j == #s and "" or s:sub(j + 1)
    return pref .. suf
end

-- Adds string c before the j-th character in s
local function processAdd(s, j, c)
    local pref = j == 1 and "" or s:sub(1, j - 1)
    local suf = s:sub(j)
    return pref .. c .. suf
end

function CodeTab:keyPressed(key)
    print(key)
    local c = self.cursor
    if key == 'backspace' then
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

    elseif key == 'delete' then
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
end

function CodeTab:textInput(t)
    print(">", t)
    -- First, should check if it is valid
    local c = self.cursor
    if #t + #self.lines[c.i] > self.max_char or
       #t > 1 or not t:match("[a-zA-Z0-9!?]")
        then return end
    t = t:lower()
    self.lines[c.i] = processAdd(self.lines[c.i], c.p, t)
    c.p = c.p + 1
end
