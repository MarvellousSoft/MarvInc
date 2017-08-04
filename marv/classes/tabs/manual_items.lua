--[[ Each item must be a table with the following fields
- command: name and paramenters of command
- text: explanation of command
- examples: array of Examples
- notes: possible extra notes (optional)

Each Example is an array with two strings, the first is the code, the second is the (possibly omitted) explanation of the example.
]]

local t = {}

t.walk1 = {
    command = "{inst}walk {dir}<direction>",
    text = [[The bot turns to {dir}<direction>{end} and then the walks until it finds an obstacle. If {dir}<direction>{end} is omitted, the bot will walk in the direction it is facing.]],
    examples = {{[[{inst}walk {dir}east{end} {cmnt}# Walks right until it hits an obstacle]]}}
}

t.walk = {
    command = "{inst}walk {num}<value> {dir}<direction>",
    text = [[
The bot turns to {dir}<direction>{end} and then the walks {num}<value>{end} steps. One or both of the parameters may be omitted. If {num}<value>{end} is omitted, the bot will walk until it finds an obstacle. If {dir}<direction>{end} is omitted, then the bot will walk in the direction it is facing.

{num}<value>{end} must be greater than or equal to {num}0{end}. If it is equal to {num}0{end} the robot will turn (if a {dir}direction{end} is given), but won't walk.]],
    examples = {{[[
{inst}walk {num}3 {dir}down {cmnt}# Walks 3 positions down
{inst}walk {dir}east {cmnt}# Walks right until it hits an obstacle]]}},
    notes = "In this command the order of the parameters may be switched, but in most other commands this won't work."
}

t.walkc = {
    command = "{inst}walkc {addr}<address> {dir}<direction>",
    text = [[The bot turns to {dir}<direction>{end}, walks until it finds an obstacle and then stores the number of steps walked in the register given by {addr}<address>{end}. The argument {dir}<direction>{end} is optional, and if omitted the bot will keep facing the same direction.]],
    examples = {{[[
{inst}walkc {num}0 {dir}up
{inst}pickup {dir}up
{inst}walk {num}[0] {dir}down]], "With this code the bot will walk north until finding an obstacle, pick it up, and then return to the same position."}}
}

t.turn = {
    command = "{inst}turn {dir}<direction>",
    text = [[The bot will turn to {dir}<direction>{end}. In this command, direction may assume two extra values: {dir}clock{end} and {dir}counter{end}, if one of these are given, the bot will turn clockwise or counterclockwise, respectively.]],
    examples = {{[[
{inst}turn {dir}clock
{inst}turn {dir}clock]], "This code will turn the robot to the oposite direnction it is facing"}}
}

t.jmp1 = {
    command = "{inst}jmp {lab}<label>",
    text = "The next code line executed will be the line labeled equal to {lab}<label>{end}, instead of going to the next line.",
    examples = {{[[
{lab}lp: {inst}turn {dir}counter
{inst}walk {num}1
{inst}jmp {lab}lp]], "This code will make the bot walk endlessly in a 2x2 square, in counterclockwise direction."}}
}

t.jmp2 = {
    command = "{inst}jmp {lab}<label>",
    text = [[The next code line executed will be the line labeled equal to {lab}<label>{end}, instead of going to the next line. If {lab}<label>{end} is a number, it will be evaluated first, that means "{inst}jmp {num}[5]{end}" will jump to the label that is the same as the number written in register {addr}#5{end}.]],
    examples = {t.jmp1.examples[1], {[[
{inst}mov {num}5 {addr}0
{inst}jmp {lab}[0] ]], "This code will jump to label {lab}5{end}, but if register {addr}#0{end} had a different {num}value{end} it would (try to) jump to a different {lab}label{end}."}
    }
}

t.jmp = {
    command = t.jmp2.command,
    text = t.jmp2.text,
    examples = {t.jmp2.examples[1], t.jmp2.examples[2], {[[
{lab}lp: {inst}turn {dir}counter
{inst}walk {num}1
{inst}jmp {lab}lp]], "This code will make the bot walk endlessly in a 2x2 square, in counterclockwise direction."}, {[[
{cmnt}# Advanced Example
{lab}func: {inst}walkc {num}1
{inst}turn {dir}clock
{inst}turn {dir}clock
{inst}walk {num}[1]
{inst}turn {dir}clock
{inst}turn {dir}clock
{inst}jmp {lab}[0]{end}
...
...
{inst}mov {num}111 {addr}0
{inst}jmp {lab}func
{lab}111: {cmnt}# continue]], [[In this example, jumping to {lab}func{end} will store in the register {addr}#1{end} the number of steps you can walk forward until hitting something, using the register {addr}#0{end} as a "return position". Jumping to this {lab}label{end} may be seen as a simple function, since it can be called from anywhere and will return to where it was called.]]}}
}

t.pickup1 = {
    command = "{inst}pickup {dir}<direction>",
    text = [[
The bot will first turn to {dir}<direction>{end}, and then pickup the object on the tile it is facing. The argument {dir}<direction>{end} is optional, and if omitted the bot will keep facing the same direction.

If the bot tries to pick up an invalid object or its inventory is already full, you will get a Runtime Error. See {inst}drop{end} for examples.]],
    examples = {}
}

t.pickup = {
    command = t.pickup1.command,
    text = t.pickup1.text,
    examples = {},
    notes = [[
It is possible to pick up paint from a paint container by having an empty bucket on your inventory and using pickup on the paint container.]]
}

t.drop1 = {
    command = "{inst}drop {dir}<direction>",
    text = [[
Analogous to {inst}pickup{end}, but the bot will drop the object it is currently holding in the given {dir}direction{end}, or in front of it if no direction is given.

If the bot tries to drop the object in an invalid position or its inventory is empty, you will get a Runtime Error.]],
    examples = {{[[
{inst}pickup {dir}up
{inst}walk {num}1 {dir}down
{inst}drop]], "This code will pickup an object from the north and drop it 3 blocks down from where it was."}},
    notes = [[
Dropping a bucket with water will also drop the bucket.]]
}

t.drop = {
    command = t.drop1.command,
    text = t.drop1.text,
    examples = t.drop1.examples,
    notes = [[
Dropping a bucket with water will also drop the bucket. Dropping a bucket with paint will only paint the tile in the chosen direction, and keep an empty bucket on your inventory.]]
}

t.add1 = {
    command = "{inst}add {num}<value1> <value2> {addr}<address>",
    text = [[The sum of {num}<value1>{end} and {num}<value2>{end} will be stored in the register with number {addr}<address>{end}.]],
    examples = {{[[
{inst}add {num}[0] 1 {addr}0 {cmnt}# Increments the value in register #0 by 1
{inst}add {num}[1] [1] {addr}1 {cmnt}# Doubles the value of register #1]]}}
}

t.add = {
    command = t.add1.command,
    text = [[The sum of {num}<value1>{end} and {num}<value2>{end} will be stored in the register with number {addr}<address>{end}. See "sub" for examples.]],
    examples = {}
}

t.sub1 = {
    -- ghost command
}

t.sub = {
    command = "{inst}sub {num}<value1> <value2> {addr}<address>",
    text = [[The same as "add", but for subtraction.]],
    examples = {{[[
{inst}add {num}[0] 1 {addr}0 {cmnt}# Increments the value in register #0 by 1
{inst}sub {num}[7] [3] {addr}1 {cmnt}# Stores in register #1 the value in register #7 subtracted by the value in register #3
{inst}sub {num}0 [5] {addr}5 {cmnt}# Negates the value of register #5
{inst}add {num}[1] [1] {addr}1 {cmnt}# Doubles the value of register #1]]}}
}

t.mov1 = {
    --ghost command
}

t.mov = {
    command = "{inst}mov {num}<value> {addr}<address>",
    text = [[Stores {num}<value>{end} in the register given by {addr}<address>{end}. Notice that this is just a fancy version of "{inst}add {num}value 0 {addr}address{end}".]],
    examples = {{[[
{inst}mov {num}[0] {addr}1
{inst}mov {num}[0] {addr}2 {cmnt}# Copies the value of register #0 to registers #1 and #2]]}}
}

t.read1 = {
    -- ghost command
}

t.read = {
    command = "{inst}read {addr}<address> {dir}<direction>",
    text = [[
The bot turns to {dir}<direction>{end} and then reads one number from the console it is facing, and stores it in the register given by {addr}<address>{end}. The {dir}<direction>{end} argument is optional, and if omitted the bot will read from the console in front of it.

Reading a number removes it from the console. If there are no more numbers on the console, you will get a Runtime Error. See {inst}write{end} for examples.]],
    examples = {}
}

t.write1 = {
    command = "{inst}write {num}<value> {addr}<direction>",
    text = [[
The bot turns to {dir}<direction>{end} and then writes value to the console it is facing. The {dir}<direction>{end} argument is optional, and if omitted the bot will write to the console in front of it.

If the the number is invalid (depends on the puzzle), you will get a Runtime Error.]],
    examples = {{[[
{inst}write {num}12 {dir}right
{inst}write {num}[12] {dir}left]], "This code writes 12 to the console on the right, then the content in register #12 to the console on the left."}}
}

t.write = {
    command = t.write1.command,
    text = [[
The bot turns to {dir}<direction>{end} and then writes value to the console it is facing. The {dir}<direction>{end} argument is optional, and if omitted the bot will write to the console in front of it.

Notice that it is different than {inst}read{end} because it receives a {num}value{end} and not an {addr}address{end}. That means reading from console to register {addr}#0{end} uses the command "{inst}read {addr}0{end}", and writing to the console from the same register uses the command "{inst}write {num}[0]{end}". Be careful.

If the the number is invalid (depends on the puzzle), you will get a Runtime Error.]],
    examples = {t.write1.examples[1], {[[
{lab}label: {inst}read {addr}1 {dir}left
{inst}add {num}[1] [1] {addr}1
{inst}write {num}[1] {dir}right
{inst}jmp {lab}label]], "This code reads values from the console on the left, and writes them, doubled, to the console on the right."}}
}

t.cond_jmps = {
    command = "{inst}j?? {num}<value1> <value2> {lab}<label>",
    text = [[
For {inst}jgt{end}, if {num}<value1>{end} is greater than {num}<value2>{end}, then the next line executed will be the one labeled as {lab}<label>{end}. That is, if {num}<value1>{end} is greater than {num}<value2>{end}, this instruction will be the same as "{inst}jmp {lab}<label>{end}", otherwise, it will do nothing. Everything said about {inst}jmp{end} also applies here.

The other commands work exactly like {inst}jgt{end}, except the condition to jump is different. Here is the list of all conditional jumps:

{inst}jgt{end}: jumps if {num}value1{end} > {num}value2{end}, that is, if {num}value1{end} is greater than {num}value2{end}
{inst}jge{end}: jumps if {num}value1{end} ≥ {num}value2{end}, that is, if {num}value1{end} is greater than or equal {num}value2{end}
{inst}jlt{end}: jumps if {num}value1{end} < {num}value2{end}, that is, if {num}value1{end} is less than {num}value2{end}
{inst}jle{end}: jumps if {num}value1{end} ≤ {num}value2{end}, that is, if {num}value1{end} is less than or equal {num}value2{end}
{inst}jeq{end}: jumps if {num}value1{end} = {num}value2{end}, that is, if {num}value1{end} is equal {num}value2{end}
{inst}jne{end}: jumps if {num}value1{end} ≠ {num}value2{end}, that is, if {num}value1{end} is not equal {num}value2{end}]],
    examples = {{[[
{inst}mov {num}10 {addr}[0]
{lab}666: {inst}write {num}1 {dir}left
{inst}sub {num}[0] 1 {addr}0
{inst}jne {num}[0] 0 {lab}666]], "This code writes 1 to the console on the left exactly 10 times. This is what you could call a for loop."}}
}

return t
