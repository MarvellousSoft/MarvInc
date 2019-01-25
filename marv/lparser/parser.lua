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

local parser = {}

local str_subchar = function(str, i, c)
    if i < 1 or i > str:len() then return str end
    return str:sub(1, i-1) .. (c or ' ') .. str:sub(i+1)
end

local init_map = function(c)
    c = c or ' '
    local M = ""
    for i = 1, ROWS*COLS do
        M = M..c
    end
    return M
end

local new_safe_env = function(...)
    local E = {}
    for _, v in pairs{...} do
        if type(v) == "string" then
            E[v] = _G[v]
        elseif type(v) == "table" then
            for _, u in pairs(v) do
                E[u] = {}
                local t = _G[u]
                for k, f in pairs(t) do
                    if type(f) == "function" then
                        E[u][k] = f
                    end
                end
            end
        end
    end
    return E
end

function parser.safe_env()
    local E = new_safe_env(
        "assert",
        "error",
        "ipairs",
        "next",
        "pairs",
        "pcall",
        "print",
        "select",
        "tonumber",
        "tostring",
        "type",
        "unpack",
        "_VERSION",
        "xpcall",
        { -- Special cases
            "string",
            "table",
            "math",
        }
    )
    return E
end

local retrieve_asset = function(key)
    if key == nil then return nil, "Expected reference key to asset. Got nil value!" end
    local a = CUST_SHEET_IMG[key]
    if a ~= nil then return a, "sprite" end
    a = CUST_OBJS_IMG[key]
    if a ~= nil then return a, "image" end
    a = SHEET_IMG[key]
    if a ~= nil then return a, "sprite" end
    a = OBJS_IMG[key]
    if a ~= nil then return a, "image" end
    return nil, "Asset "..key.." not found!"
end

