--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

require "classes.primitive"
local Color = require "classes.color.color"
require "classes.tabs.tab"
require "classes.button"

local ScrollWindow = require "classes.scroll_window"

local items = require "classes.tabs.manual_items"

local bsz = nil

ManualTab = Class {
    __includes = {Tab},

    button_color = 200,
    lightness_mod = .25,

    init = function(self, eps, dy)
        Tab.init(self, eps, dy)

        self.name = "manual"

        -- list of buttons
        self.expand_buts = {}
        self.collapse_buts = {}

        -- list of known commands
        self.cmds = {}

        self.w = self.w - 13 / 2

        self.true_h = 0
        local obj = {
            pos = self.pos,
            getHeight = function() return self.true_h end,
            draw = function() self:trueDraw() end,
            mousePressed = function(obj, ...) self:trueMousePressed(...) end,
            mouseMoved = function(obj, ...) self:trueMouseMoved(...) end,
            mouseScroll = function(obj, ...) self:trueMouseScroll(...) end
        }
        self.box = ScrollWindow(self.w + 5, self.h, obj)

        self.box.sw = 13

        self.box.color = {180, 180, 180}

        self.title_font = FONTS.firaBold(40)
        self.info_font = FONTS.fira(20)
        self.info_text = "Here are all your known commands, their explanations and examples. Click on an item for more details."

        self.cmd_font = FONTS.fira(22)
        self.cmd_info_font = FONTS.fira(17)
        self.example_title_font = FONTS.firaBold(18)
        self.example_code_font = FONTS.fira(16)
        self.example_expl_font = FONTS.fira(16)
        self.notes_title_font = FONTS.firaBold(18)
        self.notes_text_font = FONTS.fira(14)

        self.background_color = Color.new(130, 180, 180, 7)

        self.text_color = {200, 200, 200}

        self.tp = "manual_tab"
        self:setId("manual_tab")
    end
}

