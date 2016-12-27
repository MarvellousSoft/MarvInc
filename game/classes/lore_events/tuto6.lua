local LoreManager = require "classes.lore-manager"
local Mail = require "classes.tabs.email"
local OpenedMail = require "classes.opened_email"
local Info = require "classes.tabs.info"

local register = {}

-- Adds the puzzle that teaches using registers

register.require_puzzles = {"pickup"}
register.wait = 4

function register.run()
    LoreManager.email.register = Mail.new("Using memory",
[[
Let's take it up a notch shall we? You will now learn to use the registers, and the write/add commands.

Registers can hold values. Think of them as the memory in your terminal. To access the content of the register #n, just write [n]. So if you want the value in the register #5, you write [5]. You can see them just below your terminal notepad, with their respective numbers and contents.
The add command receives two arguments: The adress of the register you will add a value, and the value you will add.

Example that adds the content of the register 5 in the register 2:
- add 2 [5]

Finally, the write command receives a value argument, and a second optional direction argument. You'll use the write command to write values in a console, which are the big colorful computer objects in The Room. The direction determines which direction the console is. If not provided, as usual, the robot will try to write in the direction he is facing.

Make sure to understand all these concepts. You can do it.

Best of Luck. Carry on. :)
]], "Automated Introduction System", false, 'register',
    function()
        Info.addCommand("add <adress> <value>")
        Info.addCommand("write <value>")
        Info.addCommand("write <value> <direction>")
    end)


    LoreManager.timer.after(8, function()
    Mail.new("More about consoles",
[[
As you were already told, consoles are the big colorful computers sitting around The Room. The robot can interact with them, writing output for them to receive, or reading input from them, as you will see in the future.

The color of the console usually represents what it can influence in the room, such as lasers or even other consoles.

The number above a console indicates how many inputs it can still provide to the bot, or how many outputs it has received from the bot. Use this for your advantage in planning programs.

That's it for now. Carry on.
]],  "Automated Introduction System", true)
    end)

    LoreManager.timer.after(12, function()
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

return register
