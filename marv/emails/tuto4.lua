--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

return {
    title = "Let's use some loops",
    text = [[
Remember loops from Hacking101 classes? Well, you better.

The new command is {inst}jmp{end}. You provide a {lab}label{end}, and it will jump to the line you defined the {lab}label {end}on. To define a {lab}label{end}, just write any single alphanumeric word (that means only letters and numbers, dummy) followed by a  {lab}colon ' : '{end}.

After defining a {lab}label{end}, {orange}you can optionally write any one command in the same line{end}, however the command must be written after the {lab}' : '{end}. You can use this to save lines in your code.
{red}Remember this, as it will be important to make shorter programs later on.{end}

Example that makes the bot walk in circles:
      {lab}banana:{end}
      {inst}walk {end}2
      {inst}turn {dir}counter{end}
      {inst}jmp {end}{lab}banana {end}

Example that makes the bot spin endlessly:
      {lab}awesomeLabel66: {inst}turn {dir}clock{end}
      {inst}jmp {lab}awesomeLabel66{end}

Complete this puzzle quickly. We'd greatly appreciate it. Don't forget the experiment ends as soon as the objective requirements are completed.

As always, carry on.
]],
    author = "Automated Introduction System",
    puzzle_id = 'tuto4',
    open_func =
        function()
            -- Util.findId('manual_tab'):addCommand("label") maybe add an entry for labels
            Util.findId('manual_tab'):addCommand("jmp1")
        end
}
