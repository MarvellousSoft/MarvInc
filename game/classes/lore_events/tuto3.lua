local LoreManager = require "classes.lore-manager"
local Mail = require "classes.tabs.email"
local OpenedMail = require "classes.opened_email"
local Info = require "classes.tabs.info"

local turn = {}

-- Adds the puzzle that teaches turn

turn.require_puzzles = {"walkx"}
turn.wait = 4

function turn.run()
    LoreManager.email.turn = Mail.new("Making good progress",
[[
Good job, Employee #]].. EMPLOYER_NUMBER .. [[. Lets learn some new instructions.

Use the turn command to, *surprise*, turn the test subject and change the direction he is facing. You can provide a direction, or the special arguments clock or counter, to turn the robot clockwise or counterclockwise, respectively.

Example:
    - turn south
    - turn clock
    - turn counter

You will need this for future tasks, so don't forget about it. Use the next room to apply this new command, and don't forget to check the objectives on the info tab.

As always, reply this email to start the puzzle.

Carry on.
]], "Automated Introduction System", false, 'turn',
    function()
        Info.addCommand("turn clock")
        Info.addCommand("turn counter")
        Info.addCommand("turn <direction>")
    end)

    LoreManager.timer.after(4, function()
    Mail.new("Useful Shortcuts",
[[
Here are some useful shortcuts to enhance your working experience here at Marvellous Inc.

- Ctrl + Enter: Starts the simulation.

- Space: Toggle play or pause for the simulation if its already running.

- PageDown/PageUp: Move between tabs.

- Up Arrow/Down Arrow: Scrolls your email list.

Remember them all. As we say here in Marvellous Inc. "Mice are for chumps and Larry from accounting".

Stay practical, and carry on.
]], "Automated Introduction System", true)
    end)
end

return turn
