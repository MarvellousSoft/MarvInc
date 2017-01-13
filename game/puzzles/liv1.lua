name = "Reverse Sequences"
-- Puzzle number
n = "C.1"

lines_on_terminal = 40
memory_slots = 25

-- Bot
bot = {'b', "EAST"}


local function create_vec()
    local v = {}
    local szs = {3, 4, 1, 5, 20, 15}
    for _, sz in _G.ipairs(szs) do
        _G.table.insert(v, sz)
        for i = 1, sz do
            _G.table.insert(v, _G.love.math.random(-100, 100))
        end
    end
    return v
end


-- name, draw background, image
o = {"obst", false, "wall_none"}
c = {"console", false, "console", "green", args = create_vec, dir = "east"}
d = {"console", false, "console", "blue", args = {}, dir = "west"}

-- console objects
local gr, bl

local ans = {}

-- create ans vector
function on_start(room)
    -- finds consoles
    for i = 1, 20 do
        for j = 1, 20 do
            local o = room.grid_obj[i][j]
            if o and o.tp == 'console' then
                if #o.out > 0 then
                    gr = o
                else
                    bl = o
                end
            end
        end
    end
    -- creates answer
    local v, i = gr.out, 1
    while i <= #v do
        local n = v[i]
        _G.table.insert(ans, n)
        for j = n, 1, -1 do
            _G.table.insert(ans, v[i + j])
        end
        i = i + n + 1
    end
end

-- Objective
objective_text = [[
Read sequences from the green console and write them, reversed, to the blue console.]]
function objective_checker(room)
    if #bl.inp == 0 then return false end
    if #bl.inp > #ans then
        _G.StepManager.stop("Wrong output", "Too many numbers!", "Retry")
        return false
    end
    for i = 1, #bl.inp do
        if bl.inp[i] ~= ans[i] then
            _G.StepManager.stop("Wrong output", "Expected " .. ans[i] .. " got " .. bl.inp[i], "Retry")
            return false
        end
    end
    return #bl.inp == #ans
end


extra_info = [[
Each sequence is given by its size and then its elements.
- Example: 2 1 2 1 3 is sequence (1,2) and  (3) and the output should be 2 2 1 1 3.
- Sequences will have at most 20 elements.]]

grid_obj =  "oooooc.....doooooooo"..
            "oooooooooo.ooooooooo"..
            "ooooo......ooooooooo"..
            "ooooo.oooooooooooooo"..
            "ooooo........ooooooo"..
            "oooooooooooo.ooooooo"..
            "oooo.........ooooooo"..
            "oooo.ooooooooooooooo"..
            "oooo........oooooooo"..
            "ooooooooooo.oooooooo"..
            "ooooo.......oooooooo"..
            "ooooo.oooooooooooooo"..
            "ooooo......ooooooooo"..
            "oooooooooo.ooooooooo"..
            "oooooo.....ooooooooo"..
            "oooooo.ooooooooooooo"..
            "oooooo....oooooooooo"..
            "ooooooooo.oooooooooo"..
            "oooooooo..oooooooooo"..
            "oooooooobooooooooooo"

-- Floor
w = "white_floor"
v = "black_floor"
r = "red_tile"

grid_floor = "wvwvwvwvwvwvwvwvwvwv"..
             "vwvwvwvwvwvwvwvwvwvw"..
             "wvwvwvwvwvwvwvwvwvwv"..
             "vwvwvwvwvwvwvwvwvwvw"..
             "wvwvwvwvwvwvwvwvwvwv"..
             "vwvwvwvwvwvwvwvwvwvw"..
             "wvwvwvwvwvwvwvwvwvwv"..
             "vwvwvwvwvwvwvwvwvwvw"..
             "wvwvwvwvwvwvwvwvwvwv"..
             "vwvwvwvwvwvwvwvwvwvw"..
             "wvwvwvwvwvwvwvwvwvwv"..
             "vwvwvwvwvwvwvwvwvwvw"..
             "wvwvwvwvwvwvwvwvwvwv"..
             "vwvwvwvwvwvwvwvwvwvw"..
             "wvwvwvwvwvwvwvwvwvwv"..
             "vwvwvwvwvwvwvwvwvwvw"..
             "wvwvwvwvwvwvwvwvwvwv"..
             "vwvwvwvwvwvwvwvwvwvw"..
             "wvwvwvwvwvwvwvwvwvwv"..
             "vwvwvwvwvwvwvwvwvwvw"


function first_completed()
    _G.PopManager.new("Nice!",
        "But Fergus did it faster :B\n -- Liv",
        _G.Color.green(), {
            func = function()
                _G.ROOM:disconnect()
            end,
            text = " I'll get better ",
            clr = _G.Color.blue()
        },
        {
            func = function()
                _G.ROOM:disconnect()
                _G.LoreManager.timer:after(1, function()
                    _G.Mail.new('liv1_2')
                end)
                -- maybe Liv should say something
            end,
            text = " Well, fuck him ",
            clr = _G.Color.black()
        })
end
