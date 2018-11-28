--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

--[[ Each item must be a table with the following fields
- command: name and paramenters of command
- text: explanation of command
- examples: array of Examples
- notes: possible extra notes (optional)

Each Example is an array with two strings, the first is the code, the second is the (possibly omitted) explanation of the example.
]]

local t = {}

t.walk1 = {
    command = "{instm}walk {dirm}<direction>",
    text = [[The bot turns to {dirm}<direction>{end} and then the walks until it finds an obstacle. If {dirm}<direction>{end} is omitted, the bot will walk in the direction it is facing.]],
    examples = {{[[{instm}walk {dirm}east{end} {cmntm}# Walks right until it hits an obstacle]]}}
}

t.walk = {
    command = "{instm}walk {numm}<value> {dirm}<direction>",
    text = [[
The bot turns to {dirm}<direction>{end} and then the walks {numm}<value>{end} steps. One or both of the parameters may be omitted. If {numm}<value>{end} is omitted, the bot will walk until it finds an obstacle. If {dirm}<direction>{end} is omitted, then the bot will walk in the direction it is facing.

{numm}<value>{end} must be greater than or equal to {numm}0{end}. If it is equal to {numm}0{end} the robot will turn (if a {dirm}direction{end} is given), but won't walk.]],
    examples = {{[[
{instm}walk {numm}3 {dirm}down {cmntm}# Walks 3 positions down
{instm}walk {dirm}east {cmntm}# Walks right until it hits an obstacle]]}},
    notes = "In this command the order of the parameters may be switched, but in most other commands this won't work."
}

t.walkc = {
    command = "{instm}walkc {addrm}<address> {dirm}<direction>",
    text = [[The bot turns to {dirm}<direction>{end}, walks until it finds an obstacle and then stores the number of steps walked in the register given by {addrm}<address>{end}. The argument {dirm}<direction>{end} is optional, and if omitted the bot will keep facing the same direction.]],
    examples = {{[[
{instm}walkc {numm}0 {dirm}up
{instm}pickup {dirm}up
{instm}walk {numm}[0] {dirm}down]], "With this code the bot will walk north until finding an obstacle, pick it up, and then return to the same position."}}
}

t.turn = {
    command = "{instm}turn {dirm}<direction>",
    text = [[The bot will turn to {dirm}<direction>{end}. In this command, direction may assume two extra values: {dirm}clock{end} and {dirm}counter{end}, if one of these are given, the bot will turn clockwise or counterclockwise, respectively.]],
    examples = {{[[
{instm}turn {dirm}clock
{instm}turn {dirm}clock]], "This code will turn the robot to the oposite direction it is facing"}}
}

t.jmp1 = {
    command = "{instm}jmp {labm}<label>",
    text = "The next code line executed will be the line labeled equal to {labm}<label>{end}, instead of going to the next line.",
    examples = {{[[
{labm}lp: {instm}turn {dirm}counter
{instm}walk {numm}1
{instm}jmp {labm}lp]], "This code will make the bot walk endlessly in a 2x2 square, in counterclockwise direction."}}
}

t.jmp2 = {
    command = "{instm}jmp {labm}<label>",
    text = [[The next code line executed will be the line labeled equal to {labm}<label>{end}, instead of going to the next line. If {labm}<label>{end} is a number, it will be evaluated first, that means "{instm}jmp {numm}[5]{end}" will jump to the label that is the same as the number written in register {addrm}#5{end}.]],
    examples = {t.jmp1.examples[1], {[[
{instm}mov {numm}5 {addrm}0
{instm}jmp {labm}[0] ]], "This code will jump to label {labm}5{end}, but if register {addrm}#0{end} had a different {numm}value{end} it would (try to) jump to a different {labm}label{end}."}
    }
}

t.jmp = {
    command = t.jmp2.command,
    text = t.jmp2.text,
    examples = {t.jmp2.examples[1], t.jmp2.examples[2], {[[
{labm}lp: {instm}turn {dirm}counter
{instm}walk {numm}1
{instm}jmp {labm}lp]], "This code will make the bot walk endlessly in a 2x2 square, in counterclockwise direction."}, {[[
{cmntm}# Advanced Example
{labm}func: {instm}walkc {numm}1
{instm}turn {dirm}clock
{instm}turn {dirm}clock
{instm}walk {numm}[1]
{instm}turn {dirm}clock
{instm}turn {dirm}clock
{instm}jmp {labm}[0]{end}
...
...
{instm}mov {numm}111 {addrm}0
{instm}jmp {labm}func
{labm}111: {cmntm}# continue]], [[In this example, jumping to {labm}func{end} will store in the register {addrm}#1{end} the number of steps you can walk forward until hitting something, using the register {addrm}#0{end} as a "return position". Jumping to this {labm}label{end} may be seen as a simple function, since it can be called from anywhere and will return to where it was called.]]}}
}

t.pickup1 = {
    command = "{instm}pickup {dirm}<direction>",
    text = [[
The bot will first turn to {dirm}<direction>{end}, and then pickup the object on the tile it is facing. The argument {dirm}<direction>{end} is optional, and if omitted the bot will keep facing the same direction.

If the bot tries to pick up an invalid object or its inventory is already full, you will get a Runtime Error. See {instm}drop{end} for examples.]],
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
    command = "{instm}drop {dirm}<direction>",
    text = [[
Analogous to {instm}pickup{end}, but the bot will drop the object it is currently holding in the given {dirm}direction{end}, or in front of it if no direction is given.

If the bot tries to drop the object in an invalid position or its inventory is empty, you will get a Runtime Error.]],
    examples = {{[[
{instm}pickup {dirm}up
{instm}walk {numm}1 {dirm}down
{instm}drop]], "This code will pickup an object from the north and drop it 3 blocks down from where it was."}},
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
    command = "{instm}add {numm}<value1> <value2> {addrm}<address>",
    text = [[The sum of {numm}<value1>{end} and {numm}<value2>{end} will be stored in the register with number {addrm}<address>{end}.]],
    examples = {{[[
{instm}add {numm}[0] 1 {addrm}0 {cmntm}# Increments the value in register #0 by 1
{instm}add {numm}[1] [1] {addrm}1 {cmntm}# Doubles the value of register #1]]}}
}

t.add = {
    command = t.add1.command,
    text = [[The sum of {numm}<value1>{end} and {numm}<value2>{end} will be stored in the register with number {addrm}<address>{end}. See "sub" for examples.]],
    examples = {}
}

t.sub1 = {
    -- ghost command
}

t.sub = {
    command = "{instm}sub {numm}<value1> <value2> {addrm}<address>",
    text = [[The same as "add", but for subtraction.]],
    examples = {{[[
{instm}add {numm}[0] 1 {addrm}0 {cmntm}# Increments the value in register #0 by 1
{instm}sub {numm}[7] [3] {addrm}1 {cmntm}# Stores in register #1 the value in register #7 subtracted by the value in register #3
{instm}sub {numm}0 [5] {addrm}5 {cmntm}# Negates the value of register #5
{instm}add {numm}[1] [1] {addrm}1 {cmntm}# Doubles the value of register #1]]}}
}

t.mov1 = {
    --ghost command
}

t.mov = {
    command = "{instm}mov {numm}<value> {addrm}<address>",
    text = [[Stores {numm}<value>{end} in the register given by {addrm}<address>{end}. Notice that this is just a fancy version of "{instm}add {numm}value 0 {addrm}address{end}".]],
    examples = {{[[
{instm}mov {numm}[0] {addrm}1
{instm}mov {numm}[0] {addrm}2 {cmntm}# Copies the value of register #0 to registers #1 and #2]]}}
}

t.read1 = {
    -- ghost command
}

t.read = {
    command = "{instm}read {addrm}<address> {dirm}<direction>",
    text = [[
The bot turns to {dirm}<direction>{end} and then reads one number from the console it is facing, and stores it in the register given by {addrm}<address>{end}. The {dirm}<direction>{end} argument is optional, and if omitted the bot will read from the console in front of it.

Reading a number removes it from the console. If there are no more numbers on the console, you will get a Runtime Error. See {instm}write{end} for examples.]],
    examples = {}
}

t.write1 = {
    command = "{instm}write {numm}<value> {addrm}<direction>",
    text = [[
The bot turns to {dirm}<direction>{end} and then writes value to the console it is facing. The {dirm}<direction>{end} argument is optional, and if omitted the bot will write to the console in front of it.

If the the number is invalid (depends on the puzzle), you will get a Runtime Error.]],
    examples = {{[[
{instm}write {numm}12 {dirm}right
{instm}write {numm}[12] {dirm}left]], "This code writes 12 to the console on the right, then the content in register #12 to the console on the left."}}
}

t.write = {
    command = t.write1.command,
    text = [[
The bot turns to {dirm}<direction>{end} and then writes value to the console it is facing. The {dirm}<direction>{end} argument is optional, and if omitted the bot will write to the console in front of it.

Notice that it is different than {instm}read{end} because it receives a {numm}value{end} and not an {addrm}address{end}. That means reading from console to register {addrm}#0{end} uses the command "{instm}read {addrm}0{end}", and writing to the console from the same register uses the command "{instm}write {numm}[0]{end}". Be careful.

If the the number is invalid (depends on the puzzle), you will get a Runtime Error.]],
    examples = {t.write1.examples[1], {[[
{labm}label: {instm}read {addrm}1 {dirm}left
{instm}add {numm}[1] [1] {addrm}1
{instm}write {numm}[1] {dirm}right
{instm}jmp {labm}label]], "This code reads values from the console on the left, and writes them, doubled, to the console on the right."}}
}

t.cond_jmps = {
    command = "{instm}j?? {numm}<value1> <value2> {labm}<label>",
    text = [[
For {instm}jgt{end}, if {numm}<value1>{end} is greater than {numm}<value2>{end}, then the next line executed will be the one labeled as {labm}<label>{end}. That is, if {numm}<value1>{end} is greater than {numm}<value2>{end}, this instruction will be the same as "{instm}jmp {labm}<label>{end}", otherwise, it will do nothing. Everything said about {instm}jmp{end} also applies here.

The other commands work exactly like {instm}jgt{end}, except the condition to jump is different. Here is the list of all conditional jumps:

{instm}jgt{end}: jumps if {numm}value1{end} > {numm}value2{end}, that is, if {numm}value1{end} is greater than {numm}value2{end}
{instm}jge{end}: jumps if {numm}value1{end} ≥ {numm}value2{end}, that is, if {numm}value1{end} is greater than or equal {numm}value2{end}
{instm}jlt{end}: jumps if {numm}value1{end} < {numm}value2{end}, that is, if {numm}value1{end} is less than {numm}value2{end}
{instm}jle{end}: jumps if {numm}value1{end} ≤ {numm}value2{end}, that is, if {numm}value1{end} is less than or equal {numm}value2{end}
{instm}jeq{end}: jumps if {numm}value1{end} = {numm}value2{end}, that is, if {numm}value1{end} is equal {numm}value2{end}
{instm}jne{end}: jumps if {numm}value1{end} ≠ {numm}value2{end}, that is, if {numm}value1{end} is not equal {numm}value2{end}]],
    examples = {{[[
{instm}mov {numm}10 {addrm}[0]
{labm}666: {instm}write {numm}1 {dirm}left
{instm}sub {numm}[0] 1 {addrm}0
{instm}jne {numm}[0] 0 {labm}666]], "This code writes 1 to the console on the left exactly 10 times. This is what you could call a for loop."}}
}

return t
