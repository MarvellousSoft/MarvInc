require "classes.primitive"
local Color = require "classes.color.color"
local Button = require "classes.button"
--PC-BOX CLASS--

--PC-BOX functions table
local pcbox = {}
local button_tab_height = 30

-- Each tab, with their own update and draw
local tabs = {email = {}, code = {}, info = {}}

PcBox = Class{
    __includes = {RECT},

    init = function(self)
        local b = 20

        RECT.init(self, b, b, W - H - b, H - 2 * b, Color.red())

        --
        self.current_tab = "email"

        -- Tab buttons
        local h = button_tab_height
        self.email_b = Button.create_gui(self.pos.x, self.pos.y, self.w / 3, h,
        function() print "email" end, "email", FONTS.fira(20))
        self.code_b = Button.create_gui(self.pos.x + self.w / 3, self.pos.y, self.w / 3, h,
        function() print "terminal" end, "terminal", FONTS.fira(20))
        self.info_b = Button.create_gui(self.pos.x + 2 * self.w / 3, self.pos.y, self.w / 3,
        h, function() print "info" end, "info", FONTS.fira(20))

        self.tp = "pcbox"
    end
}

function PcBox:draw()
    local p

    p = self

    tabs[p.current_tab].draw()

end

--EMAIL Tab

tabs.email.draw = function()

    Color.set(Color.green())
    love.graphics.rectangle("fill", p.pos.x, p.pos.y, p.w, p.h)

end

tabs.email.update = function()

end


--CODE Tab

tabs.code.draw = function()

    Color.set(Color.orange())
    love.graphics.rectangle("fill", p.pos.x, p.pos.y, p.w, p.h)

end

tabs.code.update = function()

end


--INFO Tab

tabs.info.draw = function()

    Color.set(Color.blue())
    love.graphics.rectangle("fill", p.pos.x, p.pos.y, p.w, p.h)

end

tabs.info.update = function()

end

--UTILITY FUNCTIONS--

function pcbox.create()
    local p

    p = PcBox()
    p:addElement(DRAW_TABLE.L1, nil, "pcbox")

    return r
end

return pcbox
