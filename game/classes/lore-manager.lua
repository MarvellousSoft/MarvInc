local Color = require "classes.color.color"
local StepManager = require "classes.stepmanager"
local Mail = require "classes.tabs.email"
local OpenedMail = require "classes.opened_email"
local Info = require "classes.tabs.info"
local FX = require "classes.fx"
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
[[
Greetings and Salutations!

We at Marvellous Inc. are happy to welcome one more member in our ever expanding AI company. We are all about Big Data, Internet of Things, Deep Data Mining Learning (DDML), real-time networks for cutting-edge technology and benchmarking cloud apps (built for scalability of course). We hope you can meet our standards, end-to-end.

As you know, your assignment will be to test our newly developed Artificial Inteligence Humanoids, or "robots". You will have to program their behaviour with simple commands so they can fulfill simple tasks. On the right part of screen you have direct access to a camera filming The Room. Test subjects (the "robots" of course) will be placed inside The Room, but you can only control them via your <terminal>.

This Automated System will guide you if you feel disoriented.

Most importantly, have fun and carry on :)
]],

    "Automated Introduction System", false, function() ROOM:connect("pickup") OpenedMail:close() end, false, lore.after_first_email)
    end)
end

function lore.after_first_email()
    timer.after(1, function()
        email.first = Mail.new("First Puzzle",
[[
There are many commands to control the test subjects. For now, you just need to know one: walk.

You can provide a cardinal direction (such as north or west) or a regular direction (such as up or left). If you don't, your robot will walk to the direction it is facing. This command will make the test subject walk until it encounters an obstacle.

Example:
    - walk
    - walk east
    - walk down

We are assured you are an expert, so no more instructions are needed. Complete the following puzzle quickly.

Use the two buttons to the right of the play button to move your bot faster.

Reply this email to start the puzzle.

Best of Luck, and carry on.
]], "Automated Introduction System", false,
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
[[
It seems you have not understood this system completely. Let me explain it further.

There are three tabs: <email>, <terminal> and <info>. You are on the first one, and here you can read your emails. On the <terminal> tab you can write and run commands. For now you only need the one I taught you (walk) to solve this introductory puzzle. On the last tab, <info>, you can check the puzzle's objectives and the current test robot information.

Whenever you're lost, you can reread these emails. Unless you've deleted them.

Good Luck, and carry on.
]],
    "Automated Introduction System", true, nil)
    end)

    timer.after(60, function()
        if level_done.first then return end
        Mail.new("Even further clarifications",
[[
It seems you still haven't finished the puzzle. Let me make everything clear.

You should head on to the <terminal> tab. No, not now. Finish reading this email first. There, you can code instructions to solve puzzles. You can only write one instruction per line, and you can use the <terminal> just as you would with any text editor.

After you write the instructions, use the buttons on the bottom of the <terminal> to run your code. You have three available speeds to choose from. Whenever your robot completes the objective, the puzzle will be finished automatically. If your code crashes or your robot dies, the simulation will be restarted and you'll receive a new test subject.

After replying a puzzle or job proposal, read the <info> tab to better understand your objectives in the room.

Any remaining doubts can be emailed to REDACTED.

Carry on.
]],
        "Automated Introduction System", true, nil)
    end)

    timer.after(120, function()
        if level_done.first then return end
        Mail.new("Baby Steps",
[[
Well, we all have our hard days.

The problem consists of moving the robot to the red tile. The path is unique, so the instructions should be very direct. You should write the following code on your terminal, then
hit the play button to start the simulation.

walk left
walk up
walk right

Was it that hard? Take your time to understand these instructions. This will not happen again.

Carry on.
]], "Automated Introduction System", true, nil)
    end)
end

