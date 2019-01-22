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
require "classes.tabs.tab"
local Opened = require "classes.opened_email"
local ScrollWindow = require "classes.scroll_window"
local Util = require "util"

-- EMAIL TAB CLASS--

local email_funcs = {}

EmailTab = Class{
    __includes = {Tab},

    button_color = 250,

    init = function(self, eps, dy)
        Tab.init(self, eps, dy)

        self.name = "email"

        self.email_list = {} -- List of email inbox

        self.email_opened = nil -- If an email is opened

        self.main_color = Color.new(150, 30, 240, 60) -- Color of box behind

        -- Diference from the original vertical value position for first email (for scrolling)
        self.dy = 0

        -- Current number of emails
        self.email_cur = 0
        -- Maximum number of emails you can have on a screen
        self.email_on_screen = 16

        self.email_height = 35 --Height of each email box in the inbox
        self.email_border = 8 --Gap between emails on the inbox

        self.w = self.w - ScrollWindow.default_width / 2

        -- Used to work with ScrollWindow
        local obj = {
            getHeight = function()
                return (self.email_height + self.email_border) * self.email_cur - self.email_border
            end,
            draw = function(box) self:drawMailBox(box) end,
            mousePressed = function(o, ...) self:checkEmailClick(...) end,
            mouseMoved = function(box, x, y) box.last_mx, box.last_my = x, y end,
            pos = self.pos
        }
        self.mail_box = ScrollWindow(self.w, (self.email_height + self.email_border) * self.email_on_screen - self.email_border, obj, self.email_border + self.email_height)

        self.mail_box.color = {240, 240, 240}

        self.tp = "email_tab"
        self:setId("email_tab")
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
        mail.handles["fadeout"] = MAIN_TIMER:tween(.5, mail, {alpha = 0, juicy_bump = -5}, 'out-cubic',
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
    self.mail_box:draw() -- draws email box inside scroll window
end

function EmailTab:drawMailBox(box)
    local t, font, font_w, font_h, text, size, color

    t = self

    Color.set(t.main_color)

    -- Draws email list
    for index = Util.tableLen(t.email_list), 1, -1 do
        i = Util.tableLen(t.email_list) - index

        e = t.email_list[index]

        --Draw the email box
        if not e.was_read then
            color = Color.new(e.email_color)
        elseif not e.puzzle_id and not (e.reply_func and e.can_reply) then
            color = Color.new(e.email_read_color)
        elseif not e.puzzle_id and e.reply_func and e.can_reply then
            color = Color.new(e.email_reply_color)
        elseif e.puzzle_id and LoreManager.puzzle_done[e.puzzle_id] then
            color = Color.new(e.email_puzzle_complete_color)
        else
            color = Color.new(e.email_puzzle_uncompleted_color)
        end

        --Set alpha
        color.a = e.alpha

        --Draw email box (behind)
        local behind_color = Color.new(0,0, 40, e.alpha) --Color for box behind true email box
        Color.set(behind_color)
        local offset = 4
        love.graphics.rectangle("fill", t.pos.x + t.email_border - offset, t.pos.y + (t.email_border + t.email_height) * i + e.juicy_bump + offset, t.w - 2 * t.email_border, t.email_height, 2)
        --Draw email box (front)
        local mx, my = box.last_mx, box.last_my
        if not self.email_opened and mx and my and mx >= t.pos.x + t.email_border and
           mx <=  t.pos.x + t.email_border + t.w - 2 * t.email_border and
           my >= t.pos.y + (t.email_border + t.email_height) * i + e.juicy_bump and
           my <= t.pos.y + (t.email_border + t.email_height) * i + e.juicy_bump + t.email_height then
            color.l = color.l - 20 --Highlight email if mouse is over
        end
        Color.set(color)
        love.graphics.rectangle("fill", t.pos.x + t.email_border + 14, t.pos.y + (t.email_border + t.email_height) * i + e.juicy_bump, t.w - 2 * t.email_border - 14, t.email_height, 2)

        -- Draw author color box
        Color.set(e.author_color)
        love.graphics.rectangle("fill", t.pos.x + t.email_border, t.pos.y + (t.email_border + t.email_height) * i + e.juicy_bump, 10, t.email_height, 2)

        -- Timestamp on the email
        Color.set(Color.new(0, 80, 10,e.alpha))
        font = FONTS.fira(12)
        font_w = font:getWidth(e.time)
        love.graphics.setFont(font)
        love.graphics.print(e.time,  t.pos.x + t.w - t.email_border - font_w - 5, t.pos.y + (t.email_border + t.email_height) * i  + e.juicy_bump)

        -- Author
        font = FONTS.fira(16)
        if #e.author <= 12  then
            text = e.author.." | "
        else
            text = string.sub(e.author, 1, 9).."... | "
        end
        size = font:getWidth(text)
        font_h = font:getHeight(text)
        love.graphics.setFont(font)
        love.graphics.print(text,  t.pos.x + t.email_border + 5 + 14, t.pos.y + (t.email_height/2 - font_h/2) + (t.email_border + t.email_height) * i  + e.juicy_bump)

        -- Title
        font = FONTS.fira(14)
        text = e.title
        if #text <= 29  then
            text = e.title
        else
            text = string.sub(text, 1, 26).."..."
        end
        font_w = size + font:getWidth(text)
        font_h = font:getHeight(text)
        love.graphics.setFont(font)
        love.graphics.print(text,  t.pos.x + t.email_border + size + 14, t.pos.y + (t.email_height/2 - font_h/2) + (t.email_border + t.email_height) * i + 2 + e.juicy_bump)

        -- Print label on emails

        -- New
        text = nil
        if not e.was_read then
            text = "new"
            Color.set(Color.new(240, 180, 120, e.alpha))
        elseif e.puzzle_id then
            Color.set(Color.new(150, 140, 60, e.alpha))
            if LoreManager.puzzle_done[e.puzzle_id] then
                text = "completed"
            else
                text = "not completed"
            end
        end
        if text then
            font = FONTS.fira(15)
            love.graphics.setFont(font)
            love.graphics.print(text,  t.pos.x + t.email_border + t.w - 25 - font:getWidth(text), t.pos.y + (t.email_border + t.email_height) * i  + e.juicy_bump + 15)
        end
    end

end

function EmailTab:keyPressed(key)
    if key == "up" then
        self.mail_box:translateScreen(-self.mail_box.scroll_min)
    elseif key == "down" then
        self.mail_box:translateScreen(self.mail_box.scroll_min)
    elseif key == "pageup" then
        self.mail_box:translateScreen(-self.mail_box.scroll_in * self.email_on_screen)
    elseif key == "pagedown" then
        self.mail_box:translateScreen(self.mail_box.scroll_in * self.email_on_screen)
    end

    if Util.findId('opened_email') then
        Util.findId('opened_email'):keyPressed(key)
    end

end

function EmailTab:mouseMoved(...)
    (Util.findId('opened_email') or self.mail_box):mouseMoved(...)
end

function EmailTab:openEmail(mail)
    local e = self
    self.mail_box.last_mx, self.mail_box.last_my = nil, nil -- remove hover effect
    TABS_LOCK = TABS_LOCK + 1 -- Lock tabs until email is closed

    e.email_opened = Opened.create(mail.number, mail.title, mail.text, mail.author, mail.time, mail.can_be_deleted, mail.reply_func, mail.can_reply, mail.image)
    e.email_opened.is_custom = mail.is_custom
    if not mail.was_read then
        -- this needs to be done after the email is 'registered' or it won't be able to access it.
        if mail.open_func then mail:open_func() end
        mail.was_read = true
        UNREAD_EMAILS = UNREAD_EMAILS - 1
    end
    return e.email_opened
end

-- Check mouse colision with emails
function EmailTab:checkEmailClick(x, y, but)
    local e, rect

    e = self

    local number_emails = Util.tableLen(e.email_list)
    if but == 1 and not self.mail_box.on_hover then -- if not clicking scroll bar
        for i, mail in ipairs(e.email_list) do
            if mail.alpha > 250 and Util.pointInRect(x , y, {pos = {x = e.pos.x + e.email_border, y = e.pos.y + (e.email_border + e.email_height) * (number_emails - i)}, w = e.w - 2 * e.email_border, h = e.email_height}) then
                self:openEmail(mail)
            end
        end
    end
end

function EmailTab:mousePressed(...)
    (Util.findId('opened_email') or self.mail_box):mousePressed(...)
end

function EmailTab:mouseReleased(...)
    (Util.findId('opened_email') or self.mail_box):mouseReleased(...)
end

function EmailTab:mouseScroll(...)
    (Util.findId('opened_email') or self.mail_box):mouseScroll(...)
end

function EmailTab:mouseMoved(...)
    local o = Util.findId('opened_email')
    if o then o:mouseMoved(...) end
    self.mail_box.last_mx, self.mail_box.last_my = nil, nil
    self.mail_box:mouseMoved(...)
end

function EmailTab:update(...)
    (Util.findId('opened_email') or self.mail_box):update(...)
end



-- EMAIL OBJECT --

EmailObject = Class{
    __includes = {},

    init = function(self, _id, _title, _text, _author, _can_be_deleted, _puzzle_id, _open_func, _reply_func, _number, _image, _custom)
        local time

        self.number = _number
        self.id = _id
        self.is_custom = _custom

        self.title = _title -- Title of the email
        self.text = _text -- Body of email
        self.author = _author -- Who sent the email
        self.author_color = Util.getAuthorColor(self.author)

        self.handles = {} -- Table containing timer handles related to this object

        self.alpha = 0 -- Alpha value of email color
        self.email_color = Color.new(0,0,240) -- Color of a new email
        self.email_read_color = Color.new(150, 30, 170) -- Color of a already read email
        self.email_reply_color = Color.new(46, 100, 80, 255, "hsl", true) -- Color of an important email with reply
        self.email_puzzle_complete_color = Color.new(70, 150, 200) -- Color of an completed puzzle
        self.email_puzzle_uncompleted_color = Color.new(250, 140, 200) -- Color of an uncompleted puzzle

        self.juicy_bump = 5 -- Amount of bump the email travels when entering the inbox
        self.going_up_amount = 0 -- Amount to go up (for when an email above it is deleted)

        self.was_read = false -- If email was read
        self.can_be_deleted = _can_be_deleted or false -- If this email has a delete button
        self.open_func = _open_func -- called when this email is opened for the first time (looses its 'unread')
        self.puzzle_id = _puzzle_id -- the id of the puzzle this email opens, or nil if it does not open one
        if _puzzle_id and not _reply_func then _reply_func = function() end end
        self.reply_func = _reply_func -- Function to be called when replying te email (if nil wil not have a reply button on email)
        self.can_reply = true -- If email can be replyied

        -- Time the email was sent (Date (dd/mm/yy) and Time (hh:mm) AM/PM
        self.time = os.date("%I:%M %p")

        self.image = _image --Optional image the email can have

        self.tp = "email_object"
    end

}

-- UTILITY FUNCTIONS --


function email_funcs.get_raw_email(id, number)
    local e = require('emails.' .. id)

    local email = EmailObject(id, e.title, e.text, e.author, e.can_be_deleted, e.puzzle_id, e.open_func, e.reply_func, number, e.image)

    return email
end

-- Creates a new custom email and adds it to the mail list.
function email_funcs.new_custom(silent, id, title, text, author, delete, p_id, open_f, reply_f, img)
    local mail_list, number, tab

    tab = Util.findId("email_tab")

    mail_list = tab.email_list

    -- Increase number of current emails and update number for new email
    tab.email_cur = tab.email_cur + 1
    n = tab.email_cur

    local email = EmailObject(id, title, text, author, delete, p_id, open_f, reply_f, n, img, true)

    -- Add fade-in effect to email
    email.handles["fadein"] = MAIN_TIMER:tween(.5, email, {alpha = 255, juicy_bump = 0}, 'out-quad')

    table.insert(mail_list, email)

    UNREAD_EMAILS = UNREAD_EMAILS + 1

    if not silent then
        SFX.new_email:stop()
        SFX.new_email:play()
    end

    return email
end

-- Creates a new email and add to the email list
function email_funcs.new(id, silent)

    local mail_list, number, tab

    tab = Util.findId("email_tab")

    mail_list = tab.email_list

    -- Increase number of current emails and update number for new email
    tab.email_cur = tab.email_cur + 1
    number = tab.email_cur

    local email = email_funcs.get_raw_email(id, number)

    -- Add fade-in effect to email
    email.handles["fadein"] = MAIN_TIMER:tween(.5, email, {alpha = 255, juicy_bump = 0}, 'out-quad')

    table.insert(mail_list, email)

    UNREAD_EMAILS = UNREAD_EMAILS + 1

    if not silent then
        SFX.new_email:stop()
        SFX.new_email:play()
    end

    return email
end

-- Deletes emails with given authors
-- Must not be called when an email is open
function email_funcs.deleteAuthor(author)
    local tab = Util.findId('email_tab')
    local tmp, mail_list = {}, tab.email_list
    -- swapping contents of table
    for a, b in pairs(mail_list) do
        tmp[a] = b
        mail_list[a] = nil
    end

    tab.email_cur = 0
    for _, e in ipairs(tmp) do
        if author ~= e.author then
            tab.email_cur = tab.email_cur + 1
            e.number = tab.email_cur
            table.insert(mail_list, e)
        end
    end
    UNREAD_EMAILS = email_funcs.getUnreadEmails()

end

-- Returns whether an email with given title exists.
function email_funcs.exists(title)
    local list = Util.findId('email_tab').email_list
    for _, e in pairs(list) do
        if e.title == title then
            return true
        end
    end
    return false
end

-- Returns whether an email with given Id exists.
function email_funcs.existsId(id)
    local list = Util.findId('email_tab').email_list
    for _, e in pairs(list) do
        if e.id == id then
            return true
        end
    end
    return false
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

--Iterate through emails and return number on unread emails
function email_funcs.getUnreadEmails()
    local unread = 0

    local t = Util.findId("email_tab")

    if not t then return 0 end

    for i,e in ipairs(t.email_list) do
        if not e.was_read then
            unread = unread + 1
        end
    end

    return unread
end



-- Return functions
return email_funcs
