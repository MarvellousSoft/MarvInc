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

local ToggleButton = Class { -- functions defined below
    __includes = {RECT}
}

SettingsTab = Class {
    __includes = {Tab},

    button_color = 70,

    init = function(self, eps, dy)
        Tab.init(self, eps, dy)

        self.w = self.w - 13 / 2

        self.true_h = self.h
        local obj = { -- scroll bar in case some day we have too many options
            pos = self.pos,
            getHeight = function() return self.true_h end,
            draw = function() self:trueDraw() end,
            mousePressed = function(obj, ...) self:trueMousePressed(...) end,
            mouseMoved = function(obj, ...) self:trueMouseMoved(...) end,
            mouseScroll = function(obj, ...) self:trueMouseScroll(...) end
        }
        self.box = ScrollWindow(self.w + 5, self.h, obj)
        self.box.sw = 13
        self.box.color = {12, 30, 10}

        self.options = {
            ["Background Music"] = ToggleButton(0, 0, 20, 20, function()
                MUSIC_MOD = 1
                GS['GAME'].getBGMManager():updateVolume()
            end, function()
                MUSIC_MOD = 0
                GS['GAME'].getBGMManager():updateVolume()
            end, function() return MUSIC_MOD == 1 end),
            ["Sound Effects"] = ToggleButton(0, 0, 20, 20, function() SOUND_EFFECT_MOD = 1 end, function() SOUND_EFFECT_MOD = 0 end, function() return SOUND_EFFECT_MOD == 1 end),
            ["Fullscreen (F11)"] = ToggleButton(0, 0, 20, 20, function()
                PREV_WINDOW = {love.window.getMode()}
                love.window.setFullscreen(true, "desktop")
                love.resize(love.window.getMode())
            end, function()
                love.window.setFullscreen(false, "desktop")
                if PREV_WINDOW then
                    love.window.setMode(unpack(PREV_WINDOW))
                end
                love.resize(love.window.getMode())
            end, function() return love.window.getFullscreen() end),
            ["Robots Messages Popup"] = ToggleButton(0, 0, 20, 20, function()
                SideMessage.block_extra_bot_messages = false
            end, function()
                SideMessage.block_extra_bot_messages = true
            end, function() return not SideMessage.block_extra_bot_messages end),
            ["Robots Intro Popup"] = ToggleButton(0, 0, 20, 20, function()
                SideMessage.block_intro_bot_messages = false
            end, function()
                SideMessage.block_intro_bot_messages = true
            end, function() return not SideMessage.block_intro_bot_messages end),
            ["Milder Static Screens"] = ToggleButton(0, 0, 20, 20, function()
                MISC_IMG["static"] = MISC_IMG["mild_static"]
                SETTINGS["static"] = "mild_static"
            end, function()
                MISC_IMG["static"] = MISC_IMG["reg_static"]
                SETTINGS["static"] = "reg_static"
            end, function() return SETTINGS["static"] == "mild_static" end),
        }

        self.title_font = FONTS.firaBold(50)
        self.options_font = FONTS.fira(30)

        self.text_color = {0, 0, 0}

        self.tp = "settings_tab"
        self:setId("settings_tab")
    end
}

function SettingsTab:trueDraw()
    -- Possible future improvement: Avoid calling Util.stylizeText all the time, since the output is always the same.
    love.graphics.setColor(self.text_color)

    local h = 0
    love.graphics.setFont(self.title_font)
    love.graphics.printf("Settings", self.pos.x, self.pos.y + self.title_font:getHeight() * .2, self.w, 'center')
    h = h + self.title_font:getHeight() * 2 -- title

    love.graphics.setFont(self.options_font)

    for name, but in pairs(self.options) do
        but.pos.x = self.pos.x + 60
        but.pos.y = self.pos.y + h
        but:draw()
        love.graphics.setColor(0, 0, 0)
        love.graphics.print(name, but.pos.x + but.w + 20, but.pos.y + but.h / 2 - self.options_font:getHeight() / 2)

        -- collision rectangle (includes text)
        but.col_x = but.pos.x - 10
        but.col_y = -10 + but.pos.y + but.h / 2 - self.options_font:getHeight() / 2
        but.col_w = 10 + but.w + 20 + self.options_font:getWidth(name) + 10
        but.col_h = 10 + self.options_font:getHeight() + 10

        h = h + but.h * 3
    end
end

function SettingsTab:trueMousePressed(x, y, but)
    for _, b in pairs(self.options) do
        b:mousePressed(x, y, but)
    end
end

function SettingsTab:trueMouseMoved(x, y)
    for _, b in pairs(self.options) do
        b:mouseMoved(x, y)
    end
end

function SettingsTab:trueMouseScroll(x, y)
end

function ToggleButton:init(x, y, w, h, on_callback, off_callback, is_on)
    RECT.init(self, x, y, w, h)
    self.on_callback = on_callback
    self.off_callback = off_callback
    self.on_f = is_on
    self.on = is_on()
    if self.on then
        self.square_mod = 1
    else
        self.square_mod = 0
    end
    self.hover = false
    self.col_x, self.col_y, self.col_w, self.col_h = 0, 0, 0, 0
end

function ToggleButton:mousePressed(x, y, but)
    if but == 1 and Util.pointInRect(x, y, self.col_x, self.col_y, self.col_w, self.col_h) then
        if self.on then
            self:off_callback()
            MAIN_TIMER:tween(.1, self, { square_mod = 0 })
        else
            self:on_callback()
            MAIN_TIMER:tween(.1, self, { square_mod = 1 })
        end
        SFX.click:stop()
        SFX.click:play()
        self.on = not self.on
    end
end

function ToggleButton:mouseMoved(x, y)
    self.hover = Util.pointInRect(x, y, self.col_x, self.col_y, self.col_w, self.col_h)
end

function ToggleButton:draw()
    love.graphics.setColor(10, 10, 70)
    love.graphics.setColor(30, 30, 30)
    love.graphics.setLineWidth(4)
    love.graphics.rectangle('line', self.pos.x, self.pos.y, self.w, self.h)
    if self.square_mod > 0 then
        local sw = (self.w - 10) * self.square_mod
        local sh = (self.h - 10) * self.square_mod
        love.graphics.rectangle('fill', self.pos.x + self.w / 2 - sw / 2, self.pos.y + self.h / 2 - sh / 2, sw, sh)
    end
    if self.hover then
        love.graphics.setColor(200, 200, 200, 80)
        love.graphics.rectangle('fill', self.pos.x, self.pos.y, self.w, self.h)
    end
end

function ToggleButton:refresh()
    self.on = self.on_f()
    if self.on then
        self.square_mod = 1
    else
        self.square_mod = 0
    end
end

function SettingsTab:mousePressed(x, y, but)
    self.box:mousePressed(x, y, but)
end

function SettingsTab:mouseMoved(x, y)
    self.box:mouseMoved(x, y)
end

function SettingsTab:mouseReleased(x, y, but)
    self.box:mouseReleased(x, y, but)
end

function SettingsTab:update(dt)
    self.box:update(dt)
end

function SettingsTab:mouseScroll(x, y)
    self.box:mouseScroll(x, y)
end

function SettingsTab:draw()
    self.box:draw()
end

function SettingsTab:refresh()
    local tab = Util.findId("settings_tab")
    for _, o in pairs(tab.options) do
        o:refresh()
    end
end
