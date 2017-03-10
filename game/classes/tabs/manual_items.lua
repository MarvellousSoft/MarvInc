--[[ Each item must be a table with the following fields
- command: name and paramenters of command
- text: explanation of command
- examples: array of Examples
- notes: possible extra notes (optional)

Each Example is an array with two strings, the first is the code, the second is the (possibly omitted) explanation of the example.
]]

local t = {}

t.walk = {
    command = "walk <value> <direction>",
    text = [[
The bot turns to <direction> and then the walks <value> steps. One or both of the parameters may be omitted. If <value> is omitted, the bot will walk until it finds an obstacle. If <direction> is omitted, then the bot will walk in the direction it is facing.

<value> must be greater than or equal 0. If it is equal to 0 the robot will turn (if a direction is given), but won't walk.]],
    examples = {{[[
walk 3 down # Walks 3 positions down
walk east # Walks right until it hits an obstacle]]}},
    notes = "In this command the order of the parameters may be switched, but in most other commands this won't work."
}

t.walk1 = {
    command = "walk <direction>",
    text = [[The bot turns to <direction> and then the walks until it finds an obstacle. If <direction> is omitted, the bot will walk in the direction it is facing.]],
    examples = {{[[walk east # Walks right until it hits an obstacle]]}}
}

t.walkc = {
    command = "walkc <address> <direction>",
    text = [[The bot turns to <direction>, walks until it finds an obstacle and then stores the number of steps walked in the register given by <address>. The argument <direction> is optional, and if omitted the bot will keep facing the same direction.]],
    examples = {{[[
walkc 0 up
pickup up
walk [0] down]], "With this code the bot will walk north until finding an obstacle, pick it up, and then return to the same position."}}
}

t.turn = {
    command = "turn <direction>",
    text = [[The bot will turn to <direction>. In this command, direction may assume two extra values: clock and counter, if one of these are given, the bot will turn clockwise or counterclockwise, respectively.]],
    examples = {{[[
turn clock
turn clock]], "This code will turn the robot to the oposite direnction it is facing"}}
}

t.jmp = {
    command = "jmp <label>",
    text = "The next code line executed will be the line labeled equal to <label>, instead of going to the next line. If <label> is a number, it will be evaluated first, that means jmp [5] will jump to the label that is the same as the number written in register #5.",
    examples = {{[[
lp: turn counter
walk 1
jmp lp]], "This code will make the bot walk endlessly in a 2x2 square, in counterclockwise direction."}, {[[
# Advanced Example
func: walkc 1
turn clock
turn clock
walk [1]
turn clock
turn clock
jmp [0]
...
...
mov 111 0
jmp func
111: # continue]], [[In this example, jumping to <func> will store in the register #1 the number of steps you can walk forward until hitting something, using the register #0 as a "return position". Jumping to this label may be seen as a simple function, since it can be called from anywhere and will return to where it was called.]]}}
}

t.pickup = {
    command = "pickup <direction>",
    text = [[
The bot will first turn to <direction>, and then pickup the object on the tile it is facing. The argument <direction> is optional, and if omitted the bot will keep facing the same direction.

If the bot tries to pick up an invalid object or its inventory is already full, you will get a Runtime Error. See "drop" for examples.]],
    examples = {}
}

t.drop = {
    command = "drop <direction>",
    text = [[
Analogous to pickup, but the bot will drop the object it is currently holding.

If the bot tries to drop the object in an invalid position or its inventory is empty, you will get a Runtime Error.]],
    examples = {{[[
pickup up
walk 1 down
drop]], "This code will pickup an object from the north and drop it 3 blocks down from where it was."}}
}

t.add = {
    command = "add <value1> <value2> <address>",
    text = [[The sum of <value1> and <value2> will be stored in the register with number <address>. See "sub" for examples.]],
    examples = {}
}

t.sub = {
    command = "sub <value1> <value2> <address>",
    text = [[The same as "add", but for subtraction.]],
    examples = {{[[
add [0] 1 0 # Increments the value in register #0 by 1
sub [7] [3] 1 # Stores in register #1 the value in register #7 subtracted by the value in register #3
sub 0 [5] 5 # Negates the value of register #5
add [1] [1] 1 # Doubles the value of register #1]]}}
}

t.mov = {
    command = "mov <value> <address>",
    text = [[Stores <value? in the register given by <address>. Notice that this is just a fancy version of "add value 0 address".]],
    examples = {{[[
mov [0] 1
mov [0] 2 # Copies the value of register #0 to registers #1 and #2]]}}
}

t.read = {
    command = "read <address> <direction>",
    text = [[
The bot turns to <direction> and then reads one number from the console it is facing, and stores it in the register given by <address>. The <direction> argument is optional, and if omitted the bot will read from the console in front of it.

If there are no more numbers on the console, you will get a Runtime Error. See "write" for examples.]],
    examples = {}
}

t.write = {
    command = "write <value> <direction>",
    text = [[
The bot turns to <direction> and then writes value to the console it is facing. The <direction> argument is optional, and if omitted the bot will write to the console in front of it.

Notice that it is different than "read" because it receives a value and not an address. That means reading from console to register #0 uses the command read 0, and writing to the console from the same register uses the command write [0]. Be careful.

If the the number is invalid (depends on the puzzle), you will get a Runtime Error.]],
    examples = {{[[
label: read 1 left
add [1] [1] 1
write [1] right
jmp label]], "This code reads values from the console on the left, and writes them, doubled, to the console on the right."}}
}

t.cond_jmps = {
    command = "j?? <value1> <value2> <label>",
    text = [[
For "jgt", if <value1> is greater than <value2>, then the next line executed will be the one labeled as <label>. That is, if <value1> is greater than <value2>, this instruction will be the same as "jmp <label>", otherwise, it will do nothing. Everything said about "jmp" also applies here.

The other commands work exactly like "jgt", except the condition to jump is different. Here is the list of all conditional jumps:

jgt: jumps if value1 > value2, that is, if value1 is greater than value2
jge: jumps if value1 ≥ value2, that is, if value1 is greater than or equal value2
jlt: jumps if value1 < value2, that is, if value1 is less than value2
jle: jumps if value1 ≤ value2, that is, if value1 is less than or equal value2
jeq: jumps if value1 = value2, that is, if value1 is equal value2
jne: jumps if value1 ≠ value2, that is, if value1 is not equal value2]],
    examples = {{[[
mov 10 [0]
666: write 1 left
sub [0] 1 0
jne [0] 0 666]], "This code writes 1 to the console on the left exactly 10 times. This is what you could call a for loop."}}
}

return t
