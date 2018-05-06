local AuthorButton = Class {
    __includes = {RECT}
}

local PuzzleButton = Class {
    __includes = {RECT}
}

local challenge_color = Color.new(21, 100, 53, 255, "hsl", true)
function AuthorButton:init(x, y, w, h, name, puzzle_list)
    RECT.init(self, x, y, w, h)
    self.name = name
    self.puzzle_list = {}
    for _, puzzle in ipairs(puzzle_list) do
        table.insert(self.puzzle_list, PuzzleButton(self.pos.x + 50, 0, 4*self.w/5, 40, puzzle))
    end
    self.img = MISC_IMG.triangle_border
    local sz = 30
    while sz > 2 and FONTS.fira(sz):getWidth(self.name) > self.w - self.h - 10 do
        sz = sz - 2
    end
    self.font = FONTS.firaBold(sz)
    self.expand = false
    self.rot = 0 -- rotation of the triangle
    self.color = Color.new(Util.getAuthorColor(name))

end

function AuthorButton:draw(mx, my)
    if Util.pointInRect(mx, my, self) then
        self.color.a = 60
        if self.color.l then
            self.color.l = self.color.l/5
        else
            self.color.r, self.color.g, self.color.b = self.color.r/5, self.color.g/5, self.color.b/5
        end
        Color.set(self.color)
        love.graphics.rectangle('fill', self.pos.x, self.pos.y, self.w - 2, self.h)
        self.color.a = 255
        if self.color.l then
            self.color.l = 5*self.color.l
        else
            self.color.r, self.color.g, self.color.b = 5*self.color.r, 5*self.color.g, 5*self.color.b
        end
    end
    Color.set(self.color)
    -- Drawing triangle
    love.graphics.draw(self.img, self.pos.x + self.h / 2, self.pos.y + self.h / 2, self.rot, self.h / self.img:getWidth(), self.h / self.img:getHeight(), self.img:getWidth() / 2, self.img:getHeight() / 2)
    love.graphics.setColor(0, 0, 0)
    -- Drawing author name
    Color.set(Color.black())
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

local circles_w = 25
function PuzzleButton:init(x, y, w, h, puzzle)
    RECT.init(self, x, y, w, h)
    self.puzzle = puzzle
    self.has_challenge = self.puzzle.id:find("extra") or self.puzzle.id == "spam"
    local width = self.has_challenge and self.w - circles_w or self.w
    local sz = 30
    while sz > 2 and FONTS.fira(sz):getWidth(puzzle.name) > width do
        sz = sz - 2
    end
    self.font = FONTS.fira(sz)
    self.stats_font = FONTS.fira(15)
end

function PuzzleButton:checkCollides(x, y)
    if Util.pointInRect(x, y, self) then
        -- franz1 shouldn't be replayable
        if self.puzzle.id == "franz1" and LoreManager.puzzle_done.franz1 then
            SFX.buzz:stop()
            SFX.buzz:play()
            return
        end
        ROOM:connect(self.puzzle.id)
    end
end

local color_table = {
    completed = Color.new(70, 150, 160),
    open = Color.new(250, 140, 200),
}

function PuzzleButton:draw(mx, my)
    love.graphics.setFont(self.font)
    local c = color_table[self.puzzle.status]

    --Shadow of box
    love.graphics.setColor(0,0,40,80)
    local offset = 5
    love.graphics.rectangle('fill', self.pos.x - offset, self.pos.y + offset, self.w - 2, self.h, 5, 10)

    --Puzzle Box
    Color.set(c)
    love.graphics.rectangle('fill', self.pos.x, self.pos.y, self.w - 2, self.h, 5, 10)

    --Draw highlight effect
    if Util.pointInRect(mx, my, self) then
        love.graphics.setColor(255, 255, 255, 50)
        love.graphics.rectangle('fill', self.pos.x, self.pos.y, self.w - 2, self.h, 5, 10)
    end

    --Draw contour line
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('line', self.pos.x, self.pos.y, self.w - 2, self.h, 5, 10)

    -- circles
    if self.puzzle.id:find("extra") or self.puzzle.id == "spam" then
        Color.set(challenge_color)
        love.graphics.circle('fill', self.pos.x + circles_w / 2 + 10, self.pos.y + (self.h - circles_w) / 2 + circles_w / 2, circles_w / 2)
        Color.set(Color.black())
        love.graphics.setLineWidth(3)
        love.graphics.circle('line', self.pos.x + circles_w / 2 + 10, self.pos.y + (self.h - circles_w) / 2 + circles_w / 2, circles_w / 2)
    end

    -- name
    love.graphics.setColor(0, 0, 0)
    local shift = self.has_challenge and circles_w or 0
    love.graphics.print(self.puzzle.name, self.pos.x + shift + (self.w - shift - self.font:getWidth(self.puzzle.name)) / 2, self.pos.y + (self.h - self.font:getHeight()) / 2)

    return self.h
end

return AuthorButton
