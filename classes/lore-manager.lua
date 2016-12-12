local Color = require "classes.color.color"
local StepManager = require "classes.stepmanager"
local Mail = require "classes.tabs.email"
local OpenedMail = require "classes.opened_email"
local Info = require "classes.tabs.info"
local lore = {}

local level_done = {}
local timer = Timer.new()

local function default_completed()
    PopManager.new("Puzzle completed (again)",
        "You did what you had already done, and possibly killed some more test subjects.\n\nGreat.",
        Color.yellow(), {
            func = function()
                ROOM:disconnect()
            end,
            text = "Go back",
            clr = Color.black()
        })

end


local email = {}
function lore.begin()

    local read_first_email = false
    timer.after(1, function()
    Mail.new("Welcome Employee #"..EMPLOYER_NUMBER,
    [[Greetings and Salutations!

We at Marvellous Inc. are happy to welcome one more member in our ever expanding AI company. We are all about Big Data, Internet of Things, Deep Data Mining Learning (DDML), real-time networks for cutting-edge technology and benchmarking cloud apps (built for scalability of course). We hope you can meet our standards, end-to-end.

As you know, your assignment will be to test our newly developed Artificial Inteligence Humanoids, or "robots". You will have to program their behaviour with simple commands so they can fulfill simple tasks. On the right part of screen you have direct access to a camera filming The Room. Test subjects (the "robots" of course) will be placed inside The Room, but you can only control them via your <terminal>.

This Automated System will guide you if you feel disoriented.

Most importantly, have fun and carry on :)]],

    "Automated Introduction System", false, function() ROOM:connect("pickup") end, false, lore.after_first_email)
    end)

function lore.after_first_email()
    timer.after(1, function()
        email.first = Mail.new("First Puzzle",
    [[There are many commands to control the test subjects. For now, you just need to know one: walk.

You can provide a cardinal direction (such as north or west) or a regular direction (such as up or left). If you don't, your robot will walk to the direction it is facing. This command will make the test subject walk until it encounters an obstacle.

Example:
    - walk
    - walk east
    - walk down

We are assured you are an expert, so no more instructions are needed. Complete the following puzzle quickly.

Reply this email to start the puzzle.

Best of Luck, and carry on.]], "Automated Introduction System", false,
        function()
            ROOM:connect("first")
            OpenedMail:close()
        end, true,
        function()
            Info.addCommand("walk")
            Info.addCommand("walk <direction>")
        end)
    end)

    timer.after(30, function()
        if level_done.first then return end
        Mail.new("Further instructions",
    [[It seems you have not understood this system completely. Let me explain it further.

There are three tabs: <email>, <terminal> and <info>. You are on the first one, and here you can read your emails. On the <terminal> tab you can write and run commands. For now you only need the one I taught you (walk) to solve this introductory puzzle. On the last tab, <info>, you can check the puzzle's objectives and the current test robot information.

Whenever you're lost, you can reread these emails. Unless you've deleted them.

Good Luck, and carry on.]],
    "Automated Introduction System", true, nil)
        end)

    timer.after(60, function()
        if level_done.first then return end
        Mail.new("Even further clarifications",
    [[It seems you still haven't finished the puzzle. Let me make everything clear.

You should head on to the <terminal> tab. No, not now. Finish reading this email first. There, you can code instructions to solve puzzles. You can only write one instruction per line, and you can use the <terminal> just as you would with any text editor.

After you write the instructions, use the buttons on the bottom of the <terminal> to run your code. You have three available speeds to choose from. Whenever your robot completes the objective, the puzzle will be finished automatically. If your code crashes or your robot dies, the simulation will be restarted and you'll receive a new test subject.

After replying a puzzle or job proposal, read the <info> tab to better understand your objectives in the room.

Any remaining doubts can be emailed to REDACTED.

Carry on.]],
    "Automated Introduction System", true, nil)
        end)

    timer.after(120, function()
        if level_done.first then return end
        Mail.new("Baby Steps",
    [[Well, we all have our hard days.

The problem consists of moving the robot to the red tile. The path is unique, so the instructions should be very direct. You should write the following code on your terminal, then
hit the play button to start the simulation.

walk left
walk up
walk right

Was it that hard? Take your time to understand these instructions. This will not happen again.

Carry on.]], "Automated Introduction System", true, nil)
        end)
    end

end

