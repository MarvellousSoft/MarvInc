require "classes.primitive"
local Color = require "classes.color.color"
--PC-BOX CLASS--

--PC-BOX functions table
local pcbox = {}
local button_tab_height = 30

-- Each tab, with their own update and draw
local tabs = {email = {}, code = {}, info = {}}

PcBox = Class{
    __includes = {RECT},

    init = function(self)
        local b = WIN_BORD
        RECT.init(self, b, b, W - H - b, H - 2 * b, Color.red())

        self.current_tab = "email"

        -- Tab buttons
        local h = button_tab_height
        self.email_b = But.create_gui(self.pos.x, self.pos.y, self.w / 3, h,
        function() print "email" end, "email", FONTS.fira(20))
        self.code_b = But.create_gui(self.pos.x + self.w / 3, self.pos.y, self.w / 3, h,
        function() print "terminal" end, "terminal", FONTS.fira(20))
        self.info_b = But.create_gui(self.pos.x + 2 * self.w / 3, self.pos.y, self.w / 3,
        h, function() print "info" end, "info", FONTS.fira(20))

        self.tp = "pcbox"
    end
}

function PcBox:draw()
    local p

    p = self

end


--UTILITY FUNCTIONS--

function pcbox.create()
    local p

    p = PcBox()
    p:addElement(DRAW_TABLE.L1, nil, "pcbox")

    return r
end

return pcbox
