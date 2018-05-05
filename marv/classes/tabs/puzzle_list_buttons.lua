local AuthorButton = Class {
    __includes = {RECT}
}

local PuzzleButton = Class {
    __includes = {RECT}
}

local challenge_color = Color.red()
challenge_color.l = 50

function AuthorButton:init(x, y, w, h, name, puzzle_list)
    RECT.init(self, x, y, w, h)
    self.name = name
    self.puzzle_list = {}
    for _, puzzle in ipairs(puzzle_list) do
        table.insert(self.puzzle_list, PuzzleButton(self.pos.x, 0, self.w, 50, puzzle))
    end
    self.img = MISC_IMG.triangle
    local sz = 30
    while sz > 2 and FONTS.fira(sz):getWidth(self.name) > self.w - self.h do
        sz = sz - 2
    end
    self.font = FONTS.fira(sz)
    self.expand = false
    self.rot = 0 -- rotation of the triangle
    self.color = Color.new(Util.getAuthorColor(name))
    if self.color.l then
        self.color.l = self.color.l / 2
    else
        self.color.r, self.color.g, self.color.b = self.color.r / 2, self.color.g / 2, self.color.b / 2
    end
end

function AuthorButton:draw(mx, my)
    if Util.pointInRect(mx, my, self) then
        self.color.a = 30
        Color.set(self.color)
        love.graphics.rectangle('fill', self.pos.x, self.pos.y, self.w - 2, self.h)
        self.color.a = 255
    end
    Color.set(self.color)
    -- Drawing triangle
    love.graphics.draw(self.img, self.pos.x + self.h / 2, self.pos.y + self.h / 2, self.rot, self.h / self.img:getWidth(), self.h / self.img:getHeight(), self.img:getWidth() / 2, self.img:getHeight() / 2)
    love.graphics.setColor(0, 0, 0)
    -- Drawing author name
    Color.set(self.color)
    love.graphics.setFont(self.font)
    love.graphics.print(self.name, self.pos.x + self.h + 10, self.pos.y + (self.h - self.font:getHeight()) / 2)
    if not self.expand then return self.h end

    -- Drawing buttons for each puzzle
    local dy = self.h + 10
    for _, but in ipairs(self.puzzle_list) do
        but.pos.y = self.pos.y + dy
        dy = dy + but:draw(mx, my) + 10
    end
    return dy
end

function AuthorButton:checkCollides(x, y)
    if Util.pointInRect(x, y, self) then
        if self.expand then
            MAIN_TIMER:tween(.1, self, { rot = 0 })
        else
            MAIN_TIMER:tween(.1, self, { rot = math.pi / 2 })
        end
        self.expand = not self.expand
    end
    if not self.expand then return end
    for _, but in ipairs(self.puzzle_list) do
        but:checkCollides(x, y)
    end
end

local circles_w = 30
function PuzzleButton:init(x, y, w, h, puzzle)
    RECT.init(self, x, y, w, h)
    self.puzzle = puzzle
    local sz = 30
    while sz > 2 and FONTS.fira(sz):getWidth(puzzle.name) > self.w - circles_w do
        sz = sz - 2
    end
    self.font = FONTS.fira(sz)
    self.stats_font = FONTS.fira(15)
end

function PuzzleButton:checkCollides(x, y)
    if Util.pointInRect(x, y, self) then
        ROOM:connect(self.puzzle.id)
    end
end

local color_table = {
    completed = Color.green(),
    open = Color.red(),
}

function PuzzleButton:draw(mx, my)
    love.graphics.setFont(self.font)
    local c = color_table[self.puzzle.status]
    c.a = 30
    if Util.pointInRect(mx, my, self) then
        c.a = 50
    end
    Color.set(c)
    love.graphics.rectangle('fill', self.pos.x, self.pos.y, self.w - 2, self.h)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('line', self.pos.x, self.pos.y, self.w - 2, self.h)
    -- circles
    if self.puzzle.id:find("extra") or self.puzzle.id == "spam" then
        Color.set(challenge_color)
        love.graphics.circle('fill', self.pos.x + circles_w / 2 + 5, self.pos.y + (self.h - circles_w) / 2 + circles_w / 2, circles_w / 2)
    end
    -- name
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(self.puzzle.name, self.pos.x + circles_w + (self.w - circles_w - self.font:getWidth(self.puzzle.name)) / 2, self.pos.y + (self.h - self.font:getHeight()) / 2)
    return self.h
end

return AuthorButton