function lore.first_done()
    StepManager:pause()
    if level_done.first then default_completed() return end
    level_done.first = true

    PopManager.new("Puzzle completed",
        "You will be emailed your next task shortly.",
        Color.green(), {
            func = function()
                ROOM:disconnect()
            end,
            text = " ok ",
            clr = Color.black()
        })

    email.first.is_completed = true

    timer.after(4, function()
    email.walkx = Mail.new("Keep going",
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
            end, true, function() Info.addCommand("walk <steps>") Info.addCommand("walk <direction> <steps>") end)
        end)

    timer.after(8, function()
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

function lore.walkx_done()
    StepManager:pause()
    if level_done.walkx then default_completed() return end
    level_done.walkx = true

    PopManager.new("Puzzle completed",
        "You will be emailed your next task shortly.",
        Color.green(), {
            func = function()
                ROOM:disconnect()
            end,
            text = " ok ",
            clr = Color.black()
        })

    email.walkx.is_completed = true

    timer.after(4, function()
    email.turn = Mail.new("Making good progress",
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
]], "Automated Introduction System", false,
    function()
        ROOM:connect("turn")
        OpenedMail:close()
    end, true, function() Info.addCommand("turn clock") Info.addCommand("turn counter") Info.addCommand("turn <direction>") end)
    end)

    timer.after(8, function()
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

function lore.turn_done()
    StepManager:pause()
    if level_done.turn then default_completed() return end
    level_done.turn = true

    PopManager.new("Puzzle completed",
        "You will be emailed your next task shortly.",
        Color.green(), {
            func = function()
                ROOM:disconnect()
            end,
            text = " ok ",
            clr = Color.black()
        })

    email.turn.is_completed = true


    timer.after(4, function()
    email.jmp = Mail.new("Lets use some loops",
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
]], "Automated Introduction System", false,
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
        "You will be emailed your next task shortly.",
        Color.green(), {
            func = function()
                ROOM:disconnect()
            end,
            text = " ok ",
            clr = Color.black()
        })

    email.jmp.is_completed = true

    timer.after(4, function()
    email.pickup = Mail.new("Working with a backpack",
[[
Did you know you have an inventory?

You can pickup and drop objects, such as giant buckets, with the commands pickup and drop. They both receive the same optional argument, a direction. When provided, the pickup command will make the robot turn and pick any object facing that direction. If you don't provide a direction, the subject will try to pick something in the direction he is facing. In both cases he puts the object in your inventory, located below your notepad in the terminal.

The same is analogous for the drop command, but instead of picking objects, the robot will try to drop whatever he is holding in the inventory.

Example that makes the bot pickup an object from his left and placing on his right:
- pickup left
- drop right

The same example as above, if the robot was facing north:
- turn counter
- pickup
- turn right
- drop

Happy adventuring, and carry on.
]], "Automated Introduction System", false,
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
        "You will be emailed your next task shortly.",
        Color.green(), {
            func = function()
                ROOM:disconnect()
            end,
            text = " ok ",
            clr = Color.black()
        })

    email.pickup.is_completed = true

    timer.after(4, function()
    email.register = Mail.new("Using memory",
[[
Let's take it up a notch shall we? You will now learn to use the registers, and the write/add commands.

Registers can hold values. Think of them as the memory in your terminal. To access the content of the register #n, just write [n]. So if you want the value in the register #5, you write [5]. You can see them just below your terminal notepad, with their respective numbers and contents.
The add command receives two arguments: The adress of the register you will add a value, and the value you will add.

Example that adds the content of the register 5 in the register 2:
- add 2 [5]

Finally, the write command receives a value argument, and a second optional direction argument. You'll use the write command to write values in a console, which are the big colorful computer objects in The Room. The direction determines which direction the console is. If not provided, as usual, the robot will try to write in the direction he is facing.

Make sure to understand all these concepts. You can do it.

Best of Luck. Carry on. :)
]], "Automated Introduction System", false,
        function()
            ROOM:connect("register")
            OpenedMail:close()
        end, true, function() Info.addCommand("add <adress> <value>") Info.addCommand("write <value>") Info.addCommand("write <value> <direction>") end)
    end)


    timer.after(8, function()
    Mail.new("More about consoles",
[[
As you were already told, consoles are the big colorful computers sitting around The Room. The robot can interact with them, writing output for them to receive, or reading input from them, as you will see in the future.

The color of the console usually represents what it can influence in the room, such as lasers or even other consoles.

The number above a console indicates how many inputs it can still provide to the bot, or how many outputs it has received from the bot. Use this for your advantage in planning programs.

That's it for now. Carry on.
]],  "Automated Introduction System", true)
    end)

    timer.after(12, function()
    Mail.new("Some more register examples",
[[
Here are some more examples to get you used to the register, write command and add command.

In this example, the bot will write to a console facing his left the content of the register #8
- turn left
- write [8]

This next example does the same thing as before, but with less lines of code
- write [8] left

Example of adding the number inside the register 10 by itself (aka multiplying it by two)
- add 10 [10]

Shine on and carry on.
]],  "Automated Introduction System", true)
    end)

