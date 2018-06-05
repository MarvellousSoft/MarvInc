--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

return {
    title = "We bid you farewell",
    text = [[
Congratulations, employee #]] .. EMPLOYEE_NUMBER .. [[,

As you know, only the most forward-thinking and capable dreamers and entrepreneurs are accepted in this company, and you can now count {red}yourself{end} among these prodigies. You have exceeded our expectations, and for this we promote you to {red}Robot Tester{end}!

As well as being well paid, here at Marvellous Inc you will receive benefits like:
    - Up to $20 meal reimbursement weekly (upon delivery of signed receipt from authorized partners).
    - Specialized psychologic and psychiatric help in case of: overwork stress, harmful work environment, sexual harassment, extreme psychological violence, and other.
    - And much more!

The student is becoming the master, but I have one more lesson for you, {green}young grasshopper{end}. Well, {green}two{end} actually. With the new {blue}Home Basic OS{end} upgrade you're getting, you can now rename {addr}registers{end}. And now you can add {red}breakpoints{end} to your code!

If you hold your mouse over a {addr}register{end}, you will be able to assign a custom name for it. After that, you may use that name instead of its {addr}register{end} number throughout the code. For example, if you rename {addr}register{end} 3 to abba, then
    {inst}read {addr}abba{end}
will mean exactly the same as
    {inst}read {addr}3{end}.

Secondly, if you click a line number in your {tab}<code>{end} tab, you can toggle {red}breakpoints{end}. Use this, even while your code is running, to make your robot stop before an especific instruction. Debugging has never been so fun!

Please take note of those features and use them to make your code clearer and debugging less troublesome. They will be essencial as your tasks get more complicated.

Carry on,
Your oldest and dearest friend, Automated Introduction System.
]],
    author = "Automated Introduction System",
    can_be_deleted = true
}
