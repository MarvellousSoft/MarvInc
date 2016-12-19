local LoreManager = require "classes.lore-manager"
local Mail = require "classes.tabs.email"
local OpenedMail = require "classes.opened_email"
local Info = require "classes.tabs.info"

local walkx = {}

-- Adds the puzzle that teaches using walk X

walkx.require_puzzles = {"first"}
walkx.wait = 4

function walkx.run()
    LoreManager.email.walkx = Mail.new("Keep going",
[[
Well done.

Besides directions, you can add another modifier to the walk command, a number. The test subject will then walk that many steps. This may sound worse than the original command, but it may be useful.

Example:
- walk 5
- walk left 10

Reply this email to start the experiment.

Keep up the good work, and carry on.
]], "Automated Introduction System", false,
    function()
        ROOM:connect("walkx")
        OpenedMail:close()
    end, true,
    function()
        Info.addCommand("walk <steps>")
        Info.addCommand("walk <direction> <steps>")
    end)

    LoreManager.timer.after(5, function()
    Mail.new("Terminal Tips",
[[
The <terminal> is a powerful tool.

As we said before, you should use it just like any text editor. To mention some of its features, you can

- Move the cursor with your mouse or arrow keys

- Select text with the mouse or holding shift and pressing the arrow keys

- Use the 'end' or 'home' keys

- And much more!

Exploring is part of the job, so get used to it.

Happy coding, and carry on.
]],
    "Automated Introduction System", true)
    end)
end

return walkx
