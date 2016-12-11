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

        -- Stencil function for scrolling
        self.stencil = function() love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.w, self.h) end

        -- Diference from the original vertical value position for first email (for scrolling)
        self.dy = 0

        -- Current number of emails
        self.email_cur = 0
        -- Maximum number of emails you can have on a screen
        self.email_on_screen = 16

        self.email_height = 35
        self.email_border = 5

        self.tp = "email_tab"
    end,

    -- Delete an email object mail from the email list
    deleteEmail = function(mail)
        local mail_list, tab

        tab = Util.findId("email_tab")

        mail_list = tab.email_list

        -- Shifts number of all emails greater than the mail to be deleted
        for i, m in ipairs(mail_list) do
            if m.number > mail.number then m.number = m.number - 1 end
        end

        --Remove mail from the list
        mail.handles["fadeout"] = MAIN_TIMER.tween(.5, mail, {alpha = 0, juicy_bump = -5}, 'out-cubic',
            function()
                -- Clear timer handles
                Util.clearTimerTable(mail.handles, MAIN_TIMER)
                -- Remove from email list
                table.remove(mail_list, mail.number)
                -- Update current number of emails
                tab.email_cur = tab.email_cur - 1
            end
        )

    end

}

function EmailTab:draw()
    local t, font, font_w, font_h, text, size, color

    t = self

    Color.set(t.main_color)

    love.graphics.rectangle("fill", t.pos.x, t.pos.y, t.w, t.h)

    -- Set stencil for the rectangle containing the code
    love.graphics.stencil(t.stencil, "replace", 1)
    -- Only allow rendering on pixels which have a stencil value greater than 0.
    love.graphics.setStencilTest("greater", 0)

    -- Draws email list
    for i,e in ipairs(t.email_list) do

        --Draw the email box
        if not e.was_read then
            color = Color.new(e.email_color)
        else
            color = Color.new(e.email_read_color)
        end
        --Set alpha
        color.a = e.alpha

        Color.set(color)
        love.graphics.rectangle("fill", t.pos.x + t.email_border, t.pos.y - t.dy*(t.email_height + t.email_border) + t.email_border*i+ t.email_height*(i-1) + e.juicy_bump, t.w-2*t.email_border, t.email_height)

        -- Timestamp on the email
        Color.set(Color.new(0, 80, 10,e.alpha))
        font = FONTS.fira(12)
        font_w = font:getWidth(e.time)
        love.graphics.setFont(font)
        love.graphics.print(e.time,  t.pos.x + t.w - t.email_border - font_w - 5, t.pos.y - t.dy*(t.email_height + t.email_border) + t.email_border*i+ t.email_height*(i-1)  + e.juicy_bump)

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
        love.graphics.print(text,  t.pos.x + t.email_border + 5, t.pos.y - t.dy*(t.email_height + t.email_border) + (t.email_height/2 - font_h/2) + t.email_border*i+ t.email_height*(i-1)  + e.juicy_bump)

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
        love.graphics.print(text,  t.pos.x + t.email_border + size, t.pos.y - t.dy*(t.email_height + t.email_border) + (t.email_height/2 - font_h/2) + t.email_border*i+ t.email_height*(i-1) + 2 + e.juicy_bump)

        if not e.was_read then
            love.graphics.setFont(FONTS.fira(15))
            Color.set(Color.new(240, 180, 120, e.alpha))
            love.graphics.print("new",  t.pos.x + t.email_border + 8, t.pos.y - t.dy*(t.email_height + t.email_border) - (t.email_height/2 - font_h/2) + t.email_border*i+ t.email_height*(i-1)  + e.juicy_bump)
        end
    end

    -- Remove stencil
    love.graphics.setStencilTest()

end