function lore.first_done()
    StepManager:pause()
    if level_done.first then default_completed() return end
    level_done.first = true

    PopManager.new("Puzzle completed",
        "You will be emailed you next task shortly.",
        Color.green(), {
            func = function()
                ROOM:disconnect()
            end,
            text = " Ok ",
            clr = Color.black()
        })

    email.first.is_completed = true

    timer.after(3, function()
    email.walkx = Mail.new("Keep going",
[[Well done.

Besides directions, you can add another modifier to the walk command, a number. The test subject will then walk that many steps. This may sound worse than the original command, but it may be useful.

Example:
- walk 5
- walk left 10

Reply this email to start the experiment.

Keep up the good work, and carry on.]], "Automated Introduction System", false,
        function()
                ROOM:connect("walkx")
                OpenedMail:close()
            end, true, function() Info.addCommand("walk <steps>") Info.addCommand("walk <direction> <steps>") end)
        end)

    timer.after(8, function()
    Mail.new("Terminal Tips",
[[The <terminal> is a powerful tool.

As we said before, you should use it just like any text editor. To mention some of its features, you can

- Move the cursor with your mouse or arrow keys

- Select text with the mouse or holding shift and pressing the arrow keys

- Use the 'end' or 'home' keys

- Copy, paste, cut, undo or redo with the usual shortcuts (ctrl+key)

- Autocomplete text with tab

- And much more!

Exploring is part of the job, so get used to it.

Happy coding, and carry on.]],
    "Automated Introduction System", true)
    end
    )
end

function lore.walkx_done()
    StepManager:pause()
    if level_done.walkx then default_completed() return end
    level_done.walkx = true

    PopManager.new("Puzzle completed",
        "You will be emailed you next task shortly.",
        Color.green(), {
            func = function()
                ROOM:disconnect()
            end,
            text = " Ok ",
            clr = Color.black()
        })

    email.walkx.is_completed = true

    timer.after(3, function()
    email.turn = Mail.new("Making good progress",
[[Good job, Employee #]].. EMPLOYER_NUMBER .. [[. Lets learn some new instructions.

Use the turn command to, *surprise*, turn the test subject and change the direction he is facing. You can provide a direction, or the special arguments clock or counter, to turn the robot clockwise or counterclockwise, respectively.

Example:
    - turn south
    - turn clock
    - turn counter

You will need this for future tasks, so don't forget about it. Use the next room to apply this new command, and don't forget to check the objectives on the info tab.

As always, reply this email to start the puzzle.

Carry on.]], "Automated Introduction System", false,
    function()
        ROOM:connect("turn")
        OpenedMail:close()
    end, true, function() Info.addCommand("turn clock") Info.addCommand("turn counter") Info.addCommand("turn <direction>") end)
    end)

    timer.after(8, function()
    Mail.new("Useful Shortcuts",
[[Here are some useful shortcuts to enhance your working experience here at Marvellous Inc.

- Ctrl + Enter: Starts the simulation.

- Space: Toggle play or pause for the simulation if its already running.

- PageDown/PageUp: Move between tabs.

- Up Arrow/Down Arrow: Scrolls your email list.

Remember them all. As we say here in Marvellous Inc. "Mouse are for chumps and Larry from accounting".

Stay practical, and carry on.]],
"Automated Introduction System", true)
    end
    )


end

function lore.turn_done()
    StepManager:pause()
    if level_done.turn then default_completed() return end
    level_done.turn = true

    PopManager.new("Puzzle completed",
        "You will be emailed you next task shortly.",
        Color.green(), {
            func = function()
                ROOM:disconnect()
            end,
            text = " Ok ",
            clr = Color.black()
        })

    email.turn.is_completed = true


    timer.after(3, function()
    email.jmp = Mail.new("Lets use some loops",
[[Remember loops from Hacking101 classes? Well, you better.

The new command is jmp. You provide a label, and it will jump to the line you defined the label on.

To define a label, just write any single alphanumeric word (that means only letters and numbers, dummy) followed by a ':'.

After defining a label, you can write any one command in the same line, however the label must come before the command.
But that is optional.

Example that makes the bot walking in circles:
- banana:
- walk 2
- turn counter
- jmp banana

Example that makes the bot spining endlessly:
    - awesomeLabel66: turn clock
    - jmp awesomeLabel66

Complete this puzzle quickly. We'd greatly appreciate. Don't forget the experiment ends ass soon as the objective requirements are completed.


As always, carry on.]], "Automated Introduction System", false,
        function()
            ROOM:connect("jump")
            OpenedMail:close()
        end, true, function() Info.addCommand("jmp <label>") Info.addCommand("label:") end)
        end)

end

