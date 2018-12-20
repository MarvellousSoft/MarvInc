--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

return {
    title = "[TASK] Brainfuck loops",
    text = [[
Hello, Richard here. Olivia asked me to send this task to you, I hope the statement is clear.

For now the {blue}language{end} you implemented is not overly useful, since there is no condition-checking or loops, making it impossible to do even the simplest algorithm. The task at hand is to improve the language.

There is a {inst}loop structure {end}in {blue}brainfuck{end}. It can be done using {inst}brackets{end}. {inst}[{blue}code{inst}]{end} means that the segment {blue}code {end}will be executed for as long as the {num}value {end}pointed by the {addr}data pointer {end}is non-zero.

More formally, imagine there is an {blue}instruction pointer{end}, that points to the instruction that is currently executing (not unlike the white indicator you see on the right when running some L++ code). Excluding the loop, all instructions just make the {blue}IP (instruction pointer) {end}increment by one. When the {blue}IP {end}is pointing to a {inst}[{end}, it will skip to the matching {inst}] {end}if the {num}value {end}pointed by the {addr}DP (data pointer) {end}is 0, otherwise it will just increment as usual. In the same manner, when the {blue}IP {end}is at a {inst}]{end}, it will skip to the matching {inst}[ {end}if the {num}value {end}pointed by the {addr}DP {end}is non-zero.

A simple example: suppose the value pointed by the {addr}DP {end}is non-negative*, then the example code {blue}[-] {end}will subtract 1 from that value until it becomes 0. From this, you can see that {blue}brainfuck {end}is much simpler than L++, since you need an algorithm just to make a position become 0.

Please notice that there may be {gray}loops inside loops{end}, which will surely make the job of implementing the interpreter significantly harder than the last task.

There will be enough registers to {gray}store the whole code{end} in memory. The white console output will be {gray}ended by a 0{end}, so you will be able to tell when to stop reading the code.

I'll send you some more examples shortly. Carry on.

Richard Black
Programmer intern at Marvellous Inc. Software Development Department

* If you're really an L++ expert, you'll realize that this works even if the value is negative, since -999 - 1 = 999 (it will take a long time, for sure).]],
    author = "Richard Black (rick.black@sdd.marv.com)",
    puzzle_id = 'liv9'
}
