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

--PC_BOX CLASS--
-- Supposes only one instance is created

--PC_BOX functions table
local pcbox = {}
local button_tab_height = 30


-- Each tab, with their own update and draw
local inner_tab_border = 15

local tabs, tabs_raw = nil, nil

PcBox = Class{
    __includes = {RECT},


    init = function(self)
        local b = WIN_BORD
        PcBox.menu_tabs = {
            {"email", EmailTab(inner_tab_border, button_tab_height)},
            {"manual", ManualTab(inner_tab_border, button_tab_height)},
            {"puzzles", PuzzleListTab(inner_tab_border, button_tab_height)},
            {"settings", SettingsTab(inner_tab_border, button_tab_height)},
        }
        PcBox.puzzle_tabs = {
            PcBox.menu_tabs[1],
            {"code", CodeTab(inner_tab_border, button_tab_height)},
            {"info", InfoTab(inner_tab_border, button_tab_height)},
            PcBox.menu_tabs[2],
            PcBox.menu_tabs[3],
        }

        --Saturation and lightness when a tab is focused
        self.focus_saturation = 250
        self.focus_lightness = 170
        --Saturation and lightness when a tab is not focused
        self.unfocus_saturation = 120
        self.unfocus_lightness = 80

        RECT.init(self, b, b, W - H - b, H - 2 * b, Color.transp())

        self.new_email_rotation = 0 --Rotation of "new email" text
        --Function that creates the "Jinglying" effect
        self.new_email_effect = function()
            local half_shake_time = .06 --Time to half-jiggle
            local half_shake_rotation = math.pi/7

            --Half jiggle first time shifting clockwise
            self.new_email_timer_handle = MAIN_TIMER:tween(half_shake_time, self, {new_email_rotation = half_shake_rotation}, "in-linear",
                    function()

                        --Half jiggle second time shifting counterclockwise
                        self.new_email_timer_handle = MAIN_TIMER:tween(2*half_shake_time, self, {new_email_rotation = -half_shake_rotation}, "in-linear",
                            function()

                                --Half jiggle third time shifting clockwise
                                self.new_email_timer_handle = MAIN_TIMER:tween(2*half_shake_time, self, {new_email_rotation = half_shake_rotation}, "in-linear",
                                    function()

                                        --Half jiggle fourth time shifting counterclockwise
                                        self.new_email_timer_handle = MAIN_TIMER:tween(2*half_shake_time, self, {new_email_rotation = -half_shake_rotation}, "in-linear",
                                            function()

                                                --Half jiggle final time shifting clockwise to the center
                                                self.new_email_timer_handle = MAIN_TIMER:tween(half_shake_time, self, {new_email_rotation = 0}, "in-linear",
                                                    function()

                                                        --Stay halted for some time before restarting the effect
                                                        self.new_email_timer_handle = MAIN_TIMER:after(12*half_shake_time, self.new_email_effect)

                                                    end)
                                            end)
                                    end)
                            end)
                    end)

        end

        --Start effect
        self.new_email_effect()

        self:changeTabs(PcBox.menu_tabs, "email")

        self.tp = "pcbox"
        self:setId("pcbox")
    end
}

function PcBox:draw()


    --Draw tabs buttons in the upper part of the pc box, but draw current tab for last, after drawing the background of pc-box
    for _, b in pairs(self.buttons) do
        if not (b == self.buttons[self.cur_tab]) then
            b:draw()
        end
    end

    --Draw background of pc-box (back)--
    --Creating stencil so it doesn't draw in the same area as the actual pc-box
    local stencil = function () love.graphics.rectangle("fill", self.pos.x, self.pos.y + button_tab_height, self.w, self.h - button_tab_height) end
    love.graphics.stencil(stencil, "replace", 1)
    love.graphics.setStencilTest("notequal", 1)

    local back_color = Color.new(self.buttons[self.cur_tab].color)
    back_color.l = 20
    Color.set(back_color)
    local offset = 3
    love.graphics.rectangle("fill", self.pos.x - offset, self.pos.y + button_tab_height - offset, self.w + 2*offset, self.h - button_tab_height + 2*offset)

    love.graphics.setStencilTest()

    --Draw background of pc-box (front)--
    Color.set(Color.new(tabs[self.cur_tab].button_color, self.focus_saturation, self.focus_lightness * (tabs[self.cur_tab].lightness_mod or 1), 80))
    love.graphics.rectangle("fill", self.pos.x, self.pos.y + button_tab_height, self.w, self.h - button_tab_height)

    --Draw current tab button
    self.buttons[self.cur_tab]:draw()


    --Display unread emails notification
    if  UNREAD_EMAILS > 0 then
        local text --Text will be just "!"
        local ajust_x = 0 --Ajust position of text if inside a puzzle
        text = "!"
        ajust_x = -45
        local font = FONTS.fira(22)
        local fx = font:getWidth(text)
        local fy = font:getHeight(text)
        local x, y = self.pos.x + 80, self.pos.y + 28
        --Arruma as posições certas do x e y de acordo com o tamanho do certo para o novo offset
        --(o texto tera seu offset no centro para poder fazer o efeito de "jiggle")
        x = x - fx/2 + ajust_x
        y = y - fy/2

        -- Draw "new email' text
        Color.set(Color.new(126,98,53,255,"hsl", true))
        love.graphics.setFont(font)
        love.graphics.print(text, x, y, self.new_email_rotation, 1, 1, fx/2, fy/2)
    end

    --Draw current opened tab
    tabs[self.cur_tab]:draw()
