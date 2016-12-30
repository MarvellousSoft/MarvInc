local Info = require 'classes.tabs.info'

return {
    title = "Using memory",
    text = [[
Let's take it up a notch shall we? You will now learn to use the registers, and the write/add commands.

Registers can hold values. Think of them as the memory in your terminal. To access the content of the register #n, just write [n]. So if you want the value in the register #5, you write [5]. You can see them just below your terminal notepad, with their respective numbers and contents.
The add command receives two arguments: The adress of the register you will add a value, and the value you will add.

Example that adds the content of the register 5 in the register 2:
- add 2 [5]

Finally, the write command receives a value argument, and a second optional direction argument. You'll use the write command to write values in a console, which are the big colorful computer objects in The Room. The direction determines which direction the console is. If not provided, as usual, the robot will try to write in the direction he is facing.

Make sure to understand all these concepts. You can do it.

Best of Luck. Carry on. :)
]],
    author = "Automated Introduction System",
    puzzle_id = 'tuto6',
    open_func =
        function()
            Info.addCommand("add <adress> <value>")
            Info.addCommand("write <value>")
            Info.addCommand("write <value> <direction>")
        end
}
