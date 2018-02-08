--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

return {
    title = "[EXAMPLES] Brainfuck loops",
    text = [[
Hello, this is Richard again. I'll send some more {blue}brainfuck {end}examples, now with {inst}loops{end}. Make sure you understand all of these. I always assume the {addr}data pointer {end}starts at position 0, and all {num}data {end}is 0 (unless otherwise stated).

    {blue}[->+<]{end}
This will turn the value at {addr}DP (data pointer){end} to 0 and add that value to {addr}DP+1{end}.

    {blue}[>]{end}
This will point {addr}DP (data pointer) {end}to the next position that has {num}value {end}0.

    {blue}<[>,]{end}
This will read {num}values {end}from the input until it reads a 0, and store them in adjacent positions.

    {blue}++++++[>++++++++++<-]>+++{end}
This will set the {num}value {end}at position 1 to 63, using position 0 as an 'auxiliar' for a loop.

    {blue}[[->+<]>]{end}
Assuming everything else except the {num}value {end}in position 0 is 0, will endlessly move that {num}value {end}to position 1, and then 2, etc.

    {blue}++++++++[[>],[<]>-]{end}
This will read 8 {num}values {end}from the input and place them in positions 1..8, assuming none of them are 0.

Hope you got it. If you need more help, {gray}don't ask Olivia {end}because she will mock you.

Thank you for your attention. Carry on.

Richard Black
Programmer intern at Marvellous Inc. Software Development Department]],
    author = "Richard Black (rick.black@sdd.marv.com)",
    can_be_deleted = true
}
