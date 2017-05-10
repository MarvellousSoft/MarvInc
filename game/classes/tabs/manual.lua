require "classes.primitive"
local Color = require "classes.color.color"
require "classes.tabs.tab"
require "classes.button"

local ScrollWindow = require "classes.scroll_window"

local items = require "classes.tabs.manual_items"

local bsz = nil

ManualTab = Class {
    __includes = {Tab},

    button_color = 100,

    init = function(self, eps, dy)
        Tab.init(self, eps, dy)

        -- list of buttons
        self.expand_buts = {}
        self.collapse_buts = {}

        -- list of known commands
        self.cmds = {}

        self.true_h = 0
        local obj = {
            pos = self.pos,
            getHeight = function() return self.true_h end,
            draw = function() self:trueDraw() end,
            mousePressed = function(obj, ...) self:trueMousePressed(...) end
        }
        self.box = ScrollWindow(self.w, self.h, obj)

        self.title_font = FONTS.firaBold(40)
        self.info_font = FONTS.fira(20)
        self.info_text = "Here are all your know commands, their explanations and examples. Click on an item for more details."

        self.cmd_font = FONTS.fira(22)
        self.cmd_info_font = FONTS.fira(17)
        self.example_title_font = FONTS.firaBold(18)
        self.example_code_font = FONTS.fira(16)
        self.example_expl_font = FONTS.fira(16)
        self.notes_title_font = FONTS.firaBold(18)
        self.notes_text_font = FONTS.fira(14)

        self.background_color = Color.new(130, 180, 180, 7)

        self.tp = "manual_tab"
        self:setId("manual_tab")
    end
}

