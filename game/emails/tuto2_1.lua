local Info = require 'classes.tabs.info'

return {
    title = "Keep going",
    text = [[
Well done.

Besides directions, you can add another modifier to the walk command, a number. The test subject will then walk that many steps. This may sound worse than the original command, but it may be useful.

Example:
- walk 5
- walk left 10

Reply this email to start the experiment.

Keep up the good work, and carry on.
]],
    author = "Automated Introduction System",
    puzzle_id = 'tuto2',
    open_func =
        function()
            Info.addCommand("walk <steps>")
            Info.addCommand("walk <direction> <steps>")
        end
}
