--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

return {
    title = "Some more register examples",
    text = [[
Here are some more examples to get you used to the {addr}register{end}, {inst}write {end}command and {inst}add {end}command.

In this example, the bot will write to a {orange}console {end}facing his left the {num}content {end}of the {addr}register #8{end}.
      {inst}turn {dir}left {end}
      {inst}write {num}[8] {end}

This next example does the same thing as before, but with less lines of code
      {inst}write {num}[8] {dir}left {end}

Example of adding the {num}value {end}inside the {addr}register 10 {end}by itself (aka multiplying it by two), and storing the result on {addr}register #0{end}.
      {inst}add {num}[10] [10] {addr}0 {end}

Shine on and carry on.
]],
    author = "Automated Introduction System",
    can_be_deleted = true
}
