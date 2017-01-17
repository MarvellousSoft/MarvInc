name = "True Democracy"
n = "B.2"

lines_on_terminal=20
memory_slots=2

-- Bot
bot = {'b', "EAST"}

o = {"obst", false, "wall_none"}
e = nil

y_c = {c = 'y', x=-1, y=-1, l=1, s = 0}
n_c = {c = 'm', x=-1, y=-1, l=0, s = 0}
a_c = {c = 'a', x=-1, y=-1, l=-1, s = 0}
consoles = {y_c, n_c, a_c}

local function create_votes()
    -- Total number of votes.
    local votes = 125
    -- The true vote partition.
    local p = {0.4, 0.5, 0.1}

    local _r = 0
    for i in _G.ipairs(p) do
        p[i] = _G.math.floor(p[i]*votes)
        _r = _r + p[i]
    end
    p[2] = p[2] + votes-_r

    -- Add all votes to v.
    local v = {}
    local _n = #p
    for i=1, _n do
        for j=1, p[i] do
            _G.table.insert(v, consoles[i].l)
        end
    end

    -- Shuffle v.
    _n = votes
    while _n > 1 do
        local i = _G.math.random(_n)
        v[i], v[_n] = v[_n], v[i]
        _n = _n - 1
    end

    return v
end

-- Stack
s = {"console", true, "console", "orange", args = create_votes(), dir = "NORTH"}

-- Yay
y = {"console", true, "console", "green", args = {}, dir = "SOUTH"}
-- Nay
m = {"console", true, "console", "red", args = {}, dir = "SOUTH"}
-- Abstention
a = {"console", true, "console", "white", args = {}, dir = "SOUTH"}

objective_text = "- The orange console contains the votes. Each number is a label of a vote. "..
                   "Store them on their respective consoles.\n"..
                 "- The white console stores the abstentions(label=-1).\n"..
                 "- The red console stores the nays (label=0).\n"..
                 "- The green console stores the yays (label=1).\n"

extra_info = "LEGALIZE!"

grid_obj = "oooooooooooooooooooo"..
           "oeeeeeeeeeeeeeeeeeeo"..
           "oeeeeeeeeeeeeeeeeeeo"..
           "oeeeeeeeeeeeeeeeeeeo"..
           "oeeeeeeeeeeeeeeeeeeo"..
           "oeeeeeeeeeeeeeeeeeeo"..
           "oeeeeeeeeeeeeeeeeeeo"..
           "oeeeeeeeeeeeeeeeeeeo"..
           "oeeeeeeeeeeeeeeeeeeo"..
           "oeeeeeeeeeeeeeeeeeeo"..
           "oeeeeeeeeeeeeeeeeeeo"..
           "oeeeeeeeeeeeeeeeeeeo"..
           "oeeeeeeeeeeeeeeeeeeo"..
           "oeeeeeeeeeeeeeeeeeeo"..
           "oeeeeeeeeyameeeeeeeo"..
           "oeeeeeeeeeeeeeeeeeeo"..
           "oeeeeeeeeebeeeeeeeeo"..
           "oeeeeeeeeeeeeeeeeeeo"..
           "oeeeeeeeeeseeeeeeeeo"..
           "oooooooooooooooooooo"

-- Floor
D = "white_floor"
v = "black_floor"
x = "red_tile"

grid_floor = "vvvvvvvvvvvvvvvvvvvv"..
           "vvvvvvvvvvvvvvvvvvvv"..
           "vvvvvvvvvvDDvvvvvvvv"..
           "vvvvvvvvvvDDvvvvvvvv"..
           "vvvvDvvvvvDDvvvvvDvv"..
           "vvvvDDvvvvDDvvvvDDvv"..
           "vvvvvDDvvvDDvvvDDvvv"..
           "vvvvvDDDvvDDvvDDDvvv"..
           "vvvvvvDDvvDDvvDDvvvv"..
           "vvvvvvDDvvDDvvDDvvvv"..
           "vvDvvvvDDvDDvDDvvvDv"..
           "vvDDvvvDDvDDvDDvvDDv"..
           "vvvvDDvvDDDDDDvvDDvv"..
           "vvvvvDDDDDDDDDDDDDvv"..
           "vvvvvvvDDDDDDDDvvvvv"..
           "vvvvvvDDDvDDvDDDvvvv"..
           "vvvvvDDvvvDDvvvDDvvv"..
           "vvvvvvvvvvDDvvvvvvvv"..
           "vvvvvvvvvvDDvvvvvvvv"..
           "vvvvvvvvvvvvvvvvvvvv"

-- Find the positions of each console.
local x, y = 0, 1
local s_x, s_y = -1, -1
for i = 1, ROWS*COLS do
    x = x % ROWS + 1
    if i % COLS == 0 then
        y = y + 1
    end
    for _, v in _G.ipairs(consoles) do
        if grid_obj:sub(i, i) == v.c then
            v.x = x
            v.y = y
        elseif grid_obj:sub(i, i) == 's' then
            s_x, s_y = x, y
        end
    end
end

local function test(room)
    for _, v in _G.ipairs(consoles) do
        local _c = room.grid_obj[v.x][v.y]
        local _inp = _c.inp
        if #_inp > 0 then
            local _l  = _inp[#_inp]
            if _l == v.l then
                v.s = v.s + 1
            else
                _G.StepManager.stop("Wrong output", "Expected " .. v.l .. " got " .. _l, "Retry")
                return false
            end
        end
    end
    local _s = room.grid_obj[s_x][s_y]
    return _s.i > #_s.out
end

function objective_checker(room)
    return test(room)
end