end

function lore.register_done()
    StepManager:pause()
    if level_done.register then default_completed() return end
    level_done.register = true

    PopManager.new("Puzzle completed",
        "You will be emailed your next task shortly.",
        Color.green(), {
            func = function()
                ROOM:disconnect()
            end,
            text = " ok ",
            clr = Color.black()
        })

    email.register.is_completed = true

    timer.after(4, function()
    email.array_sep = Mail.new("Comparing and jumping",
[[
We are almost finished with the introdutory puzzles.

We now introduce the conditional jumps. There are several of them, and shortly you'll receive an email explaining what condition each one represent.

They all receive three arguments: two values and a label. If the condition of the jump is satisfied, it will jump to the label, just like a normal jmp. If the condition returns false, it will just go to the next instruction as if nothing happened.

For instance, the jgt command is the Greater Than Jump. So if the first value received is greater than the second one, it will jump to the label given as a third argument.

Example where the bot will increase the value of the register 1 until its greater than the value of the register 2. Only then it will walk 1 tile.
    - omar: add 1 1
    - jgt [1] [2] omar
    - walk 1

Lastly you can use the read command to read input from a console. You provide a first argument with the address of the register to store the input read, and a second optional direction, analogous to the write.

Carry on.
]], "Automated Introduction System", false,
        function()
            ROOM:connect("array_sep")
            OpenedMail:close()
        end, true, function() Info.addCommand("jgt <value> <value> <label>") Info.addCommand("jge <value> <value> <label>") Info.addCommand("jlt <value> <value> <label>") Info.addCommand("jle <value> <value> <label>") Info.addCommand("jeq <value> <value> <label>") Info.addCommand("jne <value> <value> <label>") Info.addCommand("read <address>") Info.addCommand("read <address> <direction>") end)
    end)


    timer.after(8, function()
    Mail.new("Conditional Jumps",
[[
Here are is a list of all conditional jumps and their meaning. You can also see them at the info tab when there isn't any simulation running.

- jgt - Greater Than, jumps if first value is greater than the second

- jge - Greater or Equal, jumps if first value is greater than or equal to the second

- jlt - Lesser Than, jumps if first value is less than the second

- jle - Lesser or Equal, jumps if first value is less than or equal to the second

- jeq - Equal, jumps if first value is equal to the second

- jne - Not Equal, jumps if first value is not equal to the second

Always use the one most adequate to the situation. And don't forget that you can reference contents of registers.

Stay fresh, and carry on.]],
    "Automated Introduction System", true)
    end)

    timer.after(14, function()
    Mail.new("Some read command examples",
[[
In case you need some further guidance, here are some examples using the read command and conditional jumping.

Example where the bot reads an input from the console below him, and writes in the console above him. In both cases he is using the register #0 to store the values.
    - read 0 down
    - write [0] up

Example where the bot will keep reading the input from the console to his left (west) until it equals the input he got from the console to his right (east). Then he will be able to walk down
    - read 0 east
    - marv: read 1 west
    - jne [0] [1] marv
    - walk down

With the read command you can read inputs from the consoles, while with the write you can output to the consoles.

Use the conditional jumps to make logical loops for your programs. Understanding all this is essencial for every member of our company.

Follow you dreams, and carry on.
]], "Automated Introduction System", true)
    end)

end

