local Mail = require "classes.tabs.email"
local OpenedMail = require "classes.opened_email"
local lore = {}

local level_done = {}
local timer = Timer.new()

function lore.begin()
    timer.after(1.5, function()
    Mail.new("Welcome to room.hack [TEMPORARY]",
[[Hello. Help save the world. There are many commands.

For now, you just need to know one: walk. You can send a direction like north or east, or eveb left or up, if you prefer. If you don't, your robot will walk to the direction it is facing.

This command will walk until you encounter an obstacle.

Example:
    - walk
    - walk east
    - walk up

The following puzzle will help you understand these concepts. Please direct yourself to the red tile.

Good Luck, and carry on.]], "Automated Introduction System", false,
    function()
        ROOM:from(Reader("puzzles/first.lua"):get())
        OpenedMail:close()
    end)
    end)

    timer.after(30, function()
    if level_done.first then return end
    Mail.new("Further instructions",
[[It seems you have not understood this system completely. Let me explain it further.

There are three tabs: email, terminal and info. You are on the first one, and here you will read your emails. On the terminal tab you can use the commands I thaught you (walk) and solve these introductory puzzles. On the last tab, info, you can check you puzzle's objectives and you current test robot name and attributes.

Whenever you're lost, you can reread these emails. Unless you've deleted them.

Good Luck, and carry on.]],
"Automated Introduction System", true, nil)
    end)

    timer.after(60, function()
    if level_done.first then return end
    Mail.new("Even further clarifications",
[[It seems you still haven't finished the puzzle. Let me make everything clear.

You should head on to the Terminal tab. No, not now. Finish reading this email first. There, you can write your code to solve puzzles. Since for now you know only the walk instruction, it shouldn't be that complex.

After you write the instructions, use the buttons on the bottom to run your code. You have three available speeds to choose from. Whenever your robot reaches the red tile, the puzzle will be finished automatically.

Any remaining doubts can be emailed to REDACTED.

Good Luck, and carry on.]],
"Automated Introduction System", true, nil)
    end)

    timer.after(120, function()
    if level_done.first then return end
    Mail.new("Baby Steps",
[[Well, we all have our hard days.

The problem consists of moving the robot to the red tile. The path is unique, so the instructions should be very direct.

walk left
walk up
walk right

Was it that hard? Take your time to understand these instructions. This will not happen again.

Carry on.]], "Automated Introduction System", true, nil)
    end)
end

function lore.first_done()
    level_done.first = true
end

function lore.puzzle3()
end

function lore.update(dt)
    timer.update(dt)
end


return lore
