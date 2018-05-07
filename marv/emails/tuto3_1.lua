--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

return {
    title = "Making good progress",
    text = [[
Good job, Employee #]].. EMPLOYEE_NUMBER .. [[. Lets learn some new instructions.

Use the {inst}turn {end}command to, *surprise*, turn the test subject and change the direction he is facing. You can provide an absolute {dir}direction{end}, or the special arguments {dir}clock {end}or {dir}counter{end}, to turn the robot clockwise or counterclockwise, respectively.

Examples:
      {inst}turn {dir}south{end}
      {inst}turn {dir}clock{end}
      {inst}turn {dir}counter{end}

You will need this for future tasks, so don't forget about it. Use the next room to apply this new command, and don't forget to check the objectives on the {tab}<info> {end}tab.

As always, reply this email to start the puzzle.

Carry on.
]],
    author = "Automated Introduction System",
    puzzle_id = 'tuto3',
    open_func =
        function()
            Util.findId('manual_tab'):addCommand("turn")
        end
}
