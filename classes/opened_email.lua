cdrequire "classes.primitive"
local Color = require "classes.color.color"
require "classes.tabs.tab"

-- OPENED EMAIL CLASS--

local opened_email_funcs = {}

OpenedEmail = Class{
    __includes = {},

    init = function(self, _title, _text, _author, _time)
        local time

        self.title = _title -- Title of the email
        self.text = _text -- Body of email
        self.author = _author -- Who sent the email
        self.time = _time -- Time the email was sent

        self.main_color = Color.new(150, 30, 240) -- Color of box behind

        self.tp = "email_object"
    end

}

-- Draws opened email --
function OpenedEmail:draw()
    local e

    e = self

    --Draws black effect

    --Draws email box
    local box_width, box_height = W/3, H/3
    Color.set(t.main_color)
    love.graphics.rectangle("fill", t.pos.x + (t.w/2 - box_width/2),  t.pos.y + (t.h/2 - box_height/2), box_width, box_height)
    love.graphics.setLineWidth(5)
    Color.set(Color.new(0,0,30))
    love.graphics.rectangle("line", t.pos.x + (t.w/2 - box_width/2),  t.pos.y + (t.h/2 - box_height/2), box_width, box_height)

end