function parser.prepare(puz_f, t)
    -- Functions and tables allowed by the environment (considered safe-ish).
    local _E = parser.safe_env()
    local extra = {}
    setfenv(puz_f, _E)
    if t == "level" then
        -- Constants
        _E.ROWS = ROWS
        _E.COLS = COLS

        local function checkType(val, typestr, depth)
            if type(val) ~= typestr then error("Invalid non-" .. typestr .. " parameter", depth or 3) end
        end
        local function checkNumber(num, from, to, depth)
            checkType(num, 'number', (depth or 3) + 1)
            if num < from or num > to then
                error("Number not in range [" .. from .. ", " .. to .. "]", depth or 3)
            end
        end
        local function checkString(str, from, to)
            checkType(str, 'string', 4)
            if str:len() < from or str:len() > to then
                error("String length not in range [" .. from .. ", " .. to .. "]", 3)
            end
        end
        local function checkGrid(i, j, depth)
            checkNumber(i, 1, ROWS, (depth or 3) + 1)
            checkNumber(j, 1, COLS, (depth or 3) + 1)
            return (i - 1) * COLS + j
        end
        local function getSetter(meta, var, check, ...)
            local wrap = {...} -- assuming nothing in ... is nil
            return function(val)
                check(val, unpack(wrap))
                meta[var] = val
            end
        end

        extra.meta = {
            name   = "Untitled",
            id     = "??",
            lines  = 99,
            memory = 10,
            info   = "Missing info.",
        }
        -- Meta table
        _E.Meta = {
            SetName   = getSetter(extra.meta, 'name', checkType, 'string'),
            SetID     = getSetter(extra.meta, 'id', checkType, 'string'),
            SetLines  = getSetter(extra.meta, 'lines', checkNumber, 1, 99),
            SetMemory = getSetter(extra.meta, 'memory', checkNumber, 0, 200),
            SetInfo   = getSetter(extra.meta, 'info', checkType, 'string'),
        }

        extra.objective = {
            text  = "No objectives listed.",
            check = function() return false end,
        }
        -- Objective table
        _E.Objective = {
            SetText  = getSetter(extra.objective, 'text', checkType, 'string'),
            SetCheck = getSetter(extra.objective, 'check', checkType, 'function'),
        }

        local floor = {
            L    = init_map(),
            ref  = {},
            iref = {}
        }
        -- Floor
        _E.Floor = {
            SetAll   = getSetter(floor, 'L', checkString, ROWS * COLS, ROWS * COLS),
            Register = function(key, c)
                checkType(key, 'string')
                checkString(c, 1, 1)
                floor.ref[c] = key
                floor.iref[key] = c
            end,
            PlaceAt = function(key, i, j)
                checkType(key, 'string')
                local p = checkGrid(i, j)
                floor.L = str_subchar(floor.L, p, floor.iref[key])
            end
        }
        extra.floor = floor

        local objs = {
            L    = init_map(),
            ref  = {},
            iref = {},
        }
        -- Objects
        _E.Objects = {
            SetAll   = getSetter(objs, 'L', checkString, ROWS * COLS, ROWS * COLS),
            Register = function(obj, c)
                checkType(obj, 'table') -- check if it is an object
                checkString(c, 1, 1)
                objs.ref[c] = obj
                objs.iref[obj] = c
            end,
            PlaceAt = function(obj, i, j)
                checkType(obj, 'table') -- check if it is an object
                local p = checkGrid(i, j)
                objs.L = str_subchar(objs.L, p, objs.iref[obj])
            end
        }
        extra.objects = objs

        local wall = {
            L = init_map()
        }
        -- Invisible Wall
        _E.InvWall = {
            SetAll = getSetter(wall, "L", checkString, ROWS * COLS, ROWS * COLS),
            Wall   = function(i, j)
                local p = checkGrid(i, j)
                wall.L = str_subchar(wall.L, p, '*')
            end,
            NoWall = function(i, j)
                local p = checkGrid(i, j)
                wall.L = str_subchar(wall.L, p, ' ')
            end
        }
        extra.inv_wall = wall

        local import = {
            ref_imgs    = {},
            ref_sprites = {},
            ref_tiles   = {},
        }
        -- Importing assets
        _E.Import = {
            Image = function(key, path)
                import.ref_imgs[key] = path
            end,
            Sprite = function(key, d, path)
                import.ref_sprites[key] = {d, path}
            end,
            Tile = function(key, path)
                import.ref_tiles[key] = path
            end,
        }
        extra.import = import

        -- Constructors
        function _E.Bucket(cnt, clr)
            return {id = "bucket", cnt = cnt, c = clr}
        end
        function _E.Obstacle(bg, key, d, clr)
            return {id = "obstacle", bg = bg, key = key, d = d, c = clr}
        end
        function _E.Dead(bg, key, bg, c, d)
            if d == nil then return {id = "dead", bg = bg, key = key, c = c} end
            return {id = "dead", bg = bg, c = c, key = key, d = d}
        end
        function _E.DeadSwitch(bg, key_on, d, c, img_off, bckt)
            return {id = "dead_switch", key_on = key_on, d = d, c = c, img_off = img_off, bckt = bckt}
        end
        function _E.Container(bg, key, d, c, cnt, cnt_c)
            return {id = "container", bg = bg, key = key, d = d, c = c, cnt = cnt, cnt_c = cnt_c}
        end
        function _E.Emitter(img, bg, c, r_key, r_bg, r_d, r_c)
            return {id = "emitter", key = img, c = c, r = {key = r_key, bg = r_bg, d = r_d, c = r_c}}
        end
        function _E.Lava()
            return {id = "dead_switch", key_on = "lava", d = 0.2, bg = true, c = "white", img_off = "solid_lava", bckt = true}
        end
        function _E.Console(img, c, bg, data, n)
            return {id = "console", img = img, c = c, bg = bg, data = data, n = n}
        end

        local game = {
            onStart = function() end,
            onEnd   = function() end,
            onDeath = function() end,
            onTurn  = function() end,
        }
        -- Game
        _E.Game = {
            SetOnStart = getSetter(game, 'onStart', checkType, 'function'),
            SetOnEnd   = getSetter(game, 'onEnd', checkType, 'function'),
            SetOnDeath = getSetter(game, 'onDeath', checkType, 'function'),
            SetOnTurn  = getSetter(game, 'onTurn', checkType, 'function'),
        }
        extra.game = game

        local bot = {
            position    = {1, 1},
            orientation = "NORTH",
        }
        local ors = {NORTH = true, SOUTH = true, EAST = true, WEST = true}
        _E.Bot = {
            SetPosition    = getSetter(bot, 'position', function(val) checkType(val, 'table'); checkGrid(val[1], val[2], 4) end),
            SetOrientation = getSetter(bot, 'orientation', function(val) if not ors[val] then error("Invalid orientation", 2) end end),
            GetPosition = function()
                return ROOM.bot.pos.x, ROOM.bot.pos.y
            end
        }
        extra.bot = bot

    elseif t == "email" then
        local e = {
            title = "Untitled",
            text  = "Missing email text.",
            authors = "Missing author",
        }
        local function addSetter(var, setter)
            _E.Email[setter] = function(str)
                if type(str) ~= 'string' then
                    error(setter .. " called with non-string argument.", 2)
                end
                e[var] = str
            end
        end
        _E.Email = {}
        addSetter('title', 'SetTitle')
        addSetter('text', 'SetText')
        addSetter('authors', 'SetAuthors')
        addSetter('portrait', 'SetPortrait')
        addSetter('attachment', 'SetAttachment')
        extra.email = e
    end

    return _E, extra
