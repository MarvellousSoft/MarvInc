require "classes.primitive"
local Color = require "classes.color.color"

--[[ TEXT BOX -- How to use

First, create a textbox object, the arguments are the following, in order:
x position, y position, width, maximum number of chars per line, number of lines that will be printed to the screen, maximum number of lines of the text box, whether or not to show line numbers (works only with <100 lines), font for the text, a table where each accepted character is set to nil if it is not accepted or the character it should be translated to (usually itself), color of the background, color of the text, and color of the error lines (more on that later)

accepted_chars defaults to lower and uppercase characters only
The color arguments are optional and already have some pretty default values.

Then, when you want to "start" the textbox, call is :activate() function, it will initialize cursor blinking and stuff.
Analogously, call :deactivate() when you're done.

You need to call :update(dt) every frame to keep the cursor blinking, and you may call keyPressed, textInput, mousePressed and mouseScroll just as the love callbacks, to capture text and mouse select and stuff.

To draw the textbox, just call its :draw() function. It may receive an optional argument called bad_lines, a table with 'true' on the numbers of the lines that should be underlined with err_color. This is normally used to show wrong lines.

That is it. If you wanna change the number of lines, call :reset_lines(line_total), but this will erase everything. If you change the variable .show_line_num everything should keep working fine.

To access the text: There is an array called .lines that holds all lines.

Extra gambs: if you specify the field .exec_line to be a number, then the specified line will display an indicator next to it (used for showing the current line executing)
]]

TextBox = Class{
    __includes = {RECT},

    init = function(self, x, y, w, max_char, lines_on_screen, line_total, show_line_num, text_font, accepted_chars, color, text_color, err_color)

        -- Quantity of lines scrolled
        self.dy = 0

        -- Font stuff
        self.font = text_font or FONTS.fira(18)
        self.font_h = self.font:getHeight()
        self.font_w = self.font:getWidth("o") -- monospaced

        -- Lines stuff
        self.line_h = math.ceil(1.1 * self.font_h)
        self.max_char = max_char
        self.lines_on_screen = lines_on_screen
        self:reset_lines(line_total)
        self.show_line_num = show_line_num


        RECT.init(self, x, y, w, self.lines_on_screen * self.line_h, color or Color.new(0, 0, 10, 80))

        self.text_color = text_color or Color.green()
        self.err_color = err_color
        if not self.err_color then
            self.err_color = Color.red()
            self.err_color.a = 170
        end

        -- Cursor blink stuff
        self.cursor_mult = 1
        self.cursor_timer = Timer.new()

        -- Stencil function for scrolling
        self.stencil = function() love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.w, self.h) end

        -- Accepted chars
        self.accepted_chars = accepted_chars
        if not self.accepted_chars then
            self.accepted_chars = {}
            for i = 1, 26 do
                local c_lower, c_upper = string.char(97 + i - 1), string.char(65 + i - 1)
                self.accepted_chars[c_lower] = c_lower
                self.accepted_chars[c_upper] = c_upper
            end
        end

        self.tp = "text_editor"
    end
}

function TextBox:reset_lines(line_total)
    self.line_total = line_total -- maximum number of lines
    self.line_cur = 1 -- current number of lines
    self.lines = {}
    for i = 1, self.line_total do self.lines[i] = "" end

    -- Cursor stuff
    -- i - line number
    -- p - position in line -- may be one more than size of string
    self.cursor = {i = 1, p = 1}
    self.cursor2 = nil
end

-- call this before using the box
function TextBox:activate()
    self.hadKeyRepeat = love.keyboard.hasKeyRepeat()
    love.keyboard.setKeyRepeat(true)
    self.cursor_timer.after(1, function()
        self.cursor_timer.tween(.1, self, {cursor_mult = 0}, 'out-linear')
        self.cursor_timer.every(1.3, function() self.cursor_timer.tween(.1, self, {cursor_mult = 0}, 'out-linear') end)
    end)
    self.cursor_timer.every(1.3, function() self.cursor_timer.tween(.1, self, {cursor_mult = 1}, 'in-linear') end)
end

-- call this after using the box
function TextBox:deactivate()
    love.keyboard.setKeyRepeat(self.hadKeyRepeat)
    self.cursor_timer.clear()
end

function TextBox:update(dt)
    self.cursor_timer.update(dt)
end

