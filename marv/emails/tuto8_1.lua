--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

return {
    title = "Final puzzle",
    text = [[
This is it. The last things we have to teach you. The rest is on your own.

The command {inst}mov {end}is used to move {num}values {end}to an {addr}address{end}. The first argument is the {num}value{end}, and the second argument the {addr}address {end}you'll move the {num}value {end}to.

There is also the command {inst}sub{end}. It works analogous to the {inst}add {end}command, but instead of adding the first {num}two arguments {end}and storing in the {addr}register {end}given by the {addr}third{end}, it will subtract.

Example where the bot will move the {num}content {end}of the {addr}register #7 {end}to the {addr}register #3{end}, and then subtract the {num}value {end}of {addr}register #7 {end}by {num}4{end}.
      {inst}mov {num}[7] {addr}3 {end}
      {inst}sub {num}[7] 4 {addr}7 {end}

Prove yourself worthy, employee #]] .. EMPLOYEE_NUMBER .. [[.

{purple}We are waiting you.{end}

Carry on.
]],
    author = "Automated Introduction System",
    puzzle_id = 'tuto8',
    open_func =
        function()
            Util.findId('manual_tab'):changeCommand("sub1", "sub")
            Util.findId('manual_tab'):changeCommand("add1", "add")
            Util.findId('manual_tab'):changeCommand("mov1", "mov")
            Util.findId('manual_tab'):changeCommand("jmp1", "jmp2")
        end
}
