Meta.SetName "Bucket Mover"
Meta.SetRoomName "D.1"
Meta.SetLines(99)
Meta.SetMemory(200)

Meta.SetObjectiveText "Move the buckets to the green tiles."

Meta.SetExtraInfo "Extra registers and lines of code in case you need it."

Meta.SetObjectiveCheck(function(grid)
    return grid[11][4] and grid[11][4].type == 'bucket'
        and grid[11][5] and grid[11][5].type == 'bucket'
end)

Floor.Register('green_tile', 'g')
Floor.PlaceAt('g', 11, 4)
Floor.PlaceAt('g', 11, 5)

local w = Wall {}
Objects.Register(w, 'o')
local b = Bucket {content = "water"}
Objects.Register(b, 'k')
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
               "ooooooooooooooooooooo"..
               "ooo.............kkooo"..
               "ooooooooooooooooooooo"..
               "ooooooooooooooooooooo"..
               "ooooooooooooooooooooo"..
               "ooooooooooooooooooooo"..
               "ooooooooooooooooooooo"..
               "ooooooooooooooooooooo"..
               "ooooooooooooooooooooo"..
               "ooooooooooooooooooooo"..
               "ooooooooooooooooooooo"..
               "ooooooooooooooooooooo")

Bot.SetPosition(11, 11)
Bot.SetOrientation "west"

Meta.SetCompletedPopup {
    title = "Congrats",
    text  = "You finished the custom copy of the first fergus level.",
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