function lore.array_sep_done()
    StepManager:pause()
    if level_done.array_sep then default_completed() return end
    level_done.array_sep = true

    PopManager.new("Puzzle completed",
        "You will be emailed your next task shortly.",
        Color.green(), {
            func = function()
                ROOM:disconnect()
            end,
            text = " ok ",
            clr = Color.black()
        })

    email.array_sep.is_completed = true


    timer.after(4, function()
    email.square = Mail.new("Final puzzle",
[[
This is it. The last things we have to teach you. The rest is on your own.

The command mov is used to move values to an address. The first argument is the address, and the second argument the value you'll move to that address.

There is also the command sub. It works analogous to the add command, but instead of adding the second argument to the address provided in the first argument, it will subtract.

Example where the bot will move the content of the register #7 to the register #3, and then subtract it by 4
    - mov 3 [7]
      sub 3 4

Prove yourself worthy, employee #]]..EMPLOYER_NUMBER..[[.

We are waiting you.

Carry on.
]], "Automated Introduction System", false,
            function()
                ROOM:connect("square")
                OpenedMail:close()
            end, true, function() Info.addCommand("mov <address> <value>") Info.addCommand("sub <address> <value>") end)
            end)

timer.after(8, function()
Mail.new("New ways to handle values",
[=[
Since you've reached this far, you have proven yourself almost qualified to work on our most professional jobs, here at Marvellous Inc. Here are some advanced ways to manipulate values and addresses.

You already know that [8] represents the value inside the register #8, but did you know you can also write [[8]]? This returns the content inside the register whose number is the content inside the register 8! This may sound confusing, but here is an example so you can better understand.

We have the register #1 with the content 50, and the register #5 with the content 1. Now look at the following code:
    - walk [[5]]

This will make the robot walk 50 spaces forward, since [5] equals to 1, and [1] equals to 50.

You can keep adding []'s as many times as you like to a value, such as [[[[5]]]], referencing deeper and deeper registers. Just make sure you won't try to access a register with an invalid number.

As an almost professional in this area, you should learn well this technique, since it will be crucial for more challenging jobs.

Never stop learning, and carry on.
]=], "Automated Introduction System", true)
    end)

end

local function after_pop()
    ROOM:disconnect(false)
    FX.full_static()
    ROOM.version = "2.0"
end

function lore.square_done()
    StepManager:pause()
    if level_done.square then default_completed() return end
    level_done.square = true
    email.square.is_completed = true

    PopManager.new("Congratulations!",
    "You have passed basic training. We at Marvellous Inc proud ourselves on our "..
         "award-winning hands-on personnel training. A congratulatory golden star sticker has "..
         "been added to the coffee room employee board under your name. Every month we select "..
         "the highest golden sticker ranking employee and hang an Employee of the Month picture "..
         "in the coffee room for this outstanding and obedient member of the Marvellous Inc "..
         "family. The current Employee of the Month for department [ROBOT TESTING] is [GABE "..
         "NEWELL JR].\n\n"..
         "And remember, efficiency means lower costs. And lower costs means fewer layoffs.\n\n"..
         "    - Christoff J. Kormen, Senior Assistant to the Training Manager",
        Color.blue(), {
            func = after_pop,
            text = "Thank you for this wonderful opportunity",
            clr = Color.blue()
        })

    timer.after(6, function()
    email.maze1 = Mail.new("Congraaaaattts!!1!",
[[
Hey theeeere!

congrats on nailing the job man,  been a while since we had new slavs coming here kkkk jsut kiddin ;P

im ur new boss, but no need to formalities right? hahaha call me jenny btw

u probly realized we updated your OS to the 2.0 ver. it should have downloaded 1TB of RAM, so everything should run waaaay more smooth (y) .oh!and the updated office packge is off the roooof man! hahaha

aaanywho, youre probably itching for some ~real~ work huh?? we r tryin to tweak some details on the nav sys of the "robots" kk, but we are having some tech troubles.The main test room is still 2 unstable for u to handle right now, but we can send u the beta version and see if you can handle. btw this one can only handle 4 lines of code soooooo yeahh can u handle this job??

don't forget to carry on ;))).

jeNny Leubwoot
chief astronaut at marvellous soft.s KICKASS dojo
]], "Janine Leubwitz", false,
        function()
            ROOM:connect("maze1")
            OpenedMail:close()
        end, true, function()  end)
    end)


    timer.after(25, function()
    email.lasers = Mail.new("Need help",
[[
Hey man,

I'm Paul from the material engineering department. Look man, I got a situation here. Thing is, I told Lewis that I needed the new flux translator fluid for the gravitron kernel. Now, I know I too am to blame for relying on such a knucklehead as Lewis, but anyways. Well, Lewis told Kevin, the new intern, to go get the FTF. But what he forgot to mention was that we have a new security system that uses admantium-slicing lasers... And the FTF just happened to be tightly secured with motion sensor lasers... You see where this is going. As if it weren't bad enough having all the paperwork for dealing with an intern accidental death, the godamn lasers ended up setting the entrance to the bio chem lab on fire, which resulted in the BC guys ringing my phone all day demanding I put out the fire and send help. Anyways, Sarah got me your phone since you're in the "robots" department (seriously, what in the fuck do you guys do over there). I know you guys love challenges, so why not right? It's a win-win, huh? Look, I'll be in your debt forever if you do this for me. Like, I am totally tripping right now here, man. I can't deal with fire hazards right now, and Christoff is already asking questions around here. Give me a heads up if you're willing. And listen, man. Don't rat on me, bud, ok? I'll get you a stub once all this is over.

Trip on, my man

Paul Verkeufen
Chief engineer at Marvellous Inc.s Material Engineering Department

~ Puff puff puff I go / a joint a joint I roll for / so high puff puff puff ~
]], "Paul Verkeufen (hempman@med.marv.com)", false,
        function()
            ROOM:connect("lasers")
            OpenedMail:close()
        end, true, function() end)
    end)


