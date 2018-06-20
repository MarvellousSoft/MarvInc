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

AchievementsTab = Class {
    __includes = {Tab},

    button_color = 230,

    init = function(self, eps, dy)
        Tab.init(self, eps, dy)

        self.w = self.w - 13 / 2

        self.true_h = self.h
        local obj = { -- scroll bar in case some day we have too many options
            pos = self.pos,
            getHeight = function() return self.true_h end,
            draw = function() self:trueDraw() end,
            mousePressed = function(obj, ...) self:trueMousePressed(...) end,
            mouseReleased = function(obj, ...) self:trueMouseReleased(...) end,
            mouseMoved = function(obj, ...) self:trueMouseMoved(...) end,
            mouseScroll = function(obj, ...) self:trueMouseScroll(...) end
        }
        self.box = ScrollWindow(self.w + 5, self.h, obj)
        self.box.sw = 13
        self.box.color = {12, 30, 10}

        self.title_font = FONTS.firaBold(50)

        self.text_color = {0, 0, 0}

        self.tp = "achievements_tab"
        self:setId("achievements_tab")
    end
}

function AchievementsTab:trueDraw()
    love.graphics.setColor(self.text_color)

    local h = 0
    love.graphics.setFont(self.title_font)
    love.graphics.printf("Achievements", self.pos.x, self.pos.y + self.title_font:getHeight() * .2, self.w, 'center')
    h = h + self.title_font:getHeight() * 2 -- title

end

function AchievementsTab:trueMousePressed(x, y, but)
end

function AchievementsTab:trueMouseReleased(x, y, but)
end


function AchievementsTab:trueMouseMoved(...)
end

function AchievementsTab:trueMouseScroll(x, y)
end

-----------------------------

function AchievementsTab:mousePressed(x, y, but)
    self.box:mousePressed(x, y, but)
end

function AchievementsTab:mouseMoved(...)
    self.box:mouseMoved(...)
end

function AchievementsTab:mouseReleased(x, y, but)
    self.box:mouseReleased(x, y, but)
end

function AchievementsTab:update(dt)
    self.box:update(dt)
end

function AchievementsTab:mouseScroll(x, y)
    self.box:mouseScroll(x, y)
end

function AchievementsTab:draw()
    self.box:draw()
end
