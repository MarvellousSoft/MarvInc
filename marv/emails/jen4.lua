--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local jen4 = require 'lore_events.jen4'

return {
    title = "Senior Puzzle 001",
    text = [[
Hello Robot Tester Employee #]]..EMPLOYEE_NUMBER..[[. Or more precisely, {purple}Senior Robot Tester Employee #]]..EMPLOYEE_NUMBER..[[{end}.

Actually that's just too long of a title to write everytime. I'll just call you {blue}CS2{end} (as in {blue}Cool Subordinate #2{end}). If you are wondering, the {pink}CS1{end} position is occupied by Employee #]]..(EMPLOYEE_NUMBER+1)..[[, {pink}Diego Vega{end}. Not because of his programming talents, because he is awful at that. But he is positive, flexible, team-oriented and sends me lots and lots of funny cat images.

Honestly I haven't fired him yet only because of the cat images. I really like cats.

Anyway, here is your first {purple}Senior task{end}. I want you to read several numbers and write them on the floor in {orange}binary{end}. You got this far without any problems, so I'm pretty sure you already know what binary numbers are and how to convert between numeral systems... however, after I got a CS1 email asking how to {pink}"emulate doom in mah pc so i can rekt som n00bs"{end}, I have lowered my standards for all employees. But I'm a busy person, so I'm just forwarding you an old automated email we used to send interns back in the early MarvInc days. Just ignore the 80's references and you'll be fine.

Carry on {blue}CS2{end}, now and forever.

Janine Leubwitz
Head engineer at Marvellous Inc. Robot Testing Department
]],
    author = "Janine Leubwitz (leubwitz@rtd.marv.com)",
    puzzle_id = 'jen4',
    open_func = jen4.after_email
}
