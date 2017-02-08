local tuto1 = require 'lore_events.tuto1'

return {
    title = "Welcome Employee #" .. EMPLOYEE_NUMBER,
    text = [[
Greetings and Salutations!

We at Marvellous Inc. are happy to welcome one more member in our ever expanding AI company. We are all about Big Data, Internet of Things, Deep Data Mining Learning (DDML), real-time networks for cutting-edge technology and benchmarking cloud apps (built for scalability of course). We hope you can meet our standards, end-to-end.

As you know, your assignment will be to test our newly developed Artificial Inteligence Humanoids, or "robots". You will have to program their behaviour with simple commands so they can fulfill simple tasks. On the right part of screen you have direct access to a camera filming The Room. Test subjects (the "robots" of course) will be placed inside The Room, but you can only control them via your <terminal>.

This Automated System will guide you if you feel disoriented.

Most importantly, have fun and carry on :)
]],
    author = "Automated Introduction System",
    puzzle_id = 'painter', -- TODO: REMOVE IN RELEASE
    open_func = tuto1.after_intro_email
}
