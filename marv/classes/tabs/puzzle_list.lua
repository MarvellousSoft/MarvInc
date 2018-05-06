--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local ScrollWindow = require "classes.scroll_window"
require "classes.tabs.tab"
local AuthorButton = require "classes.tabs.puzzle_list_buttons"

local border_w = 20
local button_dy = 20
local button_h = 30
local detail_h = 50
local title_h = 60
local challenge_color = Color.new(21, 100, 53, 255, "hsl", true)

PuzzleListTab = Class {
    __includes = {Tab},

    button_color = 120,
    lightness_mod = 1.05,

    init = function(self, eps, dy)
        Tab.init(self, eps, dy)


        local categories = {"main game"}
        local button_w = 130

        self.title_font = FONTS.firaBold(40)
        self.separator_font = FONTS.fira(35)
        self.buttons = {} -- buttons for each category
        self.lists = {} -- puzzle list for each category
        for i, name in ipairs(categories) do
            local callback = function(b) self.active_list = self.lists[i] end
            local b = Button(self.pos.x + border_w + (self.w - 2 * border_w) * i / (#categories + 1) - button_w / 2, self.pos.y + title_h + button_dy - 8, button_w, 30, callback, name, FONTS.fira(20), nil, nil, Color.black(), 'line')
            b.text_color = Color.black()
            table.insert(self.buttons, b)
            local obj = {
                pos = Vector(self.pos.x + border_w, self.pos.y + button_dy + button_h + detail_h + title_h),
                getHeight = function(obj) return obj.true_h end,
                draw = function() self:list_draw() end,
                mousePressed = function(obj, ...) self:list_mousePressed(...) end,
                mouseMoved = function(obj, x, y) obj.mx, obj.my = x, y end,
                true_h = 0, mx = 0, my = 0
            }
            table.insert(self.lists, ScrollWindow(self.w - 2 * border_w, self.pos.y + self.h - obj.pos.y, obj))
        end
        self.active_list = self.lists[1]

        self:refresh()

        self.tp = "puzzle_list_tab"
        self:setId("puzzle_list_tab")
    end
}

function PuzzleListTab:draw()

    --Draw Title
    Color.set(Color.black())
    love.graphics.setFont(self.title_font)
    love.graphics.printf("Puzzle List", self.pos.x, self.pos.y + self.title_font:getHeight() * .2, self.w, 'center')

    --Draw categories buttons
    for _, b in ipairs(self.buttons) do
        b:draw()
    end

    local sz = detail_h * .5
    --Draw upper separator
    Color.set(Color.black())
    love.graphics.setFont(self.separator_font)
    love.graphics.print("--------------------------", self.pos.x, self.pos.y + title_h + button_dy + button_h + sz / 2 + detail_h * .25 - 43)

    --Draw subtitles
    Color.set(challenge_color)
    love.graphics.circle('fill', self.pos.x + sz / 2 + 165, self.pos.y + title_h + button_dy + button_h + sz / 2 + detail_h * .25 + 1, sz / 2)
    Color.set(Color.black())
    love.graphics.setLineWidth(3)
    love.graphics.circle('line', self.pos.x + sz / 2 + 165, self.pos.y + title_h + button_dy + button_h + sz / 2 + detail_h * .25 + 1, sz / 2)
    love.graphics.setFont(FONTS.fira(18))
    love.graphics.print(" = challenge puzzle", self.pos.x + sz + 170, self.pos.y + title_h + button_dy + button_h + (detail_h - FONTS.fira(18):getHeight()) / 2 + 1)

    --Draw nottom separator
    Color.set(Color.black())
    love.graphics.setFont(self.separator_font)
    love.graphics.print("--------------------------", self.pos.x, self.pos.y + title_h + button_dy + button_h + (detail_h - FONTS.fira(18):getHeight()) / 2 + 9)

    self.active_list:draw()
end

function PuzzleListTab:mousePressed(x, y, but)
    if but ~= 1 then return end
    for _, b in ipairs(self.buttons) do
        b:checkCollides(x, y)
    end
    self.active_list:mousePressed(x, y, but)
end

function PuzzleListTab:activate() self:refresh() end

function PuzzleListTab:refresh()
    -- refresh the puzzle list
    -- for now just checks the emails for available puzzles
    local l = self.active_list
    l.buttons = {}
    local puzzles = {}
    local has_diego = false
    for _, email in ipairs(Util.findId('email_tab').email_list) do
        if email.puzzle_id then
            local a = email.author
            if a:find("Richard Black") then
                a = "Olivia Kavanagh"
            end
            if a:find("[(]") then
                a = a:sub(1, a:find("[(]") - 2)
            end
            if email.puzzle_id:find("diego") then
                has_diego = true
            end
            puzzles[a] = puzzles[a] or {}
            table.insert(puzzles[a], email.puzzle_id)
        end
    end
    if not has_diego then
        for puzzle in pairs(LoreManager.puzzle_done) do
            if puzzle:find('diego') and love.filesystem.exists('puzzles/' .. puzzle .. '.lua') then
                local a = "Diego Lorenzo Vega"
                puzzles[a] = puzzles[a] or {}
                table.insert(puzzles[a], puzzle)
            end
        end
    end
    for author, puzzle_list in pairs(puzzles) do
        local list = {}
        for _, p in ipairs(puzzle_list) do
            local pu = {ROWS = ROWS, COLS = COLS, print = print, _G = _G}
            local f = love.filesystem.load('puzzles/' .. p .. '.lua')
            setfenv(f, pu)
            f()
            table.insert(list, {name = pu.name, id = p, status = LoreManager.puzzle_done[p] and "completed" or "open"})
        end
        table.insert(l.buttons, AuthorButton(self.pos.x + border_w, 0, self.w - 2 * border_w, 40, author, list))
    end
end

function PuzzleListTab:mouseMoved(x, y)
    local o = self.active_list.obj
    if not Util.pointInRect(x, y, o.pos.x, o.pos.y, self.active_list.w, self.active_list.h) then
        o.mx, o.my = 0, 0
    end
    self.active_list:mouseMoved(x, y)
end
function PuzzleListTab:mouseReleased(...) self.active_list:mouseReleased(...) end
function PuzzleListTab:mouseScroll(...) self.active_list:mouseScroll(...) end
function PuzzleListTab:update(...) self.active_list:update(...) end

function PuzzleListTab:list_draw()
    local y = self.active_list.obj.pos.y
    local sep_h = 10
    local mx, my = self.active_list.obj.mx, self.active_list.obj.my
    for _, b in ipairs(self.active_list.buttons) do
        b.pos.y = y
        y = y + b:draw(mx, my) + sep_h
    end
    self.active_list.obj.true_h = y - self.active_list.obj.pos.y
end

function PuzzleListTab:list_mousePressed(x, y, but)
    for _, b in ipairs(self.active_list.buttons) do
        b:checkCollides(x, y)
    end
end
