require "classes.primitive"
local Color = require "classes.color.color"

--PC-BOX CLASS--
-- Supposes only one instance is created

--PC-BOX functions table
local pcbox = {}
local button_tab_height = 30


-- Each tab, with their own update and draw
local inner_tab_border = 15
local tabs = {
    email = EmailTab(inner_tab_border, button_tab_height),
    code  = CodeTab(inner_tab_border, button_tab_height),
    info  = InfoTab(inner_tab_border, button_tab_height)
}

PcBox = Class{
    __includes = {RECT},

    init = function(self)
        local b = WIN_BORD

        --Saturation and lightness when a tab is focused
        self.focus_saturation = 100
        self.focus_lightness = 80
        --Saturation and lightness when a tab is not focused
        self.unfocus_saturation = 20
        self.unfocus_lightness = 40

        -- Current tab active
        self.cur_tab = "email"

        RECT.init(self, b, b, W - H - b, H - 2 * b, Color.transp())

        -- Tab buttons
        local h = button_tab_height
        self.buttons = {}
        self.buttons.email = But.create_gui(self.pos.x, self.pos.y, self.w / 3, h,
        function() self:changeTo "email" end, "email", FONTS.fira(20), nil, nil, Color.new(250,self.focus_saturation,self.focus_lightness))
        self.buttons.code = But.create_gui(self.pos.x + self.w / 3, self.pos.y, self.w / 3, h,
        function() self:changeTo "code" end, "terminal", FONTS.fira(20), nil, nil, Color.new(150,self.unfocus_saturation,self.unfocus_lightness))
        self.buttons.info = But.create_gui(self.pos.x + 2 * self.w / 3, self.pos.y, self.w / 3,
        h, function() self:changeTo "info" end, "info", FONTS.fira(20), nil, nil, Color.new(10,self.unfocus_saturation,self.unfocus_lightness))

        self.tp = "pcbox"
    end
}

function PcBox:draw()
    Color.set(self.buttons[self.cur_tab].color)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.w, self.h)
    tabs[self.cur_tab]:draw()
end

-- Change to that tab
function PcBox:changeTo(tab)
    if tab == self.cur_tab then return end
    tabs[self.cur_tab]:deactivate()
    self.buttons[self.cur_tab].color.s = self.unfocus_saturation
    self.buttons[self.cur_tab].color.l = self.unfocus_lightness

    tabs[tab]:activate()
    self.buttons[tab].color.s = self.focus_saturation
    self.buttons[tab].color.l = self.focus_lightness

    self.cur_tab = tab
end

function PcBox:keyPressed(key)
    tabs[self.cur_tab]:keyPressed(key)
end

function PcBox:textInput(t)
    tabs[self.cur_tab]:textInput(t)
end

--UTILITY FUNCTIONS--

function pcbox.create()
    local p

    p = PcBox()
    p:addElement(DRAW_TABLE.L1, nil, "pcbox")

    return p
end

return pcbox
