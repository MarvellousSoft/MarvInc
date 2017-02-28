require "classes.primitive"
local Color = require "classes.color.color"

--[[ TEXT BOX -- How to use

First, create a textbox object, the arguments are the following, in order:
x position, y position, width, maximum number of chars per line, number of lines that will be printed to the screen, maximum number of lines of the text box, whether or not to show line numbers (works only with <100 lines), font for the text, a table where each accepted character is set to nil if it is not accepted or the character it should be translated to (usually itself), color of the background, color of the text, and color of the error lines (more on that later)

accepted_chars defaults to lower and uppercase characters only
The color arguments are optional and already have some pretty default values.

Then, when you want to "start" the textbox, call is :activate() function, it will initialize cursor blinking and stuff.
Analogously, call :deactivate() when you're done.

You need to call :update(dt) every frame to keep the cursor blinking, and deal with mouse selection, and you may call keyPressed, textInput, mousePressed and mouseScroll just as the love callbacks, to capture text and mouse select and stuff.

To draw the textbox, just call its :draw() function. It may receive an optional argument called bad_lines, a table with 'true' on the numbers of the lines that should be underlined with err_color. This is normally used to show wrong lines.

That is it. If you wanna change the number of lines, call :reset_lines(line_total), but this will erase everything.
If you change the variable .show_line_num everything should keep working fine (no need to reset text).

To access the text: There is an array called .lines that holds all lines.

Extra gambs: if you specify the field .exec_line to be a number, then the specified line will display an indicator next to it (used for showing the current line executing)
]]

--size of the maximum undo history
local max_history = 500

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

        -- text copied, used for ctrl-x, ctrl-c, and ctrl-v
        self.clipboard = nil

        self.tp = "text_editor"
    end
}

function TextBox:reset_lines(line_total)
    self.line_total = line_total -- maximum number of lines
    self.line_cur = 1 -- current number of lines
    self.lines = {}
    for i = 1, self.line_total do self.lines[i] = "" end

    --[[Cursor stuff
       i - line number
       p - position in line -- may be one more than size of string
       If there are two cursors, the selection is always from the 'smallest'
       one to the biggest one, EXCLUSIVE.
    ]]
    self.cursor = {i = 1, p = 1}
    self.cursor2 = nil

    -- used for ctrl-z, ctrl-y
    self.backups = {first = 0, last = -1, cur = -1}
    self:pushBackup()
end

-- adds backup to backup list
function TextBox:pushBackup(bak)
    bak = bak or self:getBackup()
    local b = self.backups
    for i = b.cur + 1, b.last, 1 do
        b[i] = nil
    end
    b.cur = b.cur + 1
    b.last = b.cur
    b[b.cur] = bak
    while b.last - b.first + 1 > max_history do
        b[b.first] = nil
        b.first = b.first + 1
    end
end

-- undoes last action, returns whether successful
function TextBox:undo()
    local b = self.backups
    if b.cur <= b.first then
        return false
    else
        b.cur = b.cur - 1
        self:recoverBackup(b[b.cur])
        return true
    end
end

-- redoes last undone action, returns whether sucessful
function TextBox:redo()
    local b = self.backups
    if b.cur == b.last then
        return false
    else
        b.cur = b.cur + 1
        self:recoverBackup(b[b.cur])
        return true
    end
end

-- call this before using the box
function TextBox:activate()
    self.hadKeyRepeat = love.keyboard.hasKeyRepeat()
    love.keyboard.setKeyRepeat(true)
    self.cursor_timer:after(1, function()
        self.cursor_timer:tween(.1, self, {cursor_mult = 0}, 'out-linear')
        self.cursor_timer:every(1.3, function() self.cursor_timer:tween(.1, self, {cursor_mult = 0}, 'out-linear') end)
    end)
    self.cursor_timer:every(1.3, function() self.cursor_timer:tween(.1, self, {cursor_mult = 1}, 'in-linear') end)
end

-- call this after using the box
function TextBox:deactivate()
    love.keyboard.setKeyRepeat(self.hadKeyRepeat)
    self.cursor_timer:clear()
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

-- deletes from cursor c to c2
-- may leave text invalid, please check
local function deleteInterval(self, c, c2)
    if c.i == c2.i then
        local mn = math.min(c.p, c2.p)
        self.lines[c.i] = processDelete(self.lines[c.i], mn, c.p + c2.p - mn - 1)
        c.p = mn
    else
        local a, b = c, c2
        if a.i > b.i then a, b = b, a end
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
    return true
end

local function intervalAsString(self, c, c2)
    if not c2 then return nil end
    if c.i > c2.i or (c.i == c2.i and c.p > c2.p) then
        c, c2 = c2, c
    end
    -- selection is from c to c2, exclusive
    if c.i == c2.i then return self.lines[c.i]:sub(c.p, c2.p - 1) end
    -- table that will be concatenated to create the string
    local tab = {self.lines[c.i]:sub(c.p)}
    for i = c.i + 1, c2.i - 1, 1 do
        table.insert(tab, self.lines[i])
    end
    table.insert(tab, self.lines[c2.i]:sub(1, c2.p - 1))
    return table.concat(tab, '\n')