local function wrap_height(font, txt, w)
    local _, wrap = font:getWrap(txt, w)
    return font:getHeight() * (#wrap)
end

local function draw_border(border_text, x, y, ...)
  if true then return end
  local fh = love.graphics.getFont():getHeight()
  love.graphics.setColor(0, 0, 0)
  fh = fh / 20
  love.graphics.printf(border_text, x + fh, y + fh, ...)
  love.graphics.printf(border_text, x - fh, y + fh, ...)
  love.graphics.printf(border_text, x + fh, y - fh, ...)
  love.graphics.printf(border_text, x - fh, y - fh, ...)
end

function ManualTab:trueDraw()
    -- Possible future improvement: Avoid calling Util.stylizeText all the time, since the output is always the same.
    love.graphics.setColor(self.text_color)

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
            love.graphics.setFont(self.cmd_font)
            local text, _, all_but_default_text = Util.stylizeText(items[item].command, self.text_color)
            local x, y = self.pos.x + 5 + b.w + 5, self.pos.y + h

            draw_border(all_but_default_text, x, y, W, 'left')

            love.graphics.setColor(255, 255, 255) -- white to draw colored text
            love.graphics.printf(text, x, y, W, 'left')

            h = h + self.cmd_font:getHeight()
            if not self.expand_buts[item] then
                h = h + 10
                love.graphics.setFont(self.cmd_info_font)
                local colored_text, normal_text, all_but_default_text = Util.stylizeText(items[item].text, self.text_color, "cmntm")

                local x, y = self.pos.x + 20, self.pos.y + h
                draw_border(all_but_default_text, x, y, self.w - 20)

                love.graphics.setColor(255, 255, 255) -- white to draw colored text
                love.graphics.printf(colored_text, x, y, self.w - 20)


                h = h + wrap_height(self.cmd_info_font, normal_text, self.w - 20) + self.cmd_info_font:getHeight()
                if #items[item].examples > 0 then
                    love.graphics.setFont(self.example_title_font)
                    love.graphics.setColor(self.text_color)
                    love.graphics.print("Examples", self.pos.x + 20, self.pos.y + h)
                    h = h + self.example_title_font:getHeight()
                    love.graphics.setLineWidth(.5)
                    for _, e in ipairs(items[item].examples) do -- for each example
                        h = h + 10
                        local colored_text, normal_text, all_but_default_text = Util.stylizeText(e[1], self.text_color, "cmntm") -- e[1] is the code
                        local dh = wrap_height(self.example_code_font, normal_text, self.w - 45)
                        love.graphics.setColor(self.text_color)
                        love.graphics.rectangle('line', self.pos.x + 20, self.pos.y + h + 2.5, self.w - 40, dh + 5)
                        love.graphics.setFont(self.example_code_font)

                        local x, y = self.pos.x + 22.5, self.pos.y + h + 5
                        draw_border(all_but_default_text, x, y, self.w - 45)

                        love.graphics.setColor(255, 255, 255)
                        love.graphics.printf(colored_text, x, y, self.w - 45)

                        h = h + dh + 10
                        if e[2] then -- e[2] is the explanation
                            h = h + 5
                            love.graphics.setFont(self.example_expl_font)
                            local colored_text, normal_text, all_but_default_text = Util.stylizeText(e[2], self.text_color, "cmntm")
                            local x, y = self.pos.x + 20, self.pos.y + h

                            draw_border(all_but_default_text, x, y, self.w - 20)

                            love.graphics.setColor(255, 255, 255)
                            love.graphics.printf(colored_text, x, y, self.w - 20)

                            h = h + wrap_height(self.example_expl_font, normal_text, self.w - 20)
                        end
                    end
                end
                if items[item].notes then
                    h = h + 20
                    love.graphics.setColor(self.text_color)
                    love.graphics.setFont(self.notes_title_font)
                    love.graphics.print("Notes", self.pos.x + 20, self.pos.y + h)
                    h = h + self.notes_title_font:getHeight() + 10
                    love.graphics.setColor(255, 255, 255)
                    love.graphics.setFont(self.notes_text_font)
                    local colored_text, normal_text = Util.stylizeText(items[item].notes, self.text_color)
                    love.graphics.printf(colored_text, self.pos.x + 20, self.pos.y + h, self.w - 20)
                    h = h + wrap_height(self.notes_text_font, normal_text, self.w - 20)
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

function ManualTab:trueMouseMoved(x, y)
    for _, b in pairs(self.expand_buts) do
        if b:mouseMoved(x, y) then return end
    end
    for _, b in pairs(self.collapse_buts) do
        if b:mouseMoved(x, y) then return end
    end
end

function ManualTab:trueMouseScroll(x, y)
    for _, b in pairs(self.expand_buts) do b.hover = false end
    for _, b in pairs(self.collapse_buts) do b.hover = false end
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
    if not self.extra_width then return end -- ghost button
    if Util.pointInRect(x, y, self.pos.x, self.pos.y, self.w + self.extra_width, self.h) then
        self:callback()
        return true
    end
    return false
end

function PButton:mouseMoved(x, y)
    if not self.extra_width then return end -- ghost button
    self.hover = Util.pointInRect(x, y, self.pos.x, self.pos.y, self.w + self.extra_width, self.h)
end

function PButton:draw()
    if not self.extra_width then return end -- ghost button
    if self.hover then
        love.graphics.setColor(200, 200, 200, 100)
        love.graphics.rectangle('fill', self.pos.x, self.pos.y, self.w + self.extra_width, self.h)
    end
    Button.draw(self)
end

local function createCommand(self, item_name)
    local bsz = self.cmd_font:getHeight()
    local b = PButton(-2 * bsz, -2 * bsz, bsz, bsz, function() self:expand(item_name) end, '+', FONTS.fira(30))
    if items[item_name].command then
        -- You should also be able to click on the text
        b.extra_width = self.cmd_font:getWidth(select(2, Util.stylizeText(items[item_name].command))) + 10
    end
    b.text_color = Color.green()
    b.text_color.a = 150
    self.expand_buts[item_name] = b
end

function ManualTab:addCommand(item_name)
    table.insert(self.cmds, item_name)
    createCommand(self, item_name)
end

-- Changes command 'from' to 'to'. Used for commands that are taught in parts.
function ManualTab:changeCommand(from, to)
    for i, name in ipairs(self.cmds) do
        if name == from then
            self.cmds[i] = to
            self.expand_buts[from], self.collapse_buts[from] = nil, nil
            createCommand(self, to)
            return
        end
    end
    print("Current command '" .. from .. "' not found. Adding duplicate.")
    self:addCommand(to)
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