end

local function getAbsolutePath(id)
    if love.filesystem.isDirectory("custom/" .. id) then
        return love.filesystem.getSaveDirectory() .. "/custom/" .. id .. "/"
    elseif USING_STEAM then
        local file_id = Steam.extra.parseUint64(id)
        local ok, _, dir = Steam.UGC.getItemInstallInfo(file_id)
        if ok then
            return dir .. "/"
        end
    end
end

-- Image from absolute path (can't use love.graphics.newImage directly)
local memo = {}
local function newImage(path)
    if not memo[path] then
        local f = io.open(path, "rb")
        if not f then
            error("Could not find file " .. path, 2)
        end
        local data = f:read("*all")
        f:close()
        memo[path] = love.graphics.newImage(love.filesystem.newFileData(data, path))
    end
    return memo[path]
end


function parser.parse(id, noload)
    -- Can't use most love.filesystem stuff since it may be outside of save dir
    local path = getAbsolutePath(id)
    local f = path and loadfile(path .. "level.lua")
    if not f then print("Custom level " .. id .. " not found") return nil end
    local E, extra = parser.prepare(f, "level")
    local s, err = pcall(f)
    if not path or not f or not s then
        print("Custom level "..id.." has failed to compile! " .. tostring(err))
        return nil
    end
    local P = Puzzle()
    P.name = extra.meta.name
    P.id = id
    P.is_custom = true
    P.n = extra.meta.id
    P.turn_handler = extra.game.onTurn
    P.orient = extra.bot.orientation
    P.init_pos = Vector(extra.bot.position[1], extra.bot.position[2])
    P.grid_floor = {}
    P.grid_obj = {}
    P.inv_wall = {}
    for i=1, ROWS do
        P.grid_floor[i] = {}
        P.grid_obj[i] = {}
        P.inv_wall[i] = {}
    end

    if extra.floor.L:len() ~= COLS*ROWS then
        print("Floor layer incomplete!")
        return nil
    end
    if extra.objects.L:len() ~= COLS*ROWS then
        print("Objects layer incomplete!")
        return nil
    end
    if extra.inv_wall.L:len() ~= COLS*ROWS then
        print("InvWall was not properly declared! May be incomplete.")
        return nil
    end

    for k, v in pairs(extra.import.ref_imgs) do
        CUST_OBJS_IMG[k] = newImage(path .. v)
    end
    for k, v in pairs(extra.import.ref_tiles) do
        CUST_TILES_IMG[k] = newImage(path .. v)
    end
    for k, v in pairs(extra.import.ref_sprites) do
        CUST_SHEET_IMG[k] = {newImage(path .. v[2]), v[1]}
    end

    for i=1, COLS do
        for j=1, ROWS do
            local p = i + (j - 1) * COLS
            local k = extra.floor.L:sub(p, p)
            P.grid_floor[i][j] = extra.floor.ref[k]
        end
    end

    for i=1, COLS do
        for j=1, ROWS do
            local p = i + (j - 1) * COLS
            local k = extra.inv_wall.L:sub(p, p)
            if k == '*' then
                P.inv_wall[i][j] = '1'
            end
        end
    end

    for i=1, COLS do
        for j=1, ROWS do
            local p = i + (j - 1) * COLS
            local r = extra.objects.L:sub(p, p)
            local o = extra.objects.ref[r]
            if o ~= nil then
                local id = o.id
                local O = nil
                if id == "bucket" then
                    O = Bucket(P.grid_obj, i, j, "bucket", true, nil, nil, nil,
                        {pickable=true, color=o.clr, content=o.cnt})
                elseif id == "obstacle" then
                    -- Implement safe onInventoryDrop and onWalk later?
                    O = Obstacle(P.grid_obj, i, j, o.key, o.bg, o.d, o.c, nil, nil)
                elseif id == "dead" then
                    O = Dead(P.grid_obj, i, j, o.key, o.bg, o.d, o.c)
                elseif id == "dead_switch" then
                    O = DeadSwitch(P.grid_obj, i, j, o.key, o.bg, o.d, o.c, o.img_off, {bucketable=o.bckt})
                elseif id == "container" then
                    O = Container(P.grid_obj, i, j, o.key, o.bg, o.d, o.c, nil, {content=o.cnt, content_color=o.cnt_c})
                elseif id == "emitter" then
                    O = Emitter(P.grid_obj, i, j, o.key, o.bg, o.c, nil, nil, {o.r.key, o.r.bg, o.r.d, o.r.c})
                elseif id == "console" then
                    local _d = (o.d == nil) and "output" or o.d
                    O = Console(P.grid_obj, i, j, o.img, o.bg, o.c, nil, nil, {vec=_d, show_nums=o.n})
                else
                    print("Unrecognized object "..tostring(id).." at position ("..tostring(j)..", "..tostring(i)..").")
                end
                o.Object = O
            end
        end
    end

    P.objective_text = extra.objective.text
    P.objective_checker = extra.objective.check
    P.lines_on_terminal = extra.meta.lines <= 0 and 99 or extra.meta.lines
    P.memory_slots = extra.meta.memory
    P.extra_info = extra.meta.info
    P.on_start = extra.game.onStart
    P.on_end = extra.game.onDeath
    P.custom_completed = function()
        -- improve this
        local title, text, c, o1, c1, o2, c2 = extra.game.onEnd()
        PopManager.new(title, text, c,
            {func = function() ROOM:disconnect() end, text = o1, clr = Color[c1]()},
            {func = function() ROOM:disconnect() end, text = o2, clr = Color[c2]()})
    end
    if not noload then
        P.code, P.renames = SaveManager.load_code(id, true)
    end

    return P
end

local function load_email(id)
    local path = getAbsolutePath(id)
    local f = path and loadfile(path .. "email.lua")
    if not path or not f then
        print("Custom Level " .. id .. " has no emails")
        return
    end
    local E, extra = parser.prepare(f, "email")
    f()
    local me = extra.email
    local portrait = me.portrait and newImage(path .. me.portrait) or nil
    if not Mail.existsId(me.id) then
        local e = Mail.new_custom(false, id, me.title, me.text, me.authors, false, id, nil, nil, me.attachment and newImage(path .. me.attachment))
        e.portrait = portrait
        return e
    end
end

function parser.load_email(...)
    local ok, email = pcall(load_email, ...)
    if ok then
        return email
    else
        print('Error while loading email: ' .. tostring(email))
        return nil
    end
end

function parser.read(id)
    parser.load_email(id)
    return parser.parse(id)
end

return parser
