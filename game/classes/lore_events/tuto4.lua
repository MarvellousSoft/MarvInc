local LoreManager = require "classes.lore-manager"
local Mail = require "classes.tabs.email"
local OpenedMail = require "classes.opened_email"
local Info = require "classes.tabs.info"

local jump = {}

-- Adds the puzzle that teaches jmp

jump.require_puzzles = {"turn"}
jump.wait = 4

function jump.run()
    LoreManager.email.jump = Mail.new("Lets use some loops",
[[
Remember loops from Hacking101 classes? Well, you better.

The new command is jmp. You provide a label, and it will jump to the line you defined the label on. To define a label, just write any single alphanumeric word (that means only letters and numbers, dummy) followed by a ':'.

After defining a label, you can write any one command in the same line, however the label must come before the command.
But that is optional.

Example that makes the bot walk in circles:
    - banana:
    - walk 2
    - turn counter
    - jmp banana

Example that makes the bot spin endlessly:
    - awesomeLabel66: turn clock
      jmp awesomeLabel66

Complete this puzzle quickly. We'd greatly appreciate it. Don't forget the experiment ends as soon as the objective requirements are completed.

As always, carry on.
]], "Automated Introduction System", false, 'jump',
    function()
        Info.addCommand("jmp <label>")
        Info.addCommand("label:")
    end)
end

return jump
