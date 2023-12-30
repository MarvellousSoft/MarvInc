--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

name = "TIS-81"
n = "X.4"
test_count = 3

lines_on_terminal = 200
memory_slots = 200

-- Bot
bot = {'b', "NORTH"}

local env = _G.getfenv()
env['-'] = {"obst", false, "wall_none"}

-- Objective
objective_text = [[
Each console represents a node, and as input hhas a number N and then N instructions that are contained in that node.
Each node has a list of instructions it executes in order (except in the case of instruction 'j'), and two registers: ACC and BAK, that store two numbers and are initialized with 0's.
The instructions are:
    + X: Add X to the number in ACC.
    s: Swap the number in ACC with the number in BAK.
    j X: If ACC is not 0, jump to the X-th instruction. Otherwise, continue normally.
    m A B: Move the number from direction A to direction B. Both A and B might be either '.', meaning this console's ACC, or '<>^v', meaning another console in the given direction.
    r: Read a number from the green console and write it to ACC.
    w: Write the value of ACC to the blue console.
After reading the instructions, execute them on all nodes in parallel.]]

function objective_checker(room)
    if room.bot.inv then return false end
    for i = 1, _G.ROWS do
        for j = 1, _G.COLS do
            if room.grid_obj[j][i] and room.grid_obj[j][i].tp == 'bucket' then
                return false
            end
        end
    end

    return true
end

local scenarios = {}
_G.table.insert(scenarios, {
    inp = {1, 10, 20, 43},
    out = {7, 16, 26, 49},
    consoles = {
        {
            { -- 1.1
                3,
                "r",
                "+", 1,
                "m", ".", ">",
            }, { -- 1.2
                3,
                "m", "<", ".",
                "+", 2,
                "m", ".", ">",
            }, { -- 1.3
                1,
                "m < v", 
            }
        },
        {
            { -- 2.1
                3,
                "m", "v", ".",
                "+", 5,
                "m", ".", ">"
            }, { -- 2.2
                3,
                "m", "<", ".",
                "+", 6,
                "w",
            }, { -- 2.3
                3,
                "m", "^", ".",
                "+", 3,
                "m", ".", "v",
            }
        },
        {
            { -- 3.1
                1,
                "m", ">", "^",
            }, { -- 3.2
                3,
                "m", ">", ".",
                "+", 4,
                "m", ".", "<",
            }, { -- 3.3
                1,
                "m", "^", "<",
            }
        }
    }
})
_G.table.insert(scenarios, {
    inp = {1, 2, 5, 7, 13, 9},
    out = {3, 10, 12, 20, 22, 30},
    consoles = {
        {{0}, { -- 1.2
            9,
            "r", "s", "r",
            "+", -1,
            "s",
            "+", 1,
            "s",
            "j", 3,
            "m", ".", "v",
        }, {0}},
        {{0}, { -- 2.2
            4,
            "m", "^", ".",
            "w",
            "m", ">", ".",
            "w"
        }, {}},
        {{0}, { -- 3.2
            3,
            "+", 10,
            "m", ".", ".", -- trick, should do nothing
            "m", ".", "^",
        }, {0}}
    }
})
_G.table.insert(scenarios, {
    inp = {100, 200, 300, 400},
    out = {10, 101, 7, 301},
    consoles = {
        {{ -- 1.1
            2,
            "+", 1,
            "m", ".", ">",
        }, { -- 1.2
            6,
            "m", "<", ".",
            "m", "<", ".",
            "+", 5,
            "s",
            "m", ">", "v",
            "m", ".", "v",
        }, { -- 1.3
            2,
            "+", 10,
            "m", ".", "<",
        }}, {{ -- 2.1
            2,
            "+", 500,
            "m", ".", ">"
        }, { -- 2.2
            4,
            "m", "^", ".",
            "w",
            "m", ">", ".",
            "w"
        }, { --2.3
            8,
            "r",
            "s",
            "r",
            "s",
            "+", 1,
            "m", ".", "<",
            "s",
            "m", ".", "v",
        }}, {{ -- 3.1
            1,
            "m", ".", ">"
        }, { -- 3.2
            4,
            "m", ">", ".",
            "j", 3,
            "w",
            "m", "<", ".",
        }, { -- 3.3
            3,
            "m", "^", ".",
            "+", 50,
            "m", ".", "<",
        }}
    }
})

_G.assert(#scenarios == test_count)
local scenario = scenarios[current_test]

local function create_vec(j, i)
    local ci, cj = (i - 7) / 2, (j - 7) / 2
    return scenario.consoles[ci][cj]
end

i = {"console", false, "console", "green", args = {vec = scenario.inp, show_nums = 2}, dir = "south"}
c = {"console", false, "console", "gray", args = {vec = create_vec, show_nums = 0}, dir = "south"}
o = {"console", false, "console", "red", args = {vec = "output"}, dir = "north"}


extra_info =[[
The instruction 'm' blocks execution until a matching 'm' instruction from the other node executes.
- All 'm' instructions point to valid nodes.
- After the last instruction, a node goes back automatically to the first instruction.
- For the 'j' instruction, consider instructions start at 0.
- There are at most 30 instructions in total.
]]

grid_obj =   "---------------------"..
             "---------------------"..
             "---------------------"..
             "---...............---"..
             "---...............---"..
             "---...............---"..
             "---.......i.......---"..
             "---...............---"..
             "---.....c.c.c.....---"..
             "---.....b.........---"..
             "---.....c.c.c.....---"..
             "---...............---"..
             "---.....c.c.c.....---"..
             "---...............---"..
             "---.......o.......---"..
             "---...............---"..
             "---...............---"..
             "---...............---"..
             "---------------------"..
             "---------------------"..
             "---------------------"


-- Floor
w = "white_floor"
env[','] = "black_floor"

grid_floor = "wwwwwwwwwwwwwwwwwwwww"..
             "wwwwwww,wwwww,wwwwwww"..
             "wwwwww,w,www,w,wwwwww"..
             "wwwww,www,w,www,wwwww"..
             "wwww,wwwww,wwwww,wwww"..
             "www,wwwww,w,wwwww,www"..
             "ww,wwwww,www,wwwww,ww"..
             "w,wwwww,wwwww,wwwww,w"..
             "ww,www,wwwwwww,www,ww"..
             "www,w,wwwwwwwww,w,www"..
             "wwww,wwwwwwwwwww,wwww"..
             "www,w,wwwwwwwww,w,www"..
             "ww,www,wwwwwww,www,ww"..
             "w,wwwww,wwwww,wwwww,w"..
             "ww,wwwww,www,wwwww,ww"..
             "www,wwwww,w,wwwww,www"..
             "wwww,wwwww,wwwww,wwww"..
             "wwwww,www,w,www,wwwww"..
             "wwwwww,w,www,w,wwwwww"..
             "wwwwwww,wwwww,wwwwwww"..
             "wwwwwwwwwwwwwwwwwwwww"

local ans = scenario.out
function objective_checker(room)
    local bl = room.grid_obj[11][15]
    if #bl.inp == 0 then return false end
    if #bl.inp > #ans then
        _G.StepManager.stop("Wrong output", "Too many numbers! Your bot was sacrificed as punishment.")
        return false
    end
    for i = 1, #bl.inp do
        if bl.inp[i] ~= ans[i] then
            _G.StepManager.stop("Wrong output", "Expected " .. ans[i] .. " got " .. bl.inp[i]..". Your bot was sacrificed as punishment.")
            return false
        end
    end
    return #bl.inp == #ans
end