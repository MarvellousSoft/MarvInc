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

    button_color = 160,

    init = function(self, eps, dy)
        Tab.init(self, eps, dy)

        self.w = self.w - 13 / 2
        self.image = BUTS_IMG.achievements
        self.name = "achievements"

        self.true_h = 0
        local obj = { -- scroll bar in case some day we have too many options
            pos = self.pos,
            getHeight = function() return self.true_h end,
            draw = function() self:trueDraw() end,
            mousePressed = function(obj, ...) self:trueMousePressed(...) end,
            mouseReleased = function(obj, ...) self:trueMouseReleased(...) end,
            mouseMoved = function(obj, ...) self:trueMouseMoved(...) end,
            mouseScroll = function(obj, ...) self:trueMouseScroll(...) end
        }
        self.box = ScrollWindow(self.w + 5, self.h, obj, nil, 35)
        self.box.sw = 13
        self.box.color = {12, 30, 10}

        self.title_font = FONTS.firaBold(40)
        self.title_gap = 70 --Gap between title and achievements
        self.ach_name_font_f = FONTS.firaBold
        self.ach_name_font_start_size = 25
        self.ach_descr_font_f = FONTS.fira
        self.ach_descr_font_start_size = 20
        self.ach_image_scale = .5 --Scale to apply on achievement image
        self.ach_gap = 38 --Gap between each achievement

        self.text_color = {0, 0, 0}
        self.title_color = {255, 255, 255}


        self:updateTrueH()

        self.tp = "achievements_tab"
        self:setId("achievements_tab")
    end
}

function AchievementsTab:trueDraw()

    local h = 0
     -- Draw Title
    love.graphics.setColor(self.title_color)
    love.graphics.setFont(self.title_font)
    local y = self.pos.y + self.title_font:getHeight() * .2
    love.graphics.printf("Achievements", self.pos.x, y, self.w, 'center')
    love.graphics.setLineWidth(6)
    y = y + self.title_font:getHeight() + 4
    x = self.pos.x + self.w/2 - self.title_font:getWidth("Achievements")/2
    love.graphics.line(x, y, x + self.title_font:getWidth("Achievements"), y)
    h = h + self.title_font:getHeight() * 2 + self.title_gap

    love.graphics.setColor(self.text_color)
    local x = 50
    local scale = self.ach_image_scale
    local completed
    --Draw Achievements
    for _, ach in ipairs(ACHIEVEMENT_DATABASE) do
        local image
        if ACHIEVEMENT_PROGRESS[ach[1]] then
            completed = true
            image = ach[4] --completed
        else
            completed = false
            image = ach[3] --incompleted
        end

        --Draw background
        local gap_x = 12
        local gap_y = 12
        local offset = 5
        love.graphics.setColor(0, 0, 0, 190)
        love.graphics.rectangle("fill", x - gap_x - offset, h - gap_y + offset, self.w - 5, image:getHeight()*scale+2*gap_y, 7)
        if completed then
            love.graphics.setColor(200, 250, 200, 220)
        else
            love.graphics.setColor(200, 200, 200, 220)
        end
        love.graphics.rectangle("fill", x - gap_x, h - gap_y, self.w - 5, image:getHeight()*scale+2*gap_y, 8)

        --Draw image
        offset = 4
        love.graphics.setColor(0, 0, 0, 180, 4)
        love.graphics.rectangle("fill", x - offset, h + offset, image:getWidth()*scale, image:getHeight()*scale)
        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(image, x, h, nil, scale)

        --Draw achievement name
        local text_x = x + image:getWidth()*scale + 10
        -- Get name font
        local name_font = self.ach_name_font_f(self.ach_name_font_start_size)
        local i = 0
        while name_font:getWidth(ach[1]) > self.w - 95 do
            i = i + 1
            name_font = self.ach_name_font_f(self.ach_name_font_start_size-i)
        end
        --Get description font
        local descr_font = self.ach_descr_font_f(self.ach_descr_font_start_size)
        local descr_text = completed and ach[2] or "???"
        local i = 0
        while descr_font:getWidth(descr_text) > self.w - 95 do
            i = i + 1
            descr_font = self.ach_descr_font_f(self.ach_descr_font_start_size-i)
        end

        local small_gap = 3
        local name_y = h + image:getHeight()*scale/2 - (name_font:getHeight(ach[1]) + small_gap + descr_font:getHeight(descr_text))/2
        love.graphics.setColor(self.text_color)
        love.graphics.setFont(name_font)
        love.graphics.print(ach[1], text_x, name_y)

        --Draw achievement description

        love.graphics.setFont(descr_font)
        love.graphics.print(descr_text, text_x, name_y + name_font:getHeight(ach[1]) + small_gap)

        h = h + image:getHeight()*scale + self.ach_gap
    end

end

function AchievementsTab:updateTrueH()
    local h =  self.title_font:getHeight() * 2 + self.title_gap
    for _, ach in ipairs(ACHIEVEMENT_DATABASE) do
        local image
        if ACHIEVEMENT_PROGRESS[ach[1]] then
            image = ach[4] --completed
        else
            image = ach[3] --incompleted
        end
        h = h + image:getHeight()*self.ach_image_scale + self.ach_gap
    end
    if #ACHIEVEMENT_DATABASE > 0 then
        h = h - self.ach_gap
    end
    self.true_h = h
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
