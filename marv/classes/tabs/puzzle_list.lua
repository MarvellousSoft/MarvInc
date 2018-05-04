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

PuzzleListTab = Class {
    __includes = {Tab},

    button_color = 40,

    init = function(self, eps, dy)
        Tab.init(self, eps, dy)

        local border_w = 20

        local categories = {"main game", "dlc"}
        local button_dy = 20
        local button_w = 130
        local button_h = 30

        self.buttons = {} -- buttons for each source
        self.lists = {} -- puzzle list for each source
        for i, name in ipairs(categories) do
            local callback = function(b) self.active_list = self.lists[i] end
            local b = Button(self.pos.x + border_w + (self.w - 2 * border_w) * i / (#categories + 1) - button_w / 2, self.pos.y + button_dy, button_w, 30, callback, name, FONTS.fira(20), nil, nil, Color.black(), 'line')
            b.text_color = Color.black()
            table.insert(self.buttons, b)
            local obj = {
                pos = Vector(self.pos.x + border_w, self.pos.y + button_dy + button_h + 20),
                getHeight = function(obj) return obj.true_h end,
                draw = function() self:list_draw() end,
                mousePressed = function(...) self:list_mousePressed(...) end,
                true_h = 0
            }
            table.insert(self.lists, ScrollWindow(self.w - 2 * border_w, self.pos.y + self.h - obj.pos.y, obj))
        end
        self.active_list = self.lists[1]

        self.tp = "puzzle_list_tab"
        self:setId("puzzle_list_tab")
    end
}

function PuzzleListTab:draw()
    for _, b in ipairs(self.buttons) do
        b:draw()
    end
    self.active_list:draw()
end

function PuzzleListTab:mousePressed(x, y, but)
    if but ~= 1 then return end
    for _, b in ipairs(self.buttons) do
        b:checkCollides(x, y)
    end
    self.active_list:mousePressed(x, y, but)
end

function PuzzleListTab:mouseMoved(...) self.active_list:mouseMoved(...) end
function PuzzleListTab:mouseReleased(...) self.active_list:mouseReleased(...) end
function PuzzleListTab:mouseScroll(...) self.active_list:mouseScroll(...) end
function PuzzleListTab:update(...) self.active_list:update(...) end

function PuzzleListTab:list_draw()
    self.active_list.obj.true_h = 1000
end

function PuzzleListTab:list_mousePressed(x, y, but)
end