function EmailTab:mousePressed(x, y, but)
    local e, rect

    e = self

    if not e.email_opened and but == 1 then
        --Check mouse colision with emails
        for i, mail in ipairs(e.email_list) do
            if mail.alpha > 250 and Util.pointInRect(x,y,{pos = {x = e.pos.x + e.email_border, y = e.pos.y - e.dy*(e.email_height + e.email_border) + e.email_border*i+ e.email_height*(i-1)}, w = e.w-2*e.email_border, h = e.email_height}) then
                if not mail.was_read then
                    mail.was_read = true
                    UNREAD_EMAILS = UNREAD_EMAILS - 1
                end
                TABS_LOCK = true -- Lock tabs until email is closed
                e.email_opened = Opened.create(mail.number, mail.title, mail.text, mail.author, mail.time, mail.can_be_deleted, mail.reply_func, mail.can_reply)
            end
        end
    else
        Opened.mousePressed(x, y, but)
    end
end

function EmailTab:mouseScroll(x, y)
    local mx, my

    -- Just enable scroll if there is too much mail in the inbox and mouse is over the inbox screen
    if self.email_cur - self.email_on_screen <= 0 then return end
    mx, my = love.mouse.getPosition()

    if Util.pointInRect(mx, my, self) then
        self.dy = self.dy - y
    else
        return
    end

    self.dy = math.max(self.dy, 0)
    self.dy = math.min(self.dy, self.email_cur- self.email_on_screen)
end

-- EMAIL OBJECT --

EmailObject = Class{
    __includes = {},

    init = function(self, _title, _text, _author, _can_be_deleted, _reply_func, _number)
        local time

        self.number = _number

        self.title = _title -- Title of the email
        self.text = _text -- Body of email
        self.author = _author -- Who sent the email

        self.handles = {} -- Table containing timer handles related to this object

        self.alpha = 0 -- Alpha value of email color
        self.email_color = Color.new(0, 40, 200) -- Color of a new email
        self.email_read_color = Color.new(150, 30, 150) -- Color of a already read email

        self.juicy_bump = 5 -- Amount of bump the email travels when entering the inbox
        self.going_up_amount = 0 -- Amount to go up (for when an email above it is deleted)

        self.was_read = false -- If email was read
        self.can_be_deleted = _can_be_deleted or false -- If this email has a delete button
        self.reply_func = _reply_func -- Function to be called when replying te email (if nil wil not have a reply button on email)
        self.can_reply = true -- If email can be replyied

        -- Time the email was sent (Date (dd/mm/yy) and Time (hh:mm) AM/PM
        self.time = os.date("%x, %I:%M %p")

        self.tp = "email_object"
    end

}

-- UTILITY FUNCTIONS --

-- Creates a new email and add to the email list
function email_funcs.new(title, text, author, can_be_deleted, reply_func)
    local e, mail_list, number, tab

    tab = Util.findId("email_tab")

    mail_list = tab.email_list

    -- Increase number of current emails and update number for new email
    tab.email_cur = tab.email_cur + 1
    number = tab.email_cur

    e = EmailObject(title, text, author, can_be_deleted, reply_func, number)

    -- Add fade-in effect to email
    e.handles["fadein"] = MAIN_TIMER.tween(.5, e, {alpha = 255, juicy_bump = 0}, 'out-quad')

    table.insert(mail_list, e)

    UNREAD_EMAILS = UNREAD_EMAILS + 1

    return e
end

-- Get an email given his number
function email_funcs.get(number)
    return Util.findId("email_tab").email_list[number]
end

-- Get opened email, if any
function email_funcs.getOpened()
    return Util.findId("opened_email")
end

-- Disable reply in  a given email, and if he is opened, handle the opened email
function email_funcs.disableReply(number)
    local e, opened

    e, opened = email_funcs.get(number), email_funcs.getOpened()

    -- Disable reply on email
    if e then e.can_reply = false end

    -- Disable reply on opened
    if opened and opened.number == number then
        opened.can_reply = false
    end
end

-- Enable reply in  a given email, and if he is opened, handle the opened email
function email_funcs.enableReply(number)
    local e, opened

    e, opened = email_funcs.get(number), email_funcs.getOpened()

    -- Disable reply on email
    if e then e.can_reply = true end

    -- Disable reply on opened
    if opened and opened.number == number then
        opened.can_reply = true
    end
end



-- Return functions
return email_funcs
