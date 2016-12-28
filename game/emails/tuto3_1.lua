local Info = require 'classes.tabs.info'

return {
    title = "Making good progress",
    text = [[
Good job, Employee #]].. EMPLOYER_NUMBER .. [[. Lets learn some new instructions.

Use the turn command to, *surprise*, turn the test subject and change the direction he is facing. You can provide a direction, or the special arguments clock or counter, to turn the robot clockwise or counterclockwise, respectively.

Example:
    - turn south
    - turn clock
    - turn counter

You will need this for future tasks, so don't forget about it. Use the next room to apply this new command, and don't forget to check the objectives on the info tab.

As always, reply this email to start the puzzle.

Carry on.
]],
    author = "Automated Introduction System",
    puzzle_id = 'turn',
    open_func =
        function()
            Info.addCommand("turn clock")
            Info.addCommand("turn counter")
            Info.addCommand("turn <direction>")
        end
}
