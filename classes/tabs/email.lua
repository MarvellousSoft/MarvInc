require "classes.primitive"
local Color = require "classes.color.color"
require "classes.tabs.tab"

-- EMAIL TAB CLASS--

local email_funcs = {}

EmailTab = Class{
    __includes = {Tab},

    init = function(self, eps, dy)
        Tab.init(self, eps, dy)

        self.email_list = {} -- List of email inbox
        self.main_color = Color.new(0, 90, 220)

        self.tp = "email_tab"
    end
}

function EmailTab:draw()
    local t
    local email_height, email_border = 30, 5

    t = self

    Color.set(t.main_color)

    love.graphics.rectangle("fill", t.pos.x, t.pos.y, t.w, t.h)

    love.graphics.setFont(FONTS.fira(12))

    for i,e in ipairs(t.email_list) do
        --Draw the email box
        Color.set(Color.blue())
        love.graphics.rectangle("fill", t.pos.x + email_border, t.pos.y + email_border*i+ email_height*(i-1), t.w-2*email_border, email_height)

        Color.set(Color.black())
        love.graphics.print(e.time,  t.pos.x + email_border, t.pos.y + email_border*i+ email_height*(i-1))
    end

end


-- EMAIL OBJECT --

EmailObject = Class{
    __includes = {},

    init = function(self, _title, _text, _author)
        local time

        self.title = _title -- Title of the email
        self.text = _text -- Body of email
        self.author = _author -- Who sent the email

        -- Time the email was sent (Date (dd//mm/yy) and Time (hh/mm/ss))
        self.time = os.date("%x, %I:%M %p")

        self.tp = "email_object"
    end

}

-- UTILITY FUNCTIONS --

-- Creates a new email and add to the email list
function email_funcs.new(title, text, author, time)
    local e

    e = EmailObject(title, text, author, time)
    table.insert(Util.findId("email_tab").email_list, e)

    return e
end

-- Return functions
return email_funcs
