--Marvellous Inc.
--Copyright (C) 2017  MarvellousSoft
--See full license in file LICENSE.txt

local tuto1 = require 'lore_events.tuto1'

return {
    title = "First Puzzle",
    text = [[
There are many commands to control the test subjects. For now, you just need to know one: {inst}walk{end}

You can provide a {dir}cardinal direction {end}({dir}north{end}, {dir}east{end}, {dir}south {end}or {dir}west{end}) or a {dir}regular direction {end}({dir}up{end}, {dir}right{end}, {dir}down {end}or {dir}left{end}). If you don't, your robot will walk to the direction it's facing.

{red}IMPORTANT:{end} This command will make the test subject {red}walk continuously{end} until it encounters an obstacle.

Examples:
    - {inst}walk{end}
    - {inst}walk {dir}east{end}
    - {inst}walk {dir}down{end}

After writing the instructions in the appropriate place, use the {orange}play {end}button to start running the commands. Use the two buttons to the right of the {orange}play {end}button to move your bot faster.

We are assured you are an expert, so no more instructions are needed. Complete the following puzzle quickly. Reply this email to start the puzzle.

Best of Luck, and carry on.]],
    author = "Automated Introduction System",
    puzzle_id = 'tuto1',
    open_func =
        function()
            Util.findId('manual_tab'):addCommand("walk1")
            tuto1.after_puzzle_email()
        end
}