end

function PcBox:changeTabs(new_tabs, default)
    if tabs_raw == new_tabs then self:changeTo(default) return end
    if tabs and self.cur_tab then
        tabs[self.cur_tab]:deactivate()
    end
    tabs_raw = new_tabs
    tabs = {}

    -- Tab buttons
    local h = button_tab_height
    self.buttons = {}
    local x = self.pos.x
    local set_size = 28
    for _, t in ipairs(tabs_raw) do
        tabs[t[1]] = t[2]
        if _ == #tabs_raw then
            self.buttons[t[1]] = ImgButton(x, self.pos.y, set_size, BUTS_IMG.settings, function() self:changeTo(t[1]) end)
        else
            self.buttons[t[1]] = But.create_tab(x, self.pos.y, (self.w - set_size) / (#tabs_raw - 1), h, function() self:changeTo(t[1]) end,
                t[1], FONTS.fira(20), nil, nil, Color.new(t[2].button_color, self.unfocus_saturation, self.unfocus_lightness, 80))
            x = x + (self.w - set_size) / (#tabs_raw - 1)
        end
    end

    self.cur_tab = nil
    self:changeTo(default)
end

-- Change to that tab
function PcBox:changeTo(tab)
    if tab == self.cur_tab then return end
    SFX.tab_switch:play()

    if self.cur_tab then
        tabs[self.cur_tab]:deactivate()
        self.buttons[self.cur_tab].color.s = self.unfocus_saturation
        self.buttons[self.cur_tab].color.l = self.unfocus_lightness
        self.buttons[self.cur_tab].is_current_tab = false
    end

    tabs[tab]:activate()
    self.buttons[tab].color.s = self.focus_saturation
    self.buttons[tab].color.l = self.focus_lightness * (tabs[tab].lightness_mod or 1)
    self.buttons[tab].is_current_tab = true

    self.cur_tab = tab
end

function PcBox:keyPressed(key)
    if key == 'pagedown' then
        for i = 1, #tabs_raw do
            if tabs_raw[i][1] == self.cur_tab then
                self:changeTo(tabs_raw[(i % #tabs_raw) + 1][1])
                break
            end
        end
    elseif key == 'pageup' then
        for i = 1, #tabs_raw do
            if tabs_raw[i][1] == self.cur_tab then
                self:changeTo(tabs_raw[((i + #tabs_raw - 2) % #tabs_raw) + 1][1])
                break
            end
        end
    else
        tabs[self.cur_tab]:keyPressed(key)
    end
end

function PcBox:textInput(t)
    tabs[self.cur_tab]:textInput(t)
end

function PcBox:mousePressed(x, y, but)
    tabs[self.cur_tab]:mousePressed(x, y, but)
    if TABS_LOCK == 0 and but == 1 then
        for _, b in pairs(self.buttons) do
            b:checkCollides(x, y)
        end
    end
end

function PcBox:mouseReleased(x, y, but)
    tabs[self.cur_tab]:mouseReleased(x, y, but)
end

function PcBox:mouseScroll(x, y)
    tabs[self.cur_tab]:mouseScroll(x, y)
end

function PcBox:update(dt)
    tabs[self.cur_tab]:update(dt)
    self.buttons.email:update(dt) --Update "new email" notification effect
end

function PcBox:mouseMoved(x, y)
    tabs[self.cur_tab]:mouseMoved(x, y)
end

--UTILITY FUNCTIONS--

function pcbox.create()
    local p

    p = PcBox()
    p:addElement(DRAW_TABLE.L1, nil, "pcbox")

    return p
end

return pcbox
