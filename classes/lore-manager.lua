
local Mail = require "classes.tabs.email"
local OpenedMail = require "classes.opened_email"
local Info = require "classes.tabs.info"
local lore = {}

local level_done = {}
local timer = Timer.new()

local email1
function lore.begin()

    timer.after(0, function()
    Mail.new("Welcome Employee #"..EMPLOYER_NUMBER,
    [[Greetings and Salutations!

    We at Marvellous Inc. are happy to welcome one more member in our ever expanding AI company. We are all about Big Data, Internet of Things, Deep Data Mining Learning (DDML), real-time networks for cutting-edge technology and benchmarking cloud apps (built for scalability of course). We hope you can meet our standards, end-to-end.

    As you know, your assignment will be to test our newly developed Artificial Inteligence Humanoids, or "robots". You will have to program their behaviour with simple commands so they can fulfill simple tasks. On the right part of screen you have direct access to a camera filming The Room. Test subjects (the "robots" of course) will be placed inside The Room, but you can only control them via your <terminal>.

    This Automated System will guide you if you feel disoriented.

    Most importantly, have fun and carry on :)]],
    "Automated Introduction System", nil,
        function()
            ROOM:connect("first")
            OpenedMail:close()
        end, true
    )
    end)

timer.after(30, function()
    Info.addCommand("walk")
    Info.addCommand("walk <direction>")
    email1 = Mail.new("First Puzzle",
[[There are many commands to control the test subjects. For now, you just need to know one: walk.

You can provide a cardinal direction (such as north or west) or a regular direction (such as up or left). If you don't, your robot will walk to the direction it is facing. This command will make the test subject walk until it encounters an obstacle.

Example:
    - walk
    - walk east
    - walk down

We are assured you are an expert, so no more instructions are needed. The following puzzle will help you understand these concepts.

Reply this email to start the experiment.

Best of Luck, and carry on.]], "Automated Introduction System", false,
    function()
        ROOM:connect("first")
        OpenedMail:close()
    end, true)
end)

timer.after(80, function()
    if level_done.first then return end
    Mail.new("Further instructions",
[[It seems you have not understood this system completely. Let me explain it further.

There are three tabs: <email>, <terminal> and <info>. You are on the first one, and here you can read your emails. On the <terminal> tab you can write and run commands. For now you only need the one I taught you (walk) to solve this introductory puzzle. On the last tab, <info>, you can check the puzzle's objectives and the current test robot attributes.

Whenever you're lost, you can reread these emails. Unless you've deleted them.

Good Luck, and carry on.]],
"Automated Introduction System", true, nil)
    end)

timer.after(130, function()
    if level_done.first then return end
    Mail.new("Even further clarifications",
[[It seems you still haven't finished the puzzle. Let me make everything clear.

You should head on to the <terminal> tab. No, not now. Finish reading this email first. There, you can code instructions to solve puzzles. You can only write one instruction per line, and you can use the <terminal> just as you would with any text editor.

After you write the instructions, use the buttons on the bottom of the <terminal> to run your code. You have three available speeds to choose from. Whenever your robot completes the objective or he dies, the puzzle will be finished automatically. If your code crashes or your robot dies, the simulation will be restarted and you'll receive a new test subject.

After replying a puzzle proposal, read the <info> tab to better understand your objectives in the room. Since for now you only know the walk instruction, this first one shouldn't be that difficult.

Any remaining doubts can be emailed to REDACTED.

Carry on.]],
"Automated Introduction System", true, nil)
    end)

timer.after(160, function()
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

function lore.first_done()
    if level_done.first then return end
    level_done.first = true

    email1.is_completed = true

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

    Carry on.]],
    "Automated Introduction System", true, nil)

end

function lore.puzzle3()
end

function lore.update(dt)
    timer.update(dt)
end


return lore
