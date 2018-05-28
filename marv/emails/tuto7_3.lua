--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

return {
    title = "Some read command examples",
    text = [[
In case you need some further guidance, here are some examples using the {inst}read {end}command and {red}conditional jumping{end}.

Example where the bot reads an input from the {orange}console {end}below him, and writes in the {orange}console {end}above him. In both cases he is using the {addr}register #0 {end}to store the values.
      {inst}read {addr}0 {dir}down {end}
      {inst}write {num}[0] {dir}up {end}

Example where the bot will keep reading the input from the {orange}console {end}to his {dir}left {end}( {dir}west {end}) until it equals the input he got from the {orange}console {end}to his {dir}right {end}( {dir}east {end}). Then he will be able to walk {dir}down{end}.
      {inst}read {addr}0 {dir}east {end}
      {lab}marv: {inst}read {num}1 {dir}west {end}
      {inst}jne {num}[0] [1] {lab}marv {end}
      {inst}walk {dir}down {end}

With the {inst}read {end}command you can read inputs from the {orange}consoles{end}, while with the {inst}write {end}you can output to the {orange}consoles{end}.

Use the {red}conditional jumps {end}to make logical loops for your programs. Understanding all this is essential for every member of our company.

Follow you dreams, and carry on.
]],
    author = "Automated Introduction System",
    can_be_deleted = true
}