function TextBox:draw(bad_lines)
    Color.set(self.color)
    -- background
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.w, self.h)

    -- Set stencil for the rectangle containing the code
    love.graphics.stencil(self.stencil, "replace", 1)
    -- Only allow rendering on pixels which have a stencil value greater than 0.
    love.graphics.setStencilTest("greater", 0)

    -- Draw lines
    love.graphics.setFont(self.font)
    love.graphics.setLineWidth(.2)
    local dx = (self.show_line_num and self.font:getWidth("20: ") or 0) + 5
    for i = 0, self.line_cur - 1 do
        Color.set(self.text_color)
        local line = self.show_line_num and string.format("%2d: %s", i + 1, self.lines[i + 1]) or self.lines[i + 1]
        love.graphics.print(line, self.pos.x + 3, self.pos.y - self.line_h * self.dy + i * self.line_h + (self.line_h - self.font_h) / 2)

        if bad_lines and bad_lines[i + 1] and self.cursor.i ~= i + 1 then
            Color.set(self.err_color)
            local y = self.pos.y - self.line_h * self.dy + (i + 0.9) * self.line_h
            love.graphics.line(self.pos.x + dx, y, self.pos.x + self.font:getWidth(line), y)
        end
    end

    local c = Color.new(self.text_color)
    c.l = c.l / 2
    -- Draw vertical line -- if drawing numbers
    if self.show_line_num then
        Color.set(c)
        -- line number + vertical line size
        love.graphics.setLineWidth(.5)
        love.graphics.line(self.pos.x + dx - self.font_w, self.pos.y, self.pos.x + dx - self.font_w, self.pos.y + self.h)
    end

    -- Draw cursor
    c.a = 150 * self.cursor_mult
    Color.set(c)
    local w = self.font_w
    local cu = self.cursor
    love.graphics.rectangle("fill", self.pos.x + dx - 2 + w * (cu.p - 1), self.pos.y - self.dy * self.line_h + (cu.i - 1) * self.line_h + (self.line_h - self.font_h) / 2, w, self.font_h)

    -- Drawing selection -- ugly code :(
    c.a = 80
    Color.set(c)
    local c1, c2 = self.cursor, self.cursor2 or self.cursor
    if c1.i > c2.i or (c1.i == c2.i and c1.p > c2.p) then
        c1, c2 = c2, c1
    end
    cu = {i = c1.i, p = c1.p}
    while cu.i ~= c2.i or cu.p ~= c2.p do
        love.graphics.rectangle("fill", self.pos.x + dx - 2 + w * (cu.p - 1), self.pos.y - self.dy * self.line_h + (cu.i - 1) * self.line_h + (self.line_h - self.font_h) / 2, w, self.font_h)
        cu.p = cu.p + 1
        if cu.p == #self.lines[cu.i] + 2 then
            cu.p = 1
            cu.i = cu.i + 1
        end
    end

    -- Drawing current line -- maybe remove this
    if self.exec_line then
        Color.set(Color.white())
        love.graphics.rectangle("fill", self.pos.x, self.pos.y - self.dy * self.line_h + (self.exec_line - 1) * self.line_h, 10, 10)
    end

    -- Remove stencil
    love.graphics.setStencilTest()
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
        for i = a.i + 1, self.line_total - rem do
            self.lines[i] = self.lines[i + rem]
        end
        for i = self.line_total - rem + 1, self.line_total do
            self.lines[i] = ""
        end

        self.cursor = a
        self.line_cur = self.line_cur - rem
    end
    self.cursor2 = nil
end

local change_cursor = {up = true, down = true, left = true, right = true, home = true, ["end"] = true}

function TextBox:keyPressed(key)
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
            for i = c.i, self.line_total - 1 do self.lines[i] = self.lines[i + 1] end
            self.lines[self.line_total] = ""
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
            for i = c.i + 1, self.line_total - 1 do
                self.lines[i] = self.lines[i + 1]
            end
            self.lines[self.line_total] = ""
        else
            self.lines[c.i] = processDelete(self.lines[c.i], c.p)
        end

    elseif c2 and (key == 'delete' or key == 'backspace') then
        deleteInterval(self, c, c2)

    elseif key == 'return' then
        if self.line_cur == self.line_total then return end
        self.line_cur = self.line_cur + 1
        for i = self.line_total, c.i + 2, -1 do
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
        else
            c.p = 1
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
        -- TODO: handle when there is a selection
        if #self.lines[c.i] + 2 > self.max_char then return end
        self.lines[c.i] = processAdd(self.lines[c.i], c.p, "  ")
        c.p = c.p + 2

    elseif key == 'space' then
        -- Necessary to work on browsers
        self:textInput(' ', true)

    end

    if self.cursor.i - 1 < self.dy then self.dy = self.cursor.i - 1 end
    if self.cursor.i - self.lines_on_screen > self.dy then self.dy = self.cursor.i - self.lines_on_screen end
end

function TextBox:textInput(t, isSpace)
    -- First, should check if it is valid
    local c = self.cursor
    t = self.accepted_chars[t]
    if not t or #t + #self.lines[c.i] > self.max_char or
       #t > 1 or (t == " " and not isSpace)
        then return end

    if self.cursor2 then deleteInterval(self, c, self.cursor2) end
    c = self.cursor
    self.lines[c.i] = processAdd(self.lines[c.i], c.p, t)
    c.p = c.p + 1
end

function TextBox:mousePressed(x, y, but)
    if but ~= 1 or not Util.pointInRect(x, y, self) then return end

    -- mouse click on editor
    y = y + self.dy * self.line_h
    local dx = (self.show_line_num and self.font:getWidth("20:") or 0) + 5
    if x < self.pos.x + dx - 2 then return end
    local w = self.font_w
    local i = math.floor((y - self.pos.y) / self.line_h) + 1
    local p = math.max(1, math.floor((x - self.pos.x - dx + 2) / w))
    if i <= 0 or p <= 0 then return end
    self.cursor.i = math.min(i, self.line_cur)
    self.cursor.p = math.min(p, #self.lines[self.cursor.i] + 1)
end

function TextBox:mouseScroll(x, y)
    local mx, my = love.mouse.getPosition()
    if Util.pointInRect(mx, my, self) then
        self.dy = self.dy - y
    end
    self.dy = math.min(self.dy, self.line_cur - 1)
    self.dy = math.max(self.dy, -self.lines_on_screen + 1)
end
