--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

--MODULE WITH LOGICAL, MATHEMATICAL AND USEFUL STUFF--

local util = {}

---------------------
--UTILITIES FUNCTIONS
---------------------

--Counts how many entries are on table T
function util.tableLen(T)
  local count = 0

  if not T then return count end
  for _ in pairs(T) do count = count + 1 end

  return count
end

--Chcks if a tale is empty (true if it doesn't exist)
function util.tableEmpty(T)

  if not T then return true end

  return not next(T)
end

function util.clearTimerTable(T, TIMER)

    if not T then return end --If table is empty
    --Clear T table
    for _, o in pairs (T) do
        TIMER:cancel(o)
    end

end

local memo = setmetatable({}, {__mode = 'k'})
function util.deepReadOnly(obj)
    if type(obj) ~= 'table' then return obj end
    if not memo[obj] then
        memo[obj] = setmetatable({}, {
            __index = function(_, key)
                return util.deepReadOnly(obj[key])
            end,
            __newindex = function(_, key, value)
                error("Cannot modify read-only object", 2)
            end
        })
    end
    return memo[obj]
end

function util.shallowCopy(t)
    if type(t) ~= 'table' then return t end
    local cp = {}
    for a, b in pairs(t) do
        cp[a] = b
    end
    return cp
end

--Return a random element from a given table.
--You can give an optional table argument 'tp', so it only returns elements that share a type with the table strings
--Obs: if you provide a tp table, and there isn't any suitable element available, the program will be trapped here forever (FIX THIS SOMETIME)
function util.randomElement(T, tp)
    local e

    while not e do
        e = T[love.math.random(util.tableLen(T))] --Get random element

        --If tp table isn't empty, compare
        if not util.tableEmpty(tp) then
            for i, k in pairs(tp) do
                if k == e.tp then
                    return e
                end
            end
            e = nil
        end
    end

    return e
end

--------------
--FIND OBJECTS
--------------

--Find an object based on an id
function util.findId(id)
    return ID_TABLE[id]
end

--Find a set of objects based on a subtype
function util.findSbTp(subtp)
    return SUBTP_TABLE[subtp]
end

----------------------
--MANIPULATE OBJECTS--
----------------------

--Set an atribute 'att' in all elements in a given 'T' table to 'value'
function util.setAtributeTable(T, att, value)
  for o in pairs(T) do
    o[att] = value
  end
end

--Set an atribute 'att' from an element with a given 'id' to 'value'
function util.setAtributeId(id, att, value)
  for o in pairs(ID_TABLE) do
    if o.id == id then
      o[att] = value
      return
    end
  end
end

--Set an atribute 'att' in all element with a given subtype 'st' to 'value'
function util.setAtributeSubtype(st, att, value)
  for o in pairs(SUBTP_TABLE[st]) do
    o[att] = value
  end
end

--------------------
--UPDATE FUNCTIONS
--------------------

--Update all objects in a table
function util.updateTable(dt, T)

    if not T then return end
    for o in pairs(T) do
        if o.update then
            o:update(dt)
        end
    end

end

--Update all objects with a subtype sb
function util.updateSubTp(dt, sb)
    util.updateTable(dt, SUBTP_TABLE[sb])
end

--Update an object with an id
function util.updateId(dt, id)
    local o

    o = util.findId(id)

    if not o then return end

    o:update(dt)

end

--Update all timers
function util.updateTimers(dt)

    MAIN_TIMER:update(dt)

end


---------------------
--DESTROY FUNCTIONS--
---------------------

--Delete an object based on an id
function util.destroyId(id)
    if ID_TABLE[id] then ID_TABLE[id]:destroy() end
end

--Delete a set of objects based on a subtype
function util.destroySubtype(subtp)
    if SUBTP_TABLE[subtp] then
        for o in pairs(SUBTP_TABLE[subtp]) do
            o:destroy()
        end
    end
end

--Iterate through a table and destroys any element with the death flag on
function util.destroyTable(T)

    if not T then return end
    for o in pairs(T) do
        if o.death then o:destroy() end
    end

end

--Iterate through all elements with a subtype sb and destroy anything with the death flag on
function util.destroySubTp(sb)

    util.destroyTable(SUBTP_TABLE[sb])

end

--Destroy all objects in game that have the death flag set to true
function util.destroyAll()

    for T in pairs(SUBTP_TABLE) do
        util.destroySubTp(T)
    end

    for o in pairs(ID_TABLE) do
        util.destroyId(o)
    end

    for _, T in pairs(DRAW_TABLE) do
        util.destroyTable(T)
    end

end

--Destroys a single element if his death flag is on
function util.destroyId(id)
    local o

    o = ID_TABLE[id]
    if o and o.death then
         o:destroy()
    end

end

---------------------
--UTILITY FUNCTIONS--
---------------------

--Exit program
function util.exit()

    love.event.quit()

end

--Toggle debug mode
function util.toggleDebug()

    DEBUG = not DEBUG
    print("DEBUG is", DEBUG)

end

--------------------
--GLOBAL FUNCTIONS--
--------------------

--Get any key that is pressed and checks for generic events
function util.defaultKeyPressed(key)

    local Mail = require 'classes.tabs.email'
    if key == 'f4' and love.keyboard.isDown('lalt') then
        util.exit()
    elseif key == 'f1' then
        --util.toggleDebug()
    end

end

function util.pointInRect(_x, _y, x, y, w, h)
    if not y then x, y, w, h = x.pos.x, x.pos.y, x.w, x.h end
    return not (_x < x or _x > x + w or _y < y or _y > y + h)
end


--[[
    Function receives a text and returns a colored_text table as expected for love.graphics.printf function
The format of the colored_text table is a sequence of 2-tuples (color_of_text_in_rgb, text_to_be_colored)
The function colors the text based on tags with {}. {colorname} means to start coloring a text with the color given.
{end} means to stop using previous color and change to default color of text (default color must be given in RGB format).
    Accepted tags:
    {end} - Stop previous tag and start using default_color
    {red} - Red color
    {blue} - Blue color
    {green} - Green color
    {purple} - Purple color
    {orange} - Orange color
    {cyan} - Cyan color
    {pink} - Pink color
    {gray} - Gray color
    {brown} - Brown color
    {inst} - Used for instructions (has a manual version {instm})
    {dir} - Used for directions (has a manual version {dirm})
    {lab} - Used for labels (has a manual version {labm})
    {num} - Used for values (has a manual version {numm})
    {addr} - Used for addresses (has a manual version {addrm})
    {cmnt} - Used for comments (has a manual version {cmntm})
    {ds} - Used when mentioning data structures
    {tab} - Used for pc-box tabs
]]

local b = .3

local text_colors = {
    red = {255, 0, 0},
    blue = {12, 10, 150},
    green = {13, 128, 11},
    purple = {110, 41, 188},
    orange = {255, 114, 0},
    cyan = {22, 159, 183},
    pink = {255, 45, 84},
    gray = {122, 122, 122},
    brown = {178, 101, 12},
    yellow = {195, 174, 38},
    inst = {189,0,255}, instm = {177,94,255},
    dir = {0,30,255}, dirm = {113,188,232},
    lab = {35, 102, 96}, labm = {0,255,159},
    num = {255, 16, 31}, numm = {255, 109, 119},
    addr = {140, 111, 23}, addrm = {192, 242, 77},
    cmnt = {40, 40, 40}, cmntm = {20, 20, 20},
    ds = {200, 168, 23},
    tab = {216,17,89}
}

--If non_default_color isn't nil, everything that is not default will be colored that way
--ignore is a string that lists all color tags that should be treated as default
function util.stylizeText(text, default_color, ignore)
    default_color = default_color or {0, 0, 0, 255}
    local colored_text = {default_color}
    local full_text = {}
    local all_but_default_text = {{0,0,0,0}}

    --[[ Iterate through text, anaylsing for {tags} ]]
    for w in text:gmatch("{?[^{}]+}?") do
        -- Check for tags
        if w == "{end}" then
            table.insert(colored_text, default_color) -- Change to default color
            table.insert(all_but_default_text, {0,0,0,0}) -- Stop coloring
        elseif w:match("^{%a+}$") then
            local color = text_colors[w:match("%a+")] -- Getting color info from name
            if not color then
                print("unrecognized color '" .. w:match("%a+") .. "'")
            elseif ignore and ignore:find(w:match("%a+")) then
              table.insert(colored_text, default_color)
              table.insert(all_but_default_text, {0,0,0,0})
            else
                table.insert(colored_text, color)
                table.insert(all_but_default_text, color)
            end
        else
            -- Not a tag, so update current_text
            table.insert(colored_text, w)
            table.insert(full_text, w)
            table.insert(all_but_default_text, w)
        end
    end

    return colored_text, table.concat(full_text), all_but_default_text
end

local AUTHORS = {"bill miles", "diego", "fergus", "franz", "janine", "liv", "paul", "auto", "human", "news", "emergency", "r.y.r.", "black"}
function util.getAuthorColor(author)
    local s = author:lower()
    for _, k in ipairs(AUTHORS) do
        for t in k:gmatch("%S+") do
            if s:find(t) then
                local key = k
                if k == "bill miles" then
                    key = "bm"
                elseif k == "r.y.r." then
                    key = "ryr"
                elseif k == "janine" then
                    key = "jen"
                end
                return CHR_CLR[key]
            end
        end
    end
    return CHR_CLR["spam"]
end

function util.getAuthorImage(email)
    if email.is_custom then
        return email.referenced_email.portrait or AUTHOR_IMG.unknown
    end
    local author = email.author:lower()
    for key, img in pairs(AUTHOR_IMG) do
        if author:find(key) then
            return img
        end
    end
    return AUTHOR_IMG.unknown
end

--Receives the center x and y values of a circle, and its radius, and draw it on the screen
--OBS: Have the color already setted
function util.drawSmoothCircle(x, y, r)
    x = x - r
    y = y - r

    local size = math.ceil(2*r)
    --Create smooth circle shader if it hasn't been yet
    if not SMOOTH_CIRCLE_TABLE[size] then
        SMOOTH_CIRCLE_TABLE[size] = love.graphics.newShader(SMOOTH_CIRCLE_SHADER:format(size))
    end

    --Draw the circle
    love.graphics.setShader(SMOOTH_CIRCLE_TABLE[size])
    love.graphics.draw(MISC_IMG.pixel, x, y, 0, 2*r)
    love.graphics.setShader()

end

--Receives the center x and y values of a ring, its radius and inner_radius, and draw it on the screen
--OBS: Have the color already setted
function util.drawSmoothRing(x, y, r, i_r)
    x = x - r
    y = y - r

    local size = math.ceil(2*r)
    i_r = math.ceil(i_r)

    --Create smooth circle shader if it hasn't been yet
    if not SMOOTH_RING_TABLE[size..'-'..i_r] then
        SMOOTH_RING_TABLE[size..'-'..i_r] = love.graphics.newShader(SMOOTH_RING_SHADER:format(size, i_r))
    end

    --Draw the circle
    love.graphics.setShader(SMOOTH_RING_TABLE[size..'-'..i_r])
    love.graphics.draw(MISC_IMG.pixel, x, y, 0, 2*r)
    love.graphics.setShader()
end



--Return functions
return util