local function wrap_height(font, txt, w)
    local _, wrap = font:getWrap(txt, w)
    return font:getHeight() * (#wrap)
end

function ManualTab:trueDraw()
    love.graphics.setColor(0, 0, 0)

    local h = 0
    love.graphics.setFont(self.title_font)
    love.graphics.printf("Manual", self.pos.x, self.pos.y + self.title_font:getHeight() * .2, self.w, 'center')
    h = h + self.title_font:getHeight() * 1.7 -- title

    love.graphics.setFont(self.info_font)
    love.graphics.printf(self.info_text, self.pos.x + 10, self.pos.y + h, self.w - 10, 'left')
    h = h + wrap_height(self.info_font, self.info_text, self.w - 10) + self.info_font:getHeight() -- info

    for _, item in ipairs(self.cmds) do
        if items[item].command then
            local b = self.expand_buts[item] or self.collapse_buts[item]
            b.pos.x = 5 + self.pos.x
            b.pos.y = self.pos.y + h
            b:centralize(); b:draw()
            love.graphics.setColor(0, 0, 0)

            love.graphics.setFont(self.cmd_font)
            love.graphics.print(items[item].command, self.pos.x + 5 + b.w + 5, self.pos.y + h)
            h = h + self.cmd_font:getHeight()
            if not self.expand_buts[item] then
                h = h + 10
                love.graphics.setFont(self.cmd_info_font)
                love.graphics.printf(items[item].text, self.pos.x + 20, self.pos.y + h, self.w - 20)
                h = h + wrap_height(self.cmd_info_font, items[item].text, self.w - 20) + self.cmd_info_font:getHeight()
                if #items[item].examples > 0 then
                    love.graphics.setFont(self.example_title_font)
                    love.graphics.print("Examples", self.pos.x + 20, self.pos.y + h)
                    h = h + self.example_title_font:getHeight()
                    love.graphics.setLineWidth(.5)
                    for _, e in ipairs(items[item].examples) do
                        h = h + 10
                        local dh = wrap_height(self.example_code_font, e[1], self.w - 12.5)
                        love.graphics.rectangle('line', self.pos.x + 20, self.pos.y + h + 2.5, self.w - 40, dh + 5)
                        love.graphics.setFont(self.example_code_font)
                        love.graphics.printf(e[1], self.pos.x + 22.5, self.pos.y + h + 5, self.w - 45)
                        h = h + dh + 10
                        if e[2] then
                            h = h + 5
                            love.graphics.setFont(self.example_expl_font)
                            love.graphics.printf(e[2], self.pos.x + 20, self.pos.y + h, self.w - 20)
                            h = h + wrap_height(self.example_expl_font, e[2], self.w - 20)
                        end
                    end
                end
                if items[item].notes then
                    h = h + 20
                    love.graphics.setFont(self.notes_title_font)
                    love.graphics.print("Notes", self.pos.x + 20, self.pos.y + h)
                    h = h + self.notes_title_font:getHeight() + 10
                    love.graphics.setFont(self.notes_text_font)
                    love.graphics.printf(items[item].notes, self.pos.x + 20, self.pos.y + h, self.w - 20)
                    h = h + wrap_height(self.notes_text_font, items[item].notes, self.w - 20)
                end
                h = h + 10
            end
        end
    end

    self.true_h = h
end

function ManualTab:trueMousePressed(x, y, but)
    if but ~= 1 then return end
    for _, b in pairs(self.expand_buts) do
        if b:checkCollides(x, y) then return end
    end
    for _, b in pairs(self.collapse_buts) do
        if b:checkCollides(x, y) then return end
    end
end

function ManualTab:expand(item, example)
    if example then
        local ex = item .. 'examples'
        local b = self.expand_buts[ex]
        self.expand_buts[ex] = nil
        b.text = '-'
        b.callback = function() self:collapse(item, true) end
        self.collapse_buts[ex] = b
    else
        local b = self.expand_buts[item]
        self.expand_buts[item] = nil
        b.text = '-'
        b.callback = function() self:collapse(item) end
        self.collapse_buts[item] = b
    end
end

function ManualTab:collapse(item, example)
    if example then
        local ex = item .. 'examples'
        local b = self.collapse_buts[ex]
        self.collapse_buts[ex] = nil
        b.text = '-'
        b.callback = function() self:expand(item, true) end
        self.expand_buts[ex] = b
    else
        local b = self.collapse_buts[item]
        self.collapse_buts[item] = nil
        b.text = '+'
        b.callback = function() self:expand(item) end
        self.expand_buts[item] = b
    end
end

local PButton = Class{
    __includes = {Button}
}

function PButton:checkCollides(x, y)
    if Util.pointInRect(x, y, self.pos.x, self.pos.y, self.w + self.ew, self.h) then
        self:callback()
        return true
    end
    return false
end

function PButton:draw()
    local mx, my = love.mouse.getPosition()
    local over = Util.pointInRect(mx, my, self.pos.x, self.pos.y, self.w + self.ew, self.h)
    if over then
        love.graphics.setColor(200, 200, 200, 100)
        love.graphics.rectangle('fill', self.pos.x, self.pos.y, self.w + self.ew, self.h)
    end
    Button.draw(self)
end

function ManualTab:addCommand(item_name)
    table.insert(self.cmds, item_name)
    local bsz = self.cmd_font:getHeight()
    local b = PButton(-2 * bsz, -2 * bsz, bsz, bsz, function() self:expand(item_name) end, '+', FONTS.fira(30))
    if items[item_name].command then
        b.ew = self.cmd_font:getWidth(items[item_name].command) + 10
    end
    b.text_color = Color.green()
    b.text_color.a = 150
    self.expand_buts[item_name] = b
end

-- Changes command 'from' to 'to'. Used for commands that are taught in parts.
function ManualTab:changeCommand(from, to)
    for i, name in ipairs(self.cmds) do
        if name == from then
            self.cmds[i] = to
            local b = self.expand_buts[from] or self.collapse_buts[from]
            self.expand_buts[from], self.collapse_buts[from] = nil, nil
            self.expand_buts[to] = b
            b.text = '+'
            b.callback = function() self:expand(to) end
            if not b.ew then
                b.ew = self.cmd_font:getWidth(items[to].command) + 10
            end
            return
        end
    end
end

function ManualTab:mousePressed(x, y, but)
    self.box:mousePressed(x, y, but)
end

function ManualTab:mouseMoved(x, y)
    self.box:mouseMoved(x, y)
end

function ManualTab:mouseReleased(x, y, but)
    self.box:mouseReleased(x, y, but)
end

function ManualTab:update(dt)
    self.box:update(dt)
end

function ManualTab:mouseScroll(x, y)
    self.box:mouseScroll(x, y)
end

function ManualTab:draw()
    self.box:draw()
end
