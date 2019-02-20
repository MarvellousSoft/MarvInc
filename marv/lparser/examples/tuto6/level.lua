Meta.SetName "Basic Programming"
Meta.SetRoomName "6"
Meta.SetLines(20)
Meta.SetMemory(3)

Meta.SetObjectiveText "Write all numbers from 1 to 50 on the green console."
Meta.SetExtraInfo {
    "After you outputted the 50 numbers, the code will stop automatically, so there is no need to do it manually.",
    "You can use write [X] to write to the console the value stored in register X (in this case you have available registers #0, #1 and #2)."
}

local desired_output = {}
for i = 1, 50 do
    desired_output[i] = i
end
Meta.SetObjectiveCheck(function(grid)
    local c = grid[10][15]
    return Util.CheckConsoleOutput(c, desired_output)
end)

local c = Console {
  color = "blue",
  type  = "output",
  dir   = "west",
}


local w = Wall {}
Objects.Register(w, 'o')
Objects.Register(c, 'c')
-- The Object Layer (string).
Objects.SetAll("ooooooooooooooooooooo"..
               "ooooooooooooooooooooo"..
               "ooooooooooooooooooooo"..
               "ooooooooooooooooooooo"..
               "ooooooooooooooooooooo"..
               "ooooooooooooooooooooo"..
               "ooooooooooooooooooooo"..
               "ooooooooooooooooooooo"..
               "ooooooooooooooooooooo"..
               "ooooooooo-----coooooo"..
               "ooooooooo-ooooooooooo"..
               "ooooooooo-ooooooooooo"..
               "ooooooooo-ooooooooooo"..
               "ooooooooo-ooooooooooo"..
               "ooooooooo-ooooooooooo"..
               "ooooooooo-ooooooooooo"..
               "ooooooooo-ooooooooooo"..
               "ooooooooooooooooooooo"..
               "ooooooooooooooooooooo"..
               "ooooooooooooooooooooo"..
               "ooooooooooooooooooooo")

Bot.SetPosition(17, 10)
Bot.SetOrientation "north"

Meta.SetCompletedPopup {
    title = "Congrats",
    text  = "You finished the custom copy of the sixth level.",
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
