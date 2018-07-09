--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

return {
    title = "Using memory",
    text = [[
Let's take it up a notch shall we? You will now learn to use the {addr}registers {end}and two new commands: {inst}write {end}and {inst}add{end}.

{addr}Registers {end}can hold {num}values{end}. Think of them as the memory in your {tab}<code>{end}. To access the {num}content {end}of the {addr}register #n{end}, just write {num}[n]{end}. So if you want the {num}value {end}in the {addr}register #5{end}, you write {num}[5]{end}. You can see them just below your {tab}<code> {end}notepad, with their respective numbers and contents. {addr}Register {end}numbers start from 0, and are located in the top-left corner of a {addr}register{end}, while the {num}content {end}is the big number centered on the box.

The {inst}add {end}command receives three arguments: Two {num}values {end}to be added, and the {addr}address {end}where their sum will be stored.

Look at the following examples:
      {inst}add {num}[1] 3 {addr}7{cmnt} #adds 3 to the content of register #1, and stores it at register #7.{end}
      
      {inst}add {num}[2] [5] {addr}2{cmnt} #adds register #2 contents to register #5 contents and stores it at register #2 again.{end}

{blue}Note:{end} Everything written in the same line after a {cmnt}hashtag '#'{end} are {cmnt}comments{end} and will be ignored when running a code. You can use it to make your code clearer.

Finally, the {inst}write {end}command receives a {num}value {end}argument, and a second optional {dir}direction {end}argument. You'll use the {inst}write {end}command to write {num}values {end}in a {orange}console{end}, which are the big colorful computer objects in the room. The {dir}direction {end}determines which direction the {orange}console {end}is. If not provided, as usual, the robot will try to write in the direction he is facing.

The following example writes the {num}contents{end} of {addr}register #2{end} to the {orange}console{end} below the robot:
      {inst}write {num}[2] {dir}south{end}

Make sure to understand all these concepts. You can do it.

Best of Luck. Carry on. :)
]],
    author = "Automated Introduction System",
    puzzle_id = 'tuto6',
    open_func =
        function()
            Util.findId('manual_tab'):addCommand("add1")
            Util.findId('manual_tab'):addCommand("sub1")
            Util.findId('manual_tab'):addCommand("mov1")
            Util.findId('manual_tab'):addCommand("read1")
            Util.findId('manual_tab'):addCommand("write1")
        end
}
