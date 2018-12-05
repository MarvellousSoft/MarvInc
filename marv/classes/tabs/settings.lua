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

local Slider = Class { -- functions defined below
    __includes = {RECT}
}

SettingsTab = Class {
    __includes = {Tab},

    button_color = 70,

    init = function(self, eps, dy)
        Tab.init(self, eps, dy)
        self.w = self.w - 13 / 2
        self.image = BUTS_IMG.settings
        self.name = "settings"

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

        self.options = {
            audio = {
                ["Background Music"] = Slider(0, 0, 400, function(value)
                    MUSIC_MOD = value
                    GS['GAME'].getBGMManager():updateVolume()
                end, function() return MUSIC_MOD end),
                ["Sound Effects"] = Slider(0, 0, 400, function(value)
                     SOUND_EFFECT_MOD = value
                end, function() return SOUND_EFFECT_MOD end),
            },
            video = {
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
                ["Milder Static Screens"] = ToggleButton(0, 0, 20, 20, function()
                    MISC_IMG["static"] = MISC_IMG["mild_static"]
                    SETTINGS["static"] = "mild_static"
                end, function()
                    MISC_IMG["static"] = MISC_IMG["reg_static"]
                    SETTINGS["static"] = "reg_static"
                end, function() return SETTINGS["static"] == "mild_static" end),
            },
            gameplay = {
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
            }
        }
        self.current_category = "audio"
        self.category_order = {"audio", "video", "gameplay"} --Make sure it has the same names as self.options
        self.cat_buttons = {} -- buttons for each category
        local but_w = 130
        local but_h = 30
        local but_gap = 10
        local but_y = 145
        local n = 0
        for _ in pairs(self.options) do
            n = n + 1
        end
        local size_of_all_buts = (n*but_w + (n-1)*but_gap)
        local i = 0
        for _,name in pairs(self.category_order) do
            local callback = function(b) self.current_category = name end
            local b = Button(self.pos.x + self.w/2 - size_of_all_buts/2 + i*(but_w+but_gap), but_y, but_w, but_h, callback, name, FONTS.fira(20), nil, nil, Color.black(), 'line')
            b.text_color = Color.black()
            table.insert(self.cat_buttons, b)
            i = i + 1
        end

        self.title_font = FONTS.firaBold(50)
        self.options_font = FONTS.fira(30)
        self.separator_font = FONTS.fira(35)
        self.text_color = {0, 0, 0}

        self.tp = "settings_tab"
        self:setId("settings_tab")
    end
}

function SettingsTab:trueDraw()
    love.graphics.setColor(self.text_color)

    local h = 0
    --Draw title
    love.graphics.setFont(self.title_font)
    love.graphics.printf("Settings", self.pos.x, self.pos.y + self.title_font:getHeight() * .2, self.w, 'center')
    h = h + self.title_font:getHeight() * 2 + 30 -- title

    --Draw categories buttons
    for _, b in ipairs(self.cat_buttons) do
        if b.text == self.current_category then
            love.graphics.setLineWidth(5)
        else
            love.graphics.setLineWidth(2)
        end
        b:draw()
    end
    love.graphics.setColor(self.text_color)
    --Draw separator
    love.graphics.setFont(self.separator_font)
    love.graphics.print("--------------------------", self.pos.x, h + 15)

    love.graphics.setFont(self.options_font)
    for name, but in pairs(self.options[self.current_category]) do
        but.pos.x = self.pos.x + 60
        but.pos.y = self.pos.y + h
        but:draw()
        love.graphics.setColor(0, 0, 0)
        if but.type == "toggle" then
            love.graphics.print(name, but.pos.x + but.w + 20, but.pos.y + but.h / 2 - self.options_font:getHeight() / 2)
            -- collision rectangle (includes text)
            but.col_x = but.pos.x - 10
            but.col_y = -1 + but.pos.y + but.h / 2 - self.options_font:getHeight() / 2
            but.col_w = 10 + but.w + 20 + self.options_font:getWidth(name) + 10
            but.col_h = 1 + self.options_font:getHeight() + 1
        else
            love.graphics.print(name, but.pos.x, but.pos.y)
        end

        local margin = 32
        h = h + but:height() + margin
    end
end

function SettingsTab:trueMousePressed(x, y, but)
    for _, b in pairs(self.options[self.current_category]) do
        b:mousePressed(x, y, but)
    end
    if but == 1 then
        for _, b in ipairs(self.cat_buttons) do
            b:checkCollides(x, y)
        end
    end
end

function SettingsTab:trueMouseReleased(x, y, but)
    for _, b in pairs(self.options[self.current_category]) do
        b:mouseReleased(x, y, but)
    end
end


function SettingsTab:trueMouseMoved(...)
    for _, b in pairs(self.options[self.current_category]) do
        b:mouseMoved(...)
    end
end

