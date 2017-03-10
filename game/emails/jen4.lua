local jen4 = require 'lore_events.jen4'

return {
    title = "Senior Puzzle 001",
    text = [[
Hello Robot Tester Employee #]]..EMPLOYEE_NUMBER..[[. Or more precisely, Senior Robot Tester Employee #]]..EMPLOYEE_NUMBER..[[.

Actually that's just too long of a title to write everytime. I'll just call you CS2 (as in Cool Subordinate #2). If you are wondering, the CS1 position is occupied by Employee #]]..(EMPLOYEE_NUMBER+1)..[[, Diego Vega. Not because of his programming talents, because he is awful at that. But he is positive, flexible, team-oriented and sends me lots and lots of funny cat images.

Honestly I haven't fired him yet only because of the cat images. I really like cats.

Anyway, here is your first Senior task. I want you to read several numbers and write them on the floor in binary. You got this far without any problems, so I'm pretty sure you already now what binary numbers are and how to change between numeral systems... however, after I got a CS1 email asking how to "emulate doom in mah pc so i can rekt som n00bs", I have lowered my standards for all employees. But I'm a busy person, so I'm just forwarding you an old automated email we used to send interns back in the early MarvInc days. Just ignore the 80's references and you'll be fine.

Carry on CS2, now and forever.

Janine Leubwitz
Chief engineer at Marvellous Inc.s Robot Testing Department
]],
    author = "Janine Leubwitz (leubwitz@rtd.marv.com)",
    puzzle_id = 'jen4',
    open_func = jen4.after_intro_email
}
