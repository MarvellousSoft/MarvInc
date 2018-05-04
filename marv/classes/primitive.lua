--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local Color = require "classes.color.color"

--PRIMITIVE CLASS--

local primitive = {}

--[[Primitive classes to inherit from]]

--Element: has a type, subtype and id
ELEMENT = Class{
    init = function(self)
        self.tp = nil --Type this element belongs to
        self.subtp = nil --Subtype this element belongs to, if any
        self.id = nil --Id of this element, if any
        self.invisible = false --If this object is not to be draw
        self.death = false --If true, the object will be deleted next update
        self.handles = {} --Table containing active color timer handles for this object
    end,

    --Sets id for this element, and add it to a ID table for quick lookup
    setId = function(self, _id)
        if self.id then
            ID_TABLE[self.id] = nil --Delete previous Id element
        end
        self.id = _id
        if not _id then return end --If nil, just remove
        ID_TABLE[_id] = self
    end,
    --Sets subtype for this element, and add it to respective subtype table for quick lookup
    setSubTp = function(self, _subtp)
        if self.subtp then
            SUBTP_TABLE[self.subtp][self] = nil --Delete previous subtype this element had
            if not next(SUBTP_TABLE[self.subtp]) then
                SUBTP_TABLE[self.subtp] = nil   --If no more elements of this subtype, delete the table
            end
        end
        self.subtp = _subtp
        if not _subtp then return end  --If nil, just remove element
        if not SUBTP_TABLE[self.subtp] then
            SUBTP_TABLE[self.subtp] = {} --Creates subtype table if it didn't exist
        end
        SUBTP_TABLE[self.subtp][self] = true
    end,

    destroy = function(self, t) --Destroy this element from all tables (quicker if you send his drawable table, if he has one)
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
                    tb[self] = nil
                    return
                end
            end
        end
    end,

    addElement = function(self, t, subtp, id) --Add element to a t drawable table, and if desired, adds a subtype and/or id
        if subtp then self:setSubTp(subtp) end
        if id then self:setId(id) end
        t[self] = true
    end,

    --Kill this object
    kill = function(self)

        if self.death then return end
        self.death = true

    end,
}

-------------------
--CHARACTERISTICS--
-------------------

--Positionable: has a x and y position
POS = Class{
    init = function(self, _x, _y) --Set position for object
        self.pos = Vector(_x or 0, _y or 0) --Position vector
    end,

    setPos = function(self, _x, _y) --Set position for object
        self.pos.x, self.pos.y = _x, _y
    end
}

--Colorful: the object has a color, and a color table for  transistions
CLR = Class{
    init = function(self, _c)
        self.color = HSL() --This object main color
        if _c then Color.copy(self.color, _c) end
    end,

    setColor = function(self, _c) --Set object's color
        Color.copy(self.color, _c)
    end,

}

--With-Text: the object has a text
WTXT = Class{
    init = function(self, _text, _font, _t_color) --Set circle's atributes
        self.text = _text or "sample" --This object text
        self.font = _font             --This object text font
        self.t_color = _t_color or HSL(0,0,0) --This object text color
        if _text_color then Color.copy(self.t_color, _t_color) end
    end,

    setTextColor = function(self, _c) --Set object's text color
        Color.copy(self.t_color, _c)
    end
}

----------
--SHAPES--
----------

-----------------------
--RECTANGLE FUNCTIONS--
-----------------------

--Rectangle: is a positionable and colorful object with width and height
RECT = Class{
    __includes = {ELEMENT, POS, CLR},
    init = function(self, _x, _y, _w, _h, _c) --Set rectangle's atributes
        ELEMENT.init(self)
        POS.init(self, _x, _y)
        self.w = _w or 10 --Width
        self.h = _h or 10 --Height
        CLR.init(self, _c)
    end,

    resize = function(self, _w, _h) --Change width/height
        self.w = _w
        self.h = _h
    end

}

----------------------
--TRIANGLE FUNCTIONS--
----------------------

--Triangle: is a positionable and colorful object with three points
TRIANGLE = Class{
    __includes = {ELEMENT, CLR},
    init = function(self, _pos1, _pos2, _pos3, _c, _mode, _line_width) --Set rectangle's atributes
        ELEMENT.init(self)

        --Triangle positions
        self.p1 = Vector(_pos1.x, _pos1.y)
        self.p2 = Vector(_pos2.x, _pos2.y)
        self.p3 = Vector(_pos3.x, _pos3.y)

        self.mode = self.mode or _mode or "line" --Mode to draw the triangle
        self.line_width = _line_width or 3 --Line thickness if mode is line

        CLR.init(self, _c)

    end
}

function TRIANGLE:draw()
    local t

    t = self

    --Draws the triangle
    Color.set(t.color)
    if t.mode == "line" then
        love.graphics.setLineWidth(t.line_width)
    end
    love.graphics.polygon(t.mode, t.p1.x, t.p1.y, t.p2.x, t.p2.y, t.p3.x, t.p3.y)
end

--------------------
--CIRCLE FUNCTIONS--
--------------------

--Circle: is a positionable and colorful object with radius
CIRC = Class{
    __includes = {ELEMENT, POS, CLR},
    init = function(self, _x, _y, _r, _c, _mode) --Set circle's atributes
        ELEMENT.init(self)
        POS.init(self, _x, _y)
        self.r = _r --Radius
        self.mode = _mode or "fill" --Circle draw mode
        CLR.init(self, _c)
    end,

    resize = function(self, _r) --Change radius
        self.r = _r
    end
}

--Draws the circle
function CIRC:draw()
    local p

    p = self

    Color.set(p.color)
    if p.mode == "line" then
        love.graphics.setLineWidth(p.line_width)
    end

    love.graphics.circle(p.mode, p.pos.x, p.pos.y, p.r)

end

------------------------
--IMAGE FUNCTIONS--
------------------------

--Circle: is a positionable and colorful object with radius
IMAGE = Class{
    __includes = {ELEMENT, POS, CLR},
    init = function(self, _x, _y, _img, _c, _scale) --Set circle's atributes
        local color
        ELEMENT.init(self)
        POS.init(self, _x, _y)

        color = _c or Color.white()
        CLR.init(self, color)

        self.scale = _scale
        self.img = _img

    end,

}

--Draws the circle
function IMAGE:draw()
    local i

    i = self

    Color.set(i.color)

    love.graphics.draw(i.img, i.pos.x, i.pos.y, 0, self.scale)

end
