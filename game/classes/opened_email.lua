local Color = require "classes.color.color"
local ScrollWindow = require "classes.scroll_window"

-- OPENED EMAIL CLASS--

local opened_email_funcs = {}

local function height(font, text, limit)
    local w, txt = font:getWrap(text, limit)
    return (#txt) * font:getHeight()
end

OpenedEmail = Class{
    __includes = {RECT},

    init = function(self, _number, _title, _text, _author, _time, _can_be_deleted, _reply_func, _can_reply)
        local time
        local box_width, box_height = 2.2*W/5, 4*H/5

        self.text_font = FONTS.robotoLight(18)

        local but_size = (_reply_func and 50 or 0) + (_can_be_deleted and 50 or 0)

        RECT.init(self, W/2 - box_width/2,  H/2 - box_height/2, box_width, box_height, Color.new(150, 0, 240))

        self.number = _number --Number of email
        self.title = _title -- Title of the email
        self.text = _text -- Body of email
        self.author = _author -- Who sent the email
        self.time = _time -- Time the email was sent

        -- Text ScrollWindow

        self.text_height = height(self.text_font, _text, self.w - 20)
        local obj = {
            getHeight = function() return self.text_height end,
            draw = function(o) love.graphics.printf(self.text, o.pos.x, o.pos.y, self.w - 20) end,
            pos = Vector(self.pos.x + 10, self.pos.y + 110)
        }

        self.text_scroll = ScrollWindow(self.w - 20, 21 * self.text_font:getHeight(), obj, self.text_font:getHeight())

        self.can_be_deleted = _can_be_deleted -- If email can be deleted
        self.delete_button_color = Color.new(0,80,120) --Color for delete button box
        self.delete_button_text_color = Color.new(0,0,250) --Color for delete button text
        self.delete_x = self.pos.x + self.w/2 - 25 -- X position value of delete button (related to opened email pos)
        self.delete_y = self.pos.y + self.h - 60 -- Y position value of delete button (related to opened email pos)
        self.delete_w = 70 -- Width value of delete button
        self.delete_h = 30 -- Height value of delete button

        self.retry_button_color = Color.new(70,80,120) --Color for retry button box when opening an already completed puzzle

        self.reply_button_enabled_color = Color.new(150,80,120) --Color for reply button box when enabled
        self.reply_button_enabled_text_color = Color.new(0,0,250) --Color for reply button text when enabled
        self.reply_button_disabled_color = Color.new(0,0,80) --Color for reply button box when disabled
        self.reply_button_disabled_text_color = Color.new(0,0,0) --Color for reply button text when disabled
        self.reply_func = _reply_func -- Function to be called when you reply the email (if nil there won't be a reply button)
        self.can_reply = _can_reply -- If the reply button is enabled
        self.reply_x = self.pos.x + self.w/2 - 25 -- X position value of reply button (related to opened email pos)
        self.reply_y = self.pos.y + self.h - 100 -- Y position value of reply button (related to opened email pos)
        self.reply_w = 70 -- Width value of reply button
        self.reply_h = 30 -- Height value of reply button

        self.line_color = Color.new(150,180,60) -- Color for line outlining the email box and below title
        self.line_color_2 = Color.new(150,100,60) -- Color for line below author of email
        self.line_color_3 = Color.new(0,30,20) -- Color for outlining delete button
        self.background_color = Color.new(0,0,40,140) -- Black effect for background
        self.title_color = Color.new(150,180,80) -- Color for title
        self.content_color = Color.new(0,0,0) -- Color for rest of email content

        self.referenced_email =  Util.findId("email_tab").email_list[self.number]

        self.tp = "opened_email"
    end

}

-- Draws opened email --
function OpenedEmail:draw()
    local e, font, font_w, font_h, font_size, temp, text
    local referenced_email


    e = self
    referenced_email = e.referenced_email

    -- Draws black effect
    Color.set(e.background_color)
    love.graphics.rectangle("fill", 0, 0, W, H)

    -- Draws email box
    Color.set(e.color)
    love.graphics.rectangle("fill", e.pos.x, e.pos.y, e.w, e.h)
    love.graphics.setLineWidth(2)
    Color.set(e.line_color)
    love.graphics.rectangle("line", e.pos.x, e.pos.y, e.w, e.h)

    -- Draw email content

    -- Title
    Color.set(e.title_color)
    font_size = 24
    font = FONTS.robotoBold(font_size)
    while font:getWidth(e.title) > e.w - 20 do
        font_size = font_size - 1
        font = FONTS.fira(font_size)
    end
    font_h = font:getHeight(e.title)
    temp = font_h
    love.graphics.setFont(font)
    love.graphics.print(e.title,  e.pos.x + 10, e.pos.y + 10)
    -- Draw line
    love.graphics.setLineWidth(5)
    Color.set(e.line_color)
    love.graphics.line(e.pos.x + 10, e.pos.y + 10 + font_h + 5, e.pos.x + e.w - 10, e.pos.y + 10 + font_h + 5)

    -- Author
    Color.set(e.content_color)
    font = FONTS.roboto(20)
    font_h = font:getHeight(e.title)
    love.graphics.setFont(font)
    love.graphics.print("from: "..e.author,  e.pos.x + 10, e.pos.y + temp + 25)
    -- Draw line
    love.graphics.setLineWidth(1)
    Color.set(e.line_color_2)
    love.graphics.line(e.pos.x + 10, e.pos.y + temp + 25 + font_h + 5, e.pos.x + e.w - 10, e.pos.y + temp + 25 + font_h + 5)

    -- Text
    Color.set(e.content_color)
    love.graphics.setFont(self.text_font)
    self.text_scroll:draw()

    -- Time
    Color.set(e.content_color)
    font = FONTS.fira(13)
    font_w = font:getWidth("received @ "..e.time)
    font_h = font:getHeight("received @ "..e.time)
    love.graphics.setFont(font)
    love.graphics.print("received @ "..e.time,  e.pos.x + e.w - 5 - font_w, e.pos.y + e.h - font_h - 5)

    -- Can be deleted button
    if e.can_be_deleted then
        -- Make button box
        Color.set(e.delete_button_color)
        love.graphics.rectangle("fill", e.delete_x, e.delete_y, e.delete_w, e.delete_h)
        Color.set(e.line_color_3)
        love.graphics.setLineWidth(3)
        love.graphics.rectangle("line", e.delete_x, e.delete_y, e.delete_w, e.delete_h)

        -- Make button text
        love.graphics.setFont(FONTS.fira(15))
        Color.set(e.delete_button_text_color)
        love.graphics.print("delete", e.delete_x + 8, e.delete_y + 7)
    end

    -- Reply button
    if e.reply_func then
        -- Make button box
        if e.can_reply then
            Color.set(e.reply_button_enabled_color)
        else
            Color.set(e.reply_button_disabled_color)
        end
        local complete = referenced_email.puzzle_id and LoreManager.puzzle_done[referenced_email.puzzle_id]
        if complete then
            Color.set(e.retry_button_color)
        end
        love.graphics.rectangle("fill", e.reply_x, e.reply_y, e.reply_w, e.reply_h)
        Color.set(e.line_color_3)
        love.graphics.setLineWidth(3)
        love.graphics.rectangle("line", e.reply_x, e.reply_y, e.reply_w, e.reply_h)

        -- Make button text
        love.graphics.setFont(FONTS.fira(15))
        if e.can_reply then
            Color.set(e.reply_button_enabled_text_color)
        else
            Color.set(e.reply_button_disabled_text_color)
        end
        if complete then
            text = "retry"
        else
            text = "reply"
        end
        love.graphics.print(text, e.reply_x + 11, e.reply_y + 6)
        
        -- Draw "COMPLETED" text
        if complete then
            Color.set(Color.red())
            font = FONTS.fira(30)
            love.graphics.setFont(font)
            text = "COMPLETED"
            love.graphics.print(text, self.pos.x + self.w - font:getWidth(text) - 20, self.pos.y + self.h - font:getHeight(text)*2, -math.pi / 20)
        end
    end

end

function OpenedEmail:destroy(t) --Destroy this element from all tables (quicker if you send his drawable table, if he has one)

    self:setSubTp(nil) --Removes from Subtype table, if its in one
    self:setId(nil) --Removes from Id table, if its in one

    --Iterate all handles related to MAIN_TIMER
    if self.handles then
        for _,h in pairs(self.handles) do
            MAIN_TIMER:cancel(h) --Stops any timers this object has
        end
    end
    if t then
        t[self] = nil --If you provide the  drawable table, removes from it quicker
    else
        for _,tb in pairs(DRAW_TABLE) do--Iterates in all drawable tables and removes element
            if tb[self] then
                TABS_LOCK = false -- Enable clicking on tabs
                Util.findId("email_tab").email_opened = nil
                tb[self] = nil
                return
            end
        end
    end

    TABS_LOCK = false -- Enable clicking on tabs
    Util.findId("email_tab").email_opened = nil

end

function OpenedEmail:mouseMoved(...) self.text_scroll:mouseMoved(...) end
function OpenedEmail:mouseScroll(...) self.text_scroll:mouseScroll(...) end
function OpenedEmail:mousePressed(...) self.text_scroll:mousePressed(...) end
function OpenedEmail:mouseReleased(...) self.text_scroll:mouseReleased(...) end
function OpenedEmail:update(...) self.text_scroll:update(...) end

-- UTILITY FUNCTIONS

function opened_email_funcs.close()
    local e

    e = Util.findId("opened_email")
    e.death = true

end

function opened_email_funcs.mousePressed(x, y, but)
    local e

    e = Util.findId("opened_email")
    if not e or e.death then return end

    if x  < e.pos.x or
       x > e.pos.x + e.w or
       y  > e.pos.y + e.h or
       y < e.pos.y then
        --Clicked outside box
        opened_email_funcs.close()
     else
         if but == 1 and e.can_be_deleted and Util.pointInRect(x, y, {pos = {x = e.delete_x, y = e.delete_y}, w = e.delete_w, h = e.delete_h}) then
            --Clicked on the delete button
            local mailTab = Util.findId("email_tab")
            mailTab.deleteEmail(mailTab.email_list[mailTab.email_opened.number])
            opened_email_funcs.close()
         elseif but == 1 and e.reply_func and e.can_reply and Util.pointInRect(x, y, {pos = {x = e.reply_x, y = e.reply_y}, w = e.reply_w, h = e.reply_h}) then
            --Clicked on the reply button
            e.reply_func(e)
            if e.referenced_email.puzzle_id then
                ROOM:connect(e.referenced_email.puzzle_id)
                opened_email_funcs.close()
            end
         end
     end
end

function opened_email_funcs.create(number, title, text, author, time, can_be_deleted, reply_func, can_reply)
    local e

    e = OpenedEmail(number, title, text, author, time, can_be_deleted, reply_func, can_reply)
    e:addElement(DRAW_TABLE.L2, nil, "opened_email")

    return e
end

return opened_email_funcs