end

local change_cursor = {up = true, down = true, left = true, right = true, home = true, ["end"] = true}

local function buzz()
    SFX.buzz:stop()
    SFX.buzz:play()
end

function TextBox:keyPressed(key)
    local c = self.cursor
    if change_cursor[key] then
        if love.keyboard.isDown("lshift", "rshift") then
            -- allows multiple selection
            self.cursor2 = self.cursor2 or {i = c.i, p = c.p}
        else
            self.cursor2 = nil
        end
    end
    if key == 'escape' then self.cursor2 = nil end

    local ctrl = love.keyboard.isDown('lctrl', 'rctrl')

    local c2 = self.cursor2
    if not c2 and key == 'backspace' then
        if c.p == 1 and c.i == 1 then buzz() return end
        if c.p == 1 then
            if #self.lines[c.i - 1] + #self.lines[c.i] > self.max_char then buzz() return end
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
        self:pushBackup()

    elseif not c2 and key == 'delete' then
        if c.p == #self.lines[c.i] + 1 and c.i == self.line_cur then buzz() return end
        if c.p == #self.lines[c.i] + 1 then
            if #self.lines[c.i] + #self.lines[c.i + 1] > self.max_char then buzz() return end
            self.line_cur = self.line_cur - 1
            self.lines[c.i] = self.lines[c.i]  .. self.lines[c.i + 1]
            for i = c.i + 1, self.line_total - 1 do
                self.lines[i] = self.lines[i + 1]
            end
            self.lines[self.line_total] = ""
        else
            self.lines[c.i] = processDelete(self.lines[c.i], c.p)
        end
        self:pushBackup()

    elseif c2 and (key == 'delete' or key == 'backspace') then
        self:tryWrite('')

    elseif key == 'return' then
        self:tryWrite('\n')

    elseif key == 'left' then
        if c.p > 1 then
            c.p = c.p - 1
        elseif c.i > 1 then
            c.i = c.i - 1
            c.p = #self.lines[c.i] + 1
        end

    elseif key == 'right' then
        if c.p < #self.lines[c.i] + 1 then
            c.p = c.p + 1
        elseif c.i < self.line_cur then
            c.i = c.i + 1
            c.p = 1
        end

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
        if self.accepted_chars[' '] then
            self:tryWrite(self.accepted_chars[' '] .. self.accepted_chars[' '])
        end

    elseif key == 'space' then
        -- Necessary to work on browsers - it doesn't trigger textinput
        if self.accepted_chars[' '] then
            self:tryWrite(self.accepted_chars[' '])
        end

    elseif key == 'a' and ctrl then
        -- select all text
        c.i = self.line_cur
        c.p = #self.lines[c.i] + 1
        c2 = {i = 1, p = 1}
        self.cursor2 = c2

    elseif key == 'l' and ctrl then
        -- complete selection to full lines
        if not c2 then c2 = {i = c.i, p = c.p} end
        if c2.i > c.i then
            c, c2 = c2, c
        end
        c.p = #self.lines[c.i] + 1
        c2.p = 1
        self.cursor, self.cursor2 = c, c2

    elseif key == 'z' and ctrl then
        if not self:undo() then buzz() end

    elseif key == 'y' and ctrl then
        if not self:redo() then buzz() end

    elseif key == 'c' and ctrl and c2 then
        love.system.setClipboardText(intervalAsString(self, c, c2))

    elseif key == 'x' and ctrl and c2 then
        love.system.setClipboardText(intervalAsString(self, c, c2))
        self:tryWrite('')

    elseif key == 'v' and ctrl then
        self:tryWrite(love.system.getClipboardText())

    end

    -- ignore empty selection
    c, c2 = self.cursor, self.cursor2
    if c2 and c.i == c2.i and c.p == c2.p then self.cursor2 = nil end

    if self.cursor.i - 1 < self.dy then self.dy = self.cursor.i - 1 end
    if self.cursor.i - self.lines_on_screen > self.dy then self.dy = self.cursor.i - self.lines_on_screen end
end

--[[Checks whether this TextBox field lines is valid
  The textbox will usually do changes and then check if they are valid, if they are
  not, then it will go back.
  "It's better to ask for forgiveness than for permission"
]]
function TextBox:checkValid()
    if not self.lines then return false end
    if #self.lines ~= self.line_total then return false end
    for i = 1, self.line_total do
        if #self.lines[i] > self.max_char then return false end
    end
    return true
end

-- copies a table (only its direct children)
local function shallowCopy(tab)
    if not tab then return nil end
    local copy = {}
    for a, b in pairs(tab) do copy[a] = b end
    return copy