function SettingsTab:trueMouseScroll(x, y)
end

--TOGGLE BUTTON--

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

    self.type = "toggle"
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

function ToggleButton:mouseReleased(x, y, but)
end

function ToggleButton:mouseMoved(x, y)
    self.hover = Util.pointInRect(x, y, self.col_x, self.col_y, self.col_w, self.col_h)
end

function ToggleButton:draw()
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

function ToggleButton:height()
    return self.h
end

--SLIDER--
function Slider:init(x, y, size, callback, get_value)
    --Slider box dimensions
    w = 20
    h = 30

    RECT.init(self, x, y, w, h)

    self.callback = callback --Called everytime you move the slider
    self.get_value = get_value --Function to get slider value
    self.value = get_value() --Value [0,1] the slider is in
    self.size = size --Width of slider tray
    self.hover = false --If mouse is over slider box
    self.is_sliding = false

    self.slider_gap = 55 --Vertical gap to draw slider below name
    self.slider_line_h = 14 --Height of slider tray line

    self.type = "slider"
end

function Slider:mousePressed(x, y, but)
    if but == 1 and Util.pointInRect(x, y, self:getSliderX() - self.w/2, self:getSliderY(), self.w, self.h) then
        self.is_sliding = true
        SFX.click:stop()
        SFX.click:play()
    elseif but == 1 and Util.pointInRect(x, y, self.pos.x, self.pos.y-self.slider_line_h/2 + self.slider_gap, self.size, self.slider_line_h) then
        self.is_sliding = true
        self:mouseMoved(x,y,x-self:getSliderX(),0)
        SFX.click:stop()
        SFX.click:play()
    end
end

function Slider:mouseReleased(x, y, but)
    if but == 1 then
        self.is_sliding = false
        -- reset hovering
        self.hover = Util.pointInRect(x, y, self:getSliderX() - self.w/2, self:getSliderY(), self.w, self.h)
    end
end

function Slider:mouseMoved(x, y, dx, dy)
    if self.is_sliding then
         --Clamp pos
        local slider_x = math.max(self.pos.x, math.min(self.pos.x+self.size, x))
        --Update value
        local old_value = self.value
        self.value = (slider_x - self.pos.x)/self.size
        --Call callback
        if old_value ~= self.value then
            self.callback(self.value)
        end
        self.hover = true -- should show as hovering if you're sliding it
    else
        self.hover = Util.pointInRect(x, y, self:getSliderX() - self.w/2, self:getSliderY(), self.w, self.h)
    end
end

function Slider:draw()
    --Draw slider box background
    local x_margin = 12
    local y_margin = 5
    love.graphics.setColor(255, 255, 255, 130)
    love.graphics.rectangle('fill', self.pos.x-x_margin, self.pos.y - y_margin, self.size+2*x_margin, self:height()+2*y_margin, 5)
    love.graphics.setColor(0, 0, 0, 60)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle('line', self.pos.x-x_margin, self.pos.y - y_margin, self.size+2*x_margin, self:height()+2*y_margin, 5)

    --Draw slider line
    local h = self.slider_line_h
    love.graphics.setColor(140, 191, 255)
    love.graphics.rectangle('fill', self.pos.x, self.pos.y-h/2 + self.slider_gap, self.size*self.value, h)
    love.graphics.setColor(196, 214, 237)
    love.graphics.rectangle('fill', self.pos.x+self.size*self.value, self.pos.y-h/2 + self.slider_gap, self.size*(1-self.value), h)
    love.graphics.setLineWidth(3)
    love.graphics.setColor(30, 30, 30)
    love.graphics.rectangle('line', self.pos.x, self.pos.y-h/2 + self.slider_gap, self.size, h)

    --Draw slider box
    love.graphics.setColor(37, 123, 237)
    love.graphics.rectangle('fill', self:getSliderX() - self.w/2, self:getSliderY(), self.w, self.h, 5)
    love.graphics.setLineWidth(3)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('line', self:getSliderX() - self.w/2, self:getSliderY(), self.w, self.h, 5)
    if self.hover then
        love.graphics.setColor(200, 200, 200, 80)
        love.graphics.rectangle('fill', self:getSliderX() - self.w/2, self:getSliderY(), self.w, self.h, 7)
    end
end

function Slider:getSliderX()
    return self.pos.x + self.size * self.value
end
function Slider:getSliderY()
    return self.pos.y-self.h/2 + self.slider_gap
end

function Slider:refresh()
    self.value = self.get_value()
end

function Slider:height()
    return self.h + self.slider_gap
end

-----------------------------

function SettingsTab:mousePressed(x, y, but)
    self.box:mousePressed(x, y, but)
end

function SettingsTab:mouseMoved(...)
    self.box:mouseMoved(...)
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
    for _, table in pairs(tab.options) do
        for _, o in pairs(table) do
            o:refresh()
        end
    end
end