function lore.jmp_done()
    StepManager:pause()
    if level_done.jmp then default_completed() return end
    level_done.jmp = true

    PopManager.new("Puzzle completed",
        "You will be emailed you next task shortly.",
        Color.green(), {
            func = function()
                ROOM:disconnect()
            end,
            text = " Ok ",
            clr = Color.black()
        })

    email.jmp.is_completed = true

    timer.after(3, function()
    email.pickup = Mail.new("Working with a backpack",
[[Did you know you have an inventory?

You can pickup and drop objects, such as giant buckets, with the commands pickup and drop. They both receive the same optional argument, a direction. When provided, the pickup command will make the robot turn and pick any object facing that direction. If you don't provide a direction, the subject will try to pick something in the direction he is facing.

The same is analogous for the drop command, but instead of picking objects, the robot will try to drop whatever he is holding in the inventory.

Example that makes the bot pickup an object from his left and placing on his right:
- pickup left
- drop right

The same example as above, if the robot was facing north:
- turn left
- pickup
- turn right
- drop

IMPORTANT: If the robots tries to pick something that isn't an object, drops something in a blocked space or drops something with an empty inventory, the simulation will throw and error.

Happy adventuring, and carry on.]], "Automated Introduction System", false,
        function()
            ROOM:connect("pickup")
            OpenedMail:close()
        end, true, function() Info.addCommand("pickup") Info.addCommand("pickup <direction>") Info.addCommand("drop") Info.addCommand("drop <direction>") end)
        end)

end

function lore.pickup_done()
    StepManager:pause()
    if level_done.pickup then default_completed() return end
    level_done.pickup = true

    PopManager.new("Puzzle completed",
        "You will be emailed you next task shortly.",
        Color.green(), {
            func = function()
                ROOM:disconnect()
            end,
            text = " Ok ",
            clr = Color.black()
        })

    email.pickup.is_completed = true

    timer.after(3, function()
    email.register = Mail.new("Using memory",
[[Let's jump up a notch. You will now learn to use the registers in your terminal, the write and the add commands.

Registers can hold values. Think of them as the memory in your terminal. To access the content of the register #n, just write [n]. So if you want the value in the register #5, you would ahve to write [5].

The add command receives two arguments: the first is the position

add <position> <value>
write <value> <direction>
write <value>

The new command is jmp. You provide a label, and it will jump to the line you defined the label on.

To define a label, just write any single alphanumeric word (that means only letters and numbers, dummy) followed by a ':'.

After defining a label, you can write any one command in the same line, however the label must come before the command.
But that is optional.

Example that makes the bot walking in circles:
- banana:
- walk 2
- turn counter
- jmp banana

Example that makes the bot spining endlessly:
    - awesomeLabel66: turn clock
    - jmp awesomeLabel66

Complete this puzzle quickly. We'd greatly appreciate.


As always, carry on.]], "Automated Introduction System", false,
        function()
            ROOM:connect("register")
            OpenedMail:close()
        end, true, function() Info.addCommand("add <position> <value>") Info.addCommand("write <value>") Info.addCommand("write <value> <direction>") end)
        end)

end

function lore.register_done()
    StepManager:pause()
    if level_done.register then default_completed() return end
    level_done.register = true

    -- PopManager.new("Puzzle completed",
    --     "You will be emailed you next task shortly.",
    --     Color.green(), {
    --         func = function()
    --             ROOM:disconnect()
    --         end,
    --         text = " Ok ",
    --         clr = Color.black()
    --     })

    email.register.is_completed = true

    PopManager.new("Congratulations!",
        "You have passed basic training. We at Marvellous Inc. proud ourselves on our "..
        "award-winning hands-on personnel training. A congratulatory golden star sticker has "..
        "been added to the coffee room employee board under your name. Every month we select "..
        "the highest golden sticker ranking employee and hang an Employee of the Month picture "..
        "in the coffee room for this outstanding and obedient member of the Marvellous Inc. "..
        "family. The current Employee of the Month for department [ROBOT TESTING] is [GABE "..
        "NEWELL JR].\n\n"..
        "And remember, efficiency means lower costs. And lower costs means fewer layoffs.\n\n"..
        "    - Christoff J. Kormen, Senior Assistant to the Training Manager",
        Color.blue(), {
            func = function()
                ROOM:disconnect()
            end,
            text = "Thank you for this wonderful opportunity",
            clr = Color.blue()
        })
end

function lore.jmp_done()
    StepManager:pause()
    if level_done.jmp then default_completed() return end
    level_done.jmp = true
    PopManager.new("Puzzle completed",
        "You will be emailed you next task shortly.",
        Color.green(), {
            func = function()
                ROOM:disconnect()
            end,
            text = "Ok",
            clr = Color.black()
        })
end

function lore.register_done()
    StepManager:pause()
    if level_done.register then default_completed() return end
    level_done.register = true
    PopManager.new("Puzzle completed",
        "You will be emailed you next task shortly.",
        Color.green(), {
            func = function()
                ROOM:disconnect()
            end,
            text = "Ok",
            clr = Color.black()
        })
end

function lore.update(dt)
    timer.update(dt)
end

return lore