end

function lore.lasers_done()
    StepManager:pause()
    if level_done.lasers then default_completed() return end
    level_done.lasers = true
    email.lasers.is_completed = true


    PopManager.new("You've fixed the fire hazard",
        "Paul will be relieved.",
        Color.green(), {
            func = function()
                ROOM:disconnect()
            end,
            text = "trip on",
            clr = Color.black()
        })
end

function lore.maze1_done()
    StepManager:pause()
    if level_done.maze1 then default_completed() return end
    level_done.maze1 = true
    email.maze1.is_completed = true

    PopManager.new("You've completed the job",
        "But is Jenny always this... energetic?",
        Color.green(), {
            func = function()
                ROOM:disconnect()
            end,
            text = " i hope not ",
            clr = Color.black()
        })

    timer.after(15, function()
    email.maze2 = Mail.new("My sincere apologies",
[[
Hello Employee #]]..EMPLOYER_NUMBER..[[

First of all, I own you my sincere apologies for my previous email. I had a little wine at my break hours, and I got carried away for a bit.

If you could erase it and pretend that it never happened, I would be grateful.

But at least the record show you have completed the beta version of our latest nIf Navigation System test room with perfection. I think you can handle the real deal now. Please let me know if you are willing to try it.

Again, I'm sorry for my lack of profissionalism, it will not happen again.
And please call me Janine at the work enviroment.

Carry on, now and forever.

Janine Leubwitz
Chief engineer at Marvellous Inc.s Robot Testing Department
]], "Janine Leubwitz (leubwitz@rtd.marv.com)", false,
        function()
            ROOM:connect("maze2")
            OpenedMail:close()
        end, true, function()  end)
    end)

end

function lore.maze2_done()
    StepManager:pause()
    if level_done.maze2 then default_completed() return end
    level_done.maze2 = true
    email.maze2.is_completed = true


    PopManager.new("You've completed the job",
[[
Jenny will want to hear about this.

You probably should call her Jenny.
]],
    Color.green(), {
        func = function()
            ROOM:disconnect()
        end,
        text = " ok ",
        clr = Color.black()
    })

    Mail.new("The End?", [[
On behalf of Marvellous Inc., we would like to thank you for playing this alpha version.

We will (possibly) add more content in the near future, so keep tuned to the github page or annoy us by sending emails.

This last puzzle is the hardest so far, but many harder will come later. Play on!

And, as always, carry on.]], "Marvellous Soft", false,
    function()
        ROOM:connect("simple_sort")
        OpenedMail:close()
    end, false)
end

function lore.simple_sort_done()
    StepManager:pause()
    if level_done.simple_sort then default_completed() return end
    level_done.simple_sort = true
    --email.xxxxx.is_completed = true


    PopManager.new("You've completed the game (so far)",
[[Send us an email and tell us what you think about the game!]],
    Color.green(), {
        func = function()
            ROOM:disconnect()
        end,
        text = " ok ",
        clr = Color.black()
    })
end



function lore.update(dt)
    timer.update(dt)
end

return lore
