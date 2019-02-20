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
local Util = require "util"

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
    -- exceptions
    -- pairs/ipairs will try to use metamethods
    E.next = function(t, k)
        local m = getmetatable(t)
        local nx = m and m.__next or next
        return nx(t, k)
    end
    E.pairs = function(t)
        return E.next, t, nil
    end
    local function _ipairs(t, var)
        var = var + 1
        local value = t[var]
        if value == nil then return end
        return var, value
    end
    -- these will work even when the table uses __index metamethods
    E.ipairs = function(t) return _ipairs, t, 0 end
    E.table.getn = function(t)
        if type(t) ~= 'table' then return #t end
        local l, r = 0, 1000000
        while l < r do
            local m = math.floor((l + r) / 2)
            if t[m + 1] == nil then
                r = m
            else
                l = m + 1
            end
        end
        return l
    end
    -- unsafe because of memory usage
    E.string.rep = nil
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

local function checkType(val, typestr, depth)
    if type(val) ~= typestr then error("Invalid non-" .. typestr .. " parameter", depth or 3) end
    return val
end
local function checkNumber(num, from, to, depth)
    checkType(num, 'number', (depth or 3) + 1)
    if num < from or num > to then
        error("Number not in range [" .. from .. ", " .. to .. "]", depth or 3)
    end
    return num
end
local function checkString(str, from, to)
    checkType(str, 'string', 4)
    if str:len() < from or str:len() > to then
        error("String length not in range [" .. from .. ", " .. to .. "]", 3)
    end
    return str
end
local function checkGrid(i, j, depth)
    checkNumber(i, 1, ROWS, (depth or 3) + 1)
    checkNumber(j, 1, COLS, (depth or 3) + 1)
    return (i - 1) * COLS + j
end
local colors = {red = true, green = true, blue = true, white = true, orange = true, black = true}
local function checkColor(clr, depth)
    if not colors[clr] then
        error("Non-existent color '" .. tostring(clr) .. "'", depth or 3)
    end
    return Color[clr]()
