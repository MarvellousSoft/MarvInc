local LoreManager = require "classes.lore-manager"
local Mail = require "classes.tabs.email"
local OpenedMail = require "classes.opened_email"
local Info = require "classes.tabs.info"

local array_sep = {}

-- Adds the puzzle "Array Separator"

array_sep.require_puzzles = {"register"}
array_sep.wait = 4

function array_sep.run()
    LoreManager.email.array_sep = Mail.new("Comparing and jumping",
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
    end, true,
    function()
        Info.addCommand("jgt <value> <value> <label>")
        Info.addCommand("jge <value> <value> <label>")
        Info.addCommand("jlt <value> <value> <label>")
        Info.addCommand("jle <value> <value> <label>")
        Info.addCommand("jeq <value> <value> <label>")
        Info.addCommand("jne <value> <value> <label>")
        Info.addCommand("read <address>")
        Info.addCommand("read <address> <direction>")
    end)


    LoreManager.timer.after(5, function()
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

    LoreManager.timer.after(11, function()
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

return array_sep
