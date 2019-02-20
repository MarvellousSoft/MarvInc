Meta.SetName "Hello World"
Meta.SetRoomName "1"
Meta.SetLines(99)
Meta.SetMemory(0)

Meta.SetObjectiveText "Just get to the red tile. It's not that hard."

Meta.SetObjectiveCheck(function(grid)
    return grid[1][21] and grid[1][21].type == 'bot'
    -- This also works
    -- local i, j = Bot.GetPosition()
    -- return i == 1 and j == 21
end)

Floor.Register('red_tile', 'r')
Floor.PlaceAt('r', 1, 21)

local w = Wall {}
Objects.Register(w, 'o')
-- The Object Layer (string).
Objects.SetAll("ooooooooo------------"..
               "ooooooooo-ooooooooooo"..
               "ooooooooo-ooooooooooo"..
               "ooooooooo-ooooooooooo"..
               "ooooooooo-ooooooooooo"..
               "ooooooooo-ooooooooooo"..
               "ooooooooo-ooooooooooo"..
               "ooooooooo-ooooooooooo"..
               "ooooooooo-ooooooooooo"..
               "ooooooooo-ooooooooooo"..
               "ooooooooo-ooooooooooo"..
               "ooooooooo-ooooooooooo"..
               "ooooooooo-ooooooooooo"..
               "ooooooooo-ooooooooooo"..
               "ooooooooo-ooooooooooo"..
               "ooooooooo-ooooooooooo"..
               "ooooooooo-ooooooooooo"..
               "ooooooooo-ooooooooooo"..
               "ooooooooo-ooooooooooo"..
               "ooooooooo-ooooooooooo"..
               "ooooooooo------------")

Bot.SetPosition(21, 21)
Bot.SetOrientation "west"

Meta.SetCompletedPopup {
    title = "Congrats",
    text  = "You finished the custom copy of the first level.",
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
