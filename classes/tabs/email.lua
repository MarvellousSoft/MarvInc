require "classes.primitive"
local Color = require "classes.color.color"
require "classes.tabs.tab"
local Opened = require "classes.opened_email"

-- EMAIL TAB CLASS--

local email_funcs = {}

EmailTab = Class{
    __includes = {Tab},

    init = function(self, eps, dy)
        Tab.init(self, eps, dy)

        self.email_list = {} -- List of email inbox

        self.email_opened = nil -- If an email is opened

        self.main_color = Color.new(150, 30, 240) -- Color of box behind

        self.email_height = 35
        self.email_border = 5

        self.tp = "email_tab"
    end,

    deleteEmail = function(mail)
        local mail_list

        mail_list = Util.findId("email_tab").email_list
        -- Shifts number of all emails greater than the mail to be deleted
        for i, m in ipairs(mail_list) do
            if m.number > mail.number then m.number = m.number - 1 end
        end

        --Remove mail from the list
        table.remove(mail_list, mail.number)

    end

}

function EmailTab:draw()
    local t, font, font_w, font_h, text, size

    t = self

    Color.set(t.main_color)

    love.graphics.rectangle("fill", t.pos.x, t.pos.y, t.w, t.h)

    -- Draws email list
    for i,e in ipairs(t.email_list) do
        --Draw the email box
        if not e.was_read then
            Color.set(e.email_color)
        else
            Color.set(e.email_read_color)
        end
        love.graphics.rectangle("fill", t.pos.x + t.email_border, t.pos.y + t.email_border*i+ t.email_height*(i-1), t.w-2*t.email_border, t.email_height)

        -- Timestamp on the email
        Color.set(Color.new(0, 80, 10))
        font = FONTS.fira(12)
        font_w = font:getWidth(e.time)
        love.graphics.setFont(font)
        love.graphics.print(e.time,  t.pos.x + t.w - t.email_border - font_w - 5, t.pos.y + t.email_border*i+ t.email_height*(i-1))

        -- Author
        font = FONTS.fira(16)
        if #e.author <= 9  then
            text = e.author.." | "
        else
            text = string.sub(e.author, 1, 9).."... | "
        end
        size = font:getWidth(text)
        font_h = font:getHeight(text)
        love.graphics.setFont(font)
        love.graphics.print(text,  t.pos.x + t.email_border + 5, t.pos.y + (t.email_height/2 - font_h/2) + t.email_border*i+ t.email_height*(i-1))

        -- Title

        font = FONTS.fira(14)
        text = e.title
        if #text <= 30  then
            text = e.title
        else
            text = string.sub(text, 1, 30).."..."
        end
        font_w = size + font:getWidth(text)
        font_h = font:getHeight(text)
        love.graphics.setFont(font)
        love.graphics.print(text,  t.pos.x + t.email_border + size, t.pos.y + (t.email_height/2 - font_h/2) + t.email_border*i+ t.email_height*(i-1) + 2)

        if not e.was_read then
            love.graphics.setFont(FONTS.fira(15))
            Color.set(Color.new(240, 2000, 80))
            love.graphics.print("new",  t.pos.x + t.email_border + 8, t.pos.y - (t.email_height/2 - font_h/2) + t.email_border*i+ t.email_height*(i-1))
        end
    end

end

function EmailTab:mousePressed(x, y, but)
    local e, rect

    e = self

    if not e.email_opened and but == 1 then
        --Check mouse colision with emails
        for i, mail in ipairs(e.email_list) do
            if Util.pointInRect(x,y,{pos = {x = e.pos.x + e.email_border, y = e.pos.y + e.email_border*i+ e.email_height*(i-1)}, w = e.w-2*e.email_border, h = e.email_height}) then
                if not mail.was_read then
                    mail.was_read = true
                    UNREAD_EMAILS = UNREAD_EMAILS - 1
                end
                TABS_LOCK = true -- Lock tabs until email is closed
                e.email_opened = Opened.create(mail.number, mail.title, mail.text, mail.author, mail.time, mail.can_be_deleted)
            end
        end
    else
        Opened.mousePressed(x, y, but)
    end
end

-- EMAIL OBJECT --

EmailObject = Class{
    __includes = {},

    init = function(self, _title, _text, _author, _can_be_deleted, _number)
        local time

        self.number = _number

        self.title = _title -- Title of the email
        self.text = _text -- Body of email
        self.author = _author -- Who sent the email

        self.email_color = Color.new(0, 40, 200) -- Color of a new email
        self.email_read_color = Color.new(150, 30, 150) -- Color of a already read email

        self.was_read = false -- If email was read
        self.can_be_deleted = _can_be_deleted or false -- If this email has a delete button

        -- Time the email was sent (Date (dd/mm/yy) and Time (hh:mm) AM/PM
        self.time = os.date("%x, %I:%M %p")

        self.tp = "email_object"
    end

}

-- UTILITY FUNCTIONS --

-- Creates a new email and add to the email list
function email_funcs.new(title, text, author, can_be_deleted, number)
    local e, mail_list, number

    mail_list = Util.findId("email_tab").email_list

    number = Util.tableLen(mail_list) + 1

    e = EmailObject(title, text, author, can_be_deleted, number)
    table.insert(mail_list, e)

    UNREAD_EMAILS = UNREAD_EMAILS + 1

    return e
end

-- Return functions
return email_funcs
