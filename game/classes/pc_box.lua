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
            {"info", InfoTab(inner_tab_border, button_tab_height)}
        }
        PcBox.puzzle_tabs = {
            {"code", CodeTab(inner_tab_border, button_tab_height)},
            PcBox.menu_tabs[2]
        }

        --Saturation and lightness when a tab is focused
        self.focus_saturation = 180
        self.focus_lightness = 180
        --Saturation and lightness when a tab is not focused
        self.unfocus_saturation = 120
        self.unfocus_lightness = 80

        RECT.init(self, b, b, W - H - b, H - 2 * b, Color.transp())

        self:changeTabs(PcBox.menu_tabs, "email")

        self.tp = "pcbox"
        self:setId("pcbox")
    end
}

function PcBox:draw()
    Color.set(self.buttons[self.cur_tab].color)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y + button_tab_height, self.w, self.h - button_tab_height, 10)
    for _, b in pairs(self.buttons) do
        b:draw()
    end
    tabs[self.cur_tab]:draw()
end

function PcBox:changeTabs(new_tabs, default)
    if tabs_raw == new_tabs then return end
    if tabs and self.cur_tab then
        tabs[self.cur_tab]:deactivate()
    end
    tabs_raw = new_tabs
    tabs = {}

    -- Tab buttons
    local h = button_tab_height
    self.buttons = {}
    local x = self.pos.x
    for _, t in ipairs(tabs_raw) do
        tabs[t[1]] = t[2]
        self.buttons[t[1]] = But.create_tab(x, self.pos.y, self.w / #tabs_raw, h, function() self:changeTo(t[1]) end, t[1],
            FONTS.fira(20), nil, nil, Color.new(t[2].button_color, self.unfocus_saturation, self.unfocus_lightness, 70))
        x = x + self.w / #tabs_raw
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
    end

    tabs[tab]:activate()
    self.buttons[tab].color.s = self.focus_saturation
    self.buttons[tab].color.l = self.focus_lightness

    self.cur_tab = tab
end

function PcBox:keyPressed(key)
    if key == 'pagedown' then
        for i = 1, #tabs_raw do
            if tabs_raw[i][1] == self.cur_tab then
                self:changeTo(tabs[(i % #tabs_raw) + 1])
                break
            end
        end
    elseif key == 'pageup' then
        for i = 1, #tabs_raw do
            if tabs_raw[i][1] == self.cur_tab then
                self:changeTo(tabs[((i + #tabs_raw - 2) % #tabs_raw) + 1])
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
    if not TABS_LOCK and but == 1 then
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
