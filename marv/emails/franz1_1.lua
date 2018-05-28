--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local you = "Employee #" .. EMPLOYEE_NUMBER
return {
    title = "Tread very carefully",
    text = you .. [[,

It has come to my attention that you have not yet performed the required duties I assigned you, ]] .. you .. [[. Need I make myself clear again? I am not a patient man, as Mr. Vega found out very quickly. And you {red}are{end} pushing your luck.

So I would advise you to get back in that room, push that button, and rethink very carefully your position in this matter. You can't hide from your responsibilities.

Next time I won't ask you a second time, ]] .. you .. [[.

Karl Franz F. L. von Linz
General Executive Manager
]],
    author = "Karl Franz F. L. von Linz (kflinz@marv.com)",
}
