Meta.SetName "Sequence Separator"
Meta.SetRoomName "7"
Meta.SetLines(30)
Meta.SetMemory(5)

Meta.SetObjectiveText "Read up to 50 numbers from the green console, write the negative numbers to the blue console, and the non-negative numbers to the red console."
Meta.SetExtraInfo {
  "The conditional jumps are jgt, jge, jlt, jle, jeq and jne; to check for greater than, greater or equal, ...you get it.",
  "The inputs are randomly generated, don't try to memorize them."
}

local vec = {}
local neg, pos = {}, {}
local random = math.random
for i = 1, 50 do
	if i == 17 then
		vec[i] = 0
	else
		vec[i] = random(-99, 99)
	end
	if vec[i] < 0 then
		table.insert(neg, vec[i])
	else
		table.insert(pos, vec[i])
	end
end

Meta.SetObjectiveCheck(function(grid)
    local e = grid[17][5]
	local negs = Util.CheckConsoleOutput(e, neg)
	local d = grid[17][17]
	local poss = Util.CheckConsoleOutput(d, pos)
	if type(negs) == 'string' then return negs end
	if type(poss) == 'string' then return poss end
	return negs and poss
end)

local e = Console {
  color = "blue",
  type  = "output",
  dir   = "west",
}

local d = Console {
	color = "red",
	type  = "output",
	dir = "east",
}

local c = Console {
	color = "green",
	type  = "input",
	dir   = "north",
	data  = vec
}

local w = Wall {}
Objects.Register(w, 'o')
Objects.Register(e, 'e')
Objects.Register(c, 'c')
Objects.Register(d, 'd')
-- The Object Layer (string).
Objects.SetAll("ooooooooooooooooooooo"..
               "ooooooooooooooooooooo"..
               "ooooooooooooooooooooo"..
               "oooooooooo.oooooooooo"..
               "oooooooooo.oooooooooo"..
               "oooooooooo.oooooooooo"..
               "oooooooooo.oooooooooo"..
               "oooooooooo.oooooooooo"..
               "oooooooooo.oooooooooo"..
               "oooooooooo.oooooooooo"..
               "oooooooooo.oooooooooo"..
               "oooooooooo.oooooooooo"..
               "oooooooooo.oooooooooo"..
               "oooooooooo.oooooooooo"..
               "oooooooooo.oooooooooo"..
               "oooooooooo.oooooooooo"..
               "ooood...........eoooo"..
               "oooooooooocoooooooooo"..
               "ooooooooooooooooooooo"..
               "ooooooooooooooooooooo"..
               "ooooooooooooooooooooo")

Bot.SetPosition(4, 11)
Bot.SetOrientation "south"

Meta.SetCompletedPopup {
    title = "Congrats",
    text  = "You finished the custom copy of the seventh level.",
    color = "blue",
    button1 = {
        text = "k tks",
        color = "red",
    },
    button2 = {
        text = "fuck u",
        color = "black"
    }
}
