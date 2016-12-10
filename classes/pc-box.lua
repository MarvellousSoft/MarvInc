require "classes.primitive"
local Color = require "classes.color.color"

--PC-BOX CLASS--

--PC-BOX functions table
local pcbox = {}
local button_tab_height = 30

local focus_color = Color.new(150, 0, 80)

-- Each tab, with their own update and draw
local inner_tab_border = 15
local tabs = {
    email = EmailTab(focus_color, inner_tab_border, button_tab_height),
    code  = CodeTab(focus_color, inner_tab_border, button_tab_height),
    info  = InfoTab(focus_color, inner_tab_border, button_tab_height)
}

PcBox = Class{
    __includes = {RECT},

    init = function(self)
        local b = WIN_BORD

        self.focus_color = focus_color
        self.unfocus_color = Color.new()
        Color.copy(self.unfocus_color, self.focus_color)
        self.unfocus_color.l = self.focus_color.l / 2

        RECT.init(self, b, b, W - H - b, H - 2 * b, self.focus_color)

        self.cur_tab = "email"

        -- Tab buttons
        local h = button_tab_height
        self.buttons = {}
        self.buttons.email = But.create_gui(self.pos.x, self.pos.y, self.w / 3, h,
        function() self:changeTo "email" end, "email", FONTS.fira(20), nil, nil, self.focus_color)
        self.buttons.code = But.create_gui(self.pos.x + self.w / 3, self.pos.y, self.w / 3, h,
        function() self:changeTo "code" end, "terminal", FONTS.fira(20), nil, nil, self.unfocus_color)
        self.buttons.info = But.create_gui(self.pos.x + 2 * self.w / 3, self.pos.y, self.w / 3,
        h, function() self:changeTo "info" end, "info", FONTS.fira(20), nil, nil, self.unfocus_color)

        self.tp = "pcbox"
    end
}

function PcBox:draw()
    Color.set(self.focus_color)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.w, self.h)
    tabs[self.cur_tab]:draw()
end

-- Change to that tab
function PcBox:changeTo(tab)
    if tab == self.cur_tab then return end
    tabs[self.cur_tab]:deactivate()
    self.buttons[self.cur_tab].color = self.unfocus_color

    tabs[tab]:activate()
    self.buttons[tab].color = self.focus_color

    self.cur_tab = tab
end

--UTILITY FUNCTIONS--

function pcbox.create()
    local p

    p = PcBox()
    p:addElement(DRAW_TABLE.L1, nil, "pcbox")

    return r
end

return pcbox
