--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

return {
    title = "Keep going",
    text = [[
Well done.

Besides {dir}directions{end}, you can add another modifier to the {inst}walk {end}command: a {num}value{end}. The test subject will then walk that many steps. This may sound worse than the original command, but it may be useful for precise robot walking.

Examples:
      {inst}walk {num}5{end}
      {inst}walk {dir}left {num}10{end}

Reply this email to start the experiment.

Keep up the good work, and carry on.
]],
    author = "Automated Introduction System",
    puzzle_id = 'tuto2',
    open_func =
        function()
            Util.findId('manual_tab'):changeCommand("walk1", "walk")
        end
}