end
local dirs = {north = true, south = true, west = true, east = true}
local function checkDir(dir, depth)
    checkType(dir, 'string', (depth or 3) + 1)
    if not dirs[dir:lower()] then error("Invalid direction '" .. dir .. "'", depth or 3) end
    return _G[dir:upper() .. "_R"]
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

        local function getSetter(meta, var, check, ...)
            local wrap = {...} -- assuming nothing in ... is nil
            return function(val)
                local obj = check(val, unpack(wrap))
                meta[var] = obj or val
            end
        end

        extra.meta = {
            name   = "Untitled",
            id     = "??",
            lines  = 99,
            memory = 10,
            info   = nil,
            popup  = {
                title  = "Completed custom level",
                text   = "You have completed this custom level. The author didn't create a custom completed popup. Shame.",
                color  = Color.black(),
                button1 = {
                    text  = "Ok",
                    color = Color.black()
                }
            },
            onStart = function() end
        }

        extra.objective = {
            text  = "No objectives listed.",
            check = function() return false end,
        }
        -- Meta table
        _E.Meta = {
            SetName      = getSetter(extra.meta, 'name', checkType, 'string'),
            SetRoomName  = getSetter(extra.meta, 'id', checkType, 'string'),
            SetLines     = getSetter(extra.meta, 'lines', checkNumber, 1, 99),
            SetMemory    = getSetter(extra.meta, 'memory', checkNumber, 0, 200),
            SetExtraInfo = getSetter(extra.meta, 'info', function(val)
              if type(val) == 'string' then return val end
              local tab = {}
              checkType(val, 'table', 4)
              for i, v in ipairs(val) do
                table.insert(tab, checkType(v, 'string', 4))
              end
              return table.concat(tab, "\n- ")
            end),
            SetCompletedPopup = getSetter(extra.meta, 'popup', function(val)
                local popup = {}
                checkType(val, 'table', 4)
                popup.title = checkType(val.title, 'string', 4)
                popup.text = checkType(val.text, 'string', 4)
                popup.color = checkColor(val.color, 4)
                popup.button1 = {}
                checkType(val.button1, 'table', 4)
                popup.button1.text = checkType(val.button1.text, 'string', 4)
                popup.button1.color = checkColor(val.button1.color, 4)
                if val.button2 then
                    popup.button2 = {}
                    checkType(val.button2, 'table', 4)
                    popup.button2.text = checkType(val.button2.text, 'string', 4)
                    popup.button2.color = checkColor(val.button2.color, 4)
                end
                return popup
            end),
            SetOnStart        = getSetter(extra.meta, 'onStart', checkType, 'function'),
            SetObjectiveText  = getSetter(extra.objective, 'text', checkType, 'string'),
            SetObjectiveCheck = getSetter(extra.objective, 'check', checkType, 'function'),
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
            PlaceAt = function(ch, i, j)
                checkString(ch, 1, 1)
                local p = checkGrid(i, j)
                floor.L = str_subchar(floor.L, p, ch)
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

        -- Util functions
        _E.Util = {
            CheckConsoleOutput = function(console, desired)
                checkType(console, 'table', 3)
                if console.type ~= 'console' or console.console_type ~= 'output' then
                    error("Invalid call. Object must be an output console.", 2)
                end
                checkType(desired, 'table', 3)
                for i, v in ipairs(desired) do
                  checkType(v, 'number', 3)
                end
                local out = console.list
                if _E.table.getn(out) > #desired then
                    return "Console has " .. _E.table.getn(out) .. " numbers, only " .. #desired .. " expected"
                end
                for i, v in _E.ipairs(out) do
                  if desired[i] ~= v then
                    return "At position #" .. i .. ": Expected " .. tostring(desired[i]) .. ", got " .. tostring(v) .. "."
                  end
                end
                return _E.table.getn(out) == #desired
            end
        }

        -- Constructors
        local contents = {water = true, paint = true, empty = true}
        function _E.Bucket(args)
            checkType(args, 'table')
            if not contents[args.content] then
                error("content must be one of ['water', 'empty', 'paint']", 2)
            end
            local o = {id = "bucket", content = args.content}
            if args.content == 'paint' then
                o.color = checkColor(args.color)
            end
            return setmetatable({}, o)
        end
        function _E.Wall(args)
            local o = {id = "wall", img = 'wall_none'}
            if args then
                checkType(args, 'table')
                if args.img then
                    checkType(args.img, 'string')
                    o.img = args.img
                end
            end
            return setmetatable({}, o)
        end
        --function _E.Obstacle(bg, key, d, clr)
        --    return setmetatable({}, {id = "obstacle", bg = bg, key = key, d = d, c = clr})
        --end
        --function _E.Dead(bg, key, bg, c, d)
        --    if d == nil then return setmetatable({}, {id = "dead", bg = bg, key = key, c = c}) end
        --    return setmetatable({}, {id = "dead", bg = bg, c = c, key = key, d = d})
        --end
        --function _E.DeadSwitch(bg, key_on, d, c, img_off, bckt)
        --    return setmetatable({}, {id = "dead_switch", key_on = key_on, d = d, c = c, img_off = img_off, bckt = bckt})
        --end
        --function _E.Container(bg, key, d, c, cnt, cnt_c)
        --    return setmetatable({}, {id = "container", bg = bg, key = key, d = d, c = c, cnt = cnt, cnt_c = cnt_c})
        --end
        --function _E.Emitter(img, bg, c, r_key, r_bg, r_d, r_c)
        --    return setmetatable({}, {id = "emitter", key = img, c = c, r = {key = r_key, bg = r_bg, d = r_d, c = r_c}})
        --end
        function _E.Lava()
            return setmetatable({}, {id = "dead_switch", key_on = "lava", d = 0.2, bg = true, c = "white", img_off = "solid_lava", bckt = true})
        end
        local ctypes = {input = true, output = true, IO = true}
        function _E.Console(args)
            checkType(args, 'table')
            checkColor(args.color)
            if not ctypes[args.type] then error("Console type must be one of ['input', 'output', 'IO']", 2) end
            local dir = checkDir(args.dir)
            if args.preview_numbers ~= nil then checkNumber(args.preview_numbers, 0, 50) end
            if args.type == 'output' and args.data ~= nil then error("Output console can't have data", 2) end
            if args.type == 'input' and args.data == nil then error("Input console must have data", 2) end
            local data = {}
            if args.data ~= nil then
                checkType(args.data, 'table')
                for i, v in ipairs(args.data) do
                    if type(v) == 'number' then
                        checkNumber(v, -999, 999)
                    elseif type(v) ~= 'string' or #v ~= 1 then
                        error("Index " .. i .. " of data must be a number or a single character", 2)
                    end
                    data[i] = v
                end
            end
            return setmetatable({}, {
                id = "console",
                color = args.color, -- this is a string
                ctype = args.type,
                dir = dir,
                data = data,
                preview_numbers = args.preview_numbers or 3
            })
        end

        local bot = {
            position    = {1, 1},
            orientation = "NORTH",
        }
        local ors = {NORTH = true, SOUTH = true, EAST = true, WEST = true}
        _E.Bot = {
            SetPosition    = function(i, j) checkGrid(i, j, 4) bot.position = {j, i} end,
            SetOrientation = getSetter(bot, 'orientation', function(val) if not ors[val:upper()] then error("Invalid orientation", 2) end end),
            GetPosition = function()
                return ROOM.bot.pos.y, ROOM.bot.pos.x
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
    P.orient = extra.bot.orientation:upper()
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
            P.grid_floor[i][j] = extra.floor.ref[k] or 'white_floor'
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
            local o = getmetatable(extra.objects.ref[r])
            if o ~= nil then
                local id = o.id
                if id == "bucket" then
                    Bucket(P.grid_obj, i, j, "bucket", true, nil, nil, nil,
                        {pickable=true, content_color=o.color, content=o.content})
                elseif id == "obstacle" then
                    -- disabled for now
                    -- Implement safe onInventoryDrop and onWalk later?
                    Obstacle(P.grid_obj, i, j, o.key, o.bg, o.d, o.c, nil, nil)
                elseif id == "dead" then
                    -- disabled for now
                    Dead(P.grid_obj, i, j, o.key, o.bg, o.d, o.c)
                elseif id == "dead_switch" then
                    -- disabled for now
                    DeadSwitch(P.grid_obj, i, j, o.key_on, o.bg, o.d, o.c, o.img_off, {bucketable=o.bckt})
                elseif id == "container" then
                    -- disabled for now
                    Container(P.grid_obj, i, j, o.key, o.bg, o.d, o.c, nil, {content=o.cnt, content_color=o.cnt_c})
                elseif id == "emitter" then
                    -- disabled for now
                    Emitter(P.grid_obj, i, j, o.key, o.bg, o.c, nil, nil, {o.r.key, o.r.bg, o.r.d, o.r.c})
                elseif id == "console" then
                    local vec = (o.ctype == 'output') and 'output' or o.data
                    local c = Console(P.grid_obj, i, j, 'console', true, o.color, nil, nil, {vec = vec, show_nums = o.preview_numbers, ctype = o.ctype})
                    c.r = o.dir
                elseif id == 'wall' then
                    Obstacle(P.grid_obj, i, j, o.img)
                else
                    print("Unrecognized object "..tostring(id).." at position ("..tostring(j)..", "..tostring(i)..").")
                end
            end
        end
    end

    -- Grid accessor
    local grid = {}
    local memo = setmetatable({}, {__mode = 'k'})
    for i = 1, ROWS do
        grid[i] = setmetatable({}, {
            __index = function(tab, j)
                if type(j) ~= 'number' or j < 1 or j > COLS then return nil end
                local obj = ROOM.grid_obj[j][i]
                if obj and not memo[obj] then
                    local o = {type = obj.tp}
                    if o.type == 'console' then
                        o.console_type = obj.ctype
                        o.list = obj.ctype == 'output' and obj.inp or obj.out
                        if obj.ctype ~= 'output' then
                            setmetatable(o, {__index = function(_, key)
                                if key == 'first_unread' then
                                    return obj.i
                                end
                            end})
                        end
                    end
                    memo[obj] = o
                end
                return obj and memo[obj] or nil
            end,
            __newindex = function()
                error("Cannot modify grid manually", 2)
            end
        })
    end
    grid = Util.deepReadOnly(grid)

    P.objective_text = extra.objective.text
    local check = extra.objective.check
    P.objective_checker = function()
        -- protect this call
        local ret = check(grid)
        if type(ret) == 'string' then
            StepManager.stop("Error", ret)
            return false
        end
        return ret == true
    end
    P.lines_on_terminal = extra.meta.lines <= 0 and 99 or extra.meta.lines
    P.memory_slots = extra.meta.memory
    P.extra_info = extra.meta.info
    P.on_start = function()
        -- pcal probably
        extra.meta.onStart(grid)
    end
    P.custom_completed = function()
        -- improve this
        local popup = extra.meta.popup
        if popup then
            local disc = function() ROOM:disconnect() end
            PopManager.new(popup.title, popup.text, popup.color,
                {func = disc, text = popup.button1.text, clr = popup.button1.color},
                popup.button2 and {func = disc, text = popup.button2.text, clr = popup.button2.color} or nil)
        end
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
    if not Mail.existsId(id) then
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