end

-- returns a table that contains all info about this TextBox, and can be later restored
-- using TextBob:recoverBackup()
-- WARNING: does not store information like line_total and show_line_num, just text and cursor positions
function TextBox:getBackup()
    return {
        lines = shallowCopy(self.lines),
        line_cur = self.line_cur,
        c = shallowCopy(self.cursor),
        c2 = shallowCopy(self.cursor2)
    }
end

function TextBox:recoverBackup(bak)
    self.lines = shallowCopy(bak.lines)
    self.line_cur = bak.line_cur
    self.cursor = shallowCopy(bak.c)
    self.cursor2 = shallowCopy(bak.c2)
end

-- Tries to write text t on current cursor position, return whether it was successful
function TextBox:tryWrite(t)
    -- First, should check if all chars are valid and do not need to be changed
    for c in t:gmatch('.') do assert(self.accepted_chars[c] == c or c == '\n') end

    -- backup -- should be the latest backup but let's be sure
    local bak = self:getBackup()

    local c = self.cursor

    if self.cursor2 then
        deleteInterval(self, c, self.cursor2)
        c = self.cursor
    end
    local pref = c.p == 1 and "" or self.lines[c.i]:sub(1, c.p - 1)
    local suf = self.lines[c.i]:sub(c.p)
    local l = {} -- lines to add
    for s in (t .. '\n'):gmatch("([^\n]*)\n") do table.insert(l, s) end

    if c.i + #l - 1 <= self.line_total then
        for i = self.line_total, c.i + #l, -1 do
            self.lines[i] = self.lines[i - #l + 1]
        end
        for i = 1, #l do
            local cur = l[i]
            if i == 1 then cur = pref .. cur end
            if i == #l then cur = cur .. suf end
            self.lines[c.i + i - 1] = cur
        end
        self.line_cur = self.line_cur + #l - 1
        c.i = c.i + #l - 1
        c.p = #self.lines[c.i] + 1 - #suf
    else
        self.lines = nil
    end

    if not self:checkValid() then
        self:recoverBackup(bak)
        SFX.buzz:stop()
        SFX.buzz:play()
        return false
    else
        self:pushBackup()
        return true
    end
end

function TextBox:textInput(t)
    -- First, should check if it is valid
    t = self.accepted_chars[t]
    if not t or t == ' ' then return end
    self:tryWrite(t)
end

local function getCursorOnClick(self, x, y)
    -- mouse click on editor
    y = y + self.dy * self.line_h
    local dx = (self.show_line_num and self.font:getWidth("20: ") or 0) + 5
    -- if x < self.pos.x + dx - 2 then return end
    local w = self.font_w
    local i = math.floor((y - self.pos.y) / self.line_h) + 1
    local p = math.max(1, math.floor((x - self.pos.x - dx + 2) / w) + 1)
    return i, p
end

function TextBox:update(dt)
    self.cursor_timer:update(dt)
    if self.mouse_select then
        local i, p = getCursorOnClick(self, love.mouse.getPosition())
        if i <= 0 then i = 1 end
        if i > self.line_cur then i = self.line_cur end
        if p <= 0 then p = 1 end
        if p > #self.lines[i] + 1 then p = #self.lines[i] + 1 end
        if i ~= self.cursor.i or p ~= self.cursor.p then
            if not self.cursor2 then self.cursor2 = {} end
            local c, c2 = self.cursor, self.cursor2
            c2.i = i
            c2.p = p
            -- to select the last char
            if c2.i > c.i or (c2.i == c.i and c2.p > c.p) then
                c2.p = c2.p + 1
                if c2.p > #self.lines[c2.i] + 1 then
                    c2.p = 1
                    c2.i = c2.i + 1
                end
            end
        end
    end
end


function TextBox:mousePressed(x, y, but)
    if but ~= 1 or not Util.pointInRect(x, y, self) then return end

    local i, p = getCursorOnClick(self, x, y)
    if i <= 0 or p <= 0 then return end
    self.cursor.i = math.min(i, self.line_cur)
    self.cursor.p = math.min(p, #self.lines[self.cursor.i] + 1)
    self.cursor2 = nil
    -- start grabbing mouse
    self.mouse_select = true

end

function TextBox:mouseReleased(x, y, but)
    if but == 1 then self.mouse_select = false end
end

function TextBox:mouseScroll(x, y)
    local mx, my = love.mouse.getPosition()
    if Util.pointInRect(mx, my, self) then
        self.dy = self.dy - y
    end
    self.dy = math.min(self.dy, self.line_cur - 1)
    self.dy = math.max(self.dy, -self.lines_on_screen + 1)
end

function TextBox:typeString(str)
    for c in str:gmatch(".") do
        if c == '\n' then
            self:keyPressed('return')
        elseif c == ' ' then
            self:keyPressed('space')
        else
            self:textInput(c)
        end
    end
end
