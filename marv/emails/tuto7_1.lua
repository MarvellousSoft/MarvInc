--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

return {
    title = "Comparing and jumping",
text = [[
We are almost finished with the introductory puzzles.

We now introduce the {red}conditional jumps{end}. There are several of them, and shortly you'll receive an email explaining what condition each one represents.

They all receive three arguments: two {num}values {end}and a {lab}label{end}. If the condition of the jump is satisfied, it will jump to the {lab}label{end}, just like a normal {inst}jmp{end}. If the condition is false, it will just go to the next instruction as if nothing happened.

For instance, the {inst}jgt {end}command is the {red}Greater Than Jump{end}. So if the first {num}value {end}received is greater than the {num}second one{end}, it will jump to the {lab}label {end}given as a third argument.

Example where the bot will increase the {num}value {end}of the {addr}register #1 {end}until it's greater than the {num}value {end}of the {addr}register #2{end}. Only then it will walk {num}7 {end}tiles.
      {lab}omar: {inst}add {num}[1] 1 {addr}1 {end}
      {inst}jgt {num}[2] [1] {lab}omar {end}
      {inst}walk {num}7 {end}

Lastly you can use the {inst}read{end} command to read input from a {orange}console{end}. You provide a first argument with the {addr}address {end}of the {addr}register{end} to store the input read, and a second optional {dir}direction{end}, analogous to the {inst}write {end}command.

Notice that {inst}read {end}is different than {inst}write {end}because it receives an {addr}address {end}and not a {num}value{end}. That means reading from {orange}console {end}to {addr}register #0 {end}uses the command { {inst}read {addr}0{end} }, and writing to the {orange}console {end}from the same {addr}register {end}uses the command { {inst}write {num}[0]{end} }. Be careful.

Carry on.
]],
    author = "Automated Introduction System",
    puzzle_id = 'tuto7',
    open_func =
        function()
            Util.findId('manual_tab'):changeCommand("read1", "read")
            Util.findId('manual_tab'):changeCommand("write1", "write")
            Util.findId('manual_tab'):addCommand("cond_jmps")
        end
}
