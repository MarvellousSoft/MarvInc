--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local tuto1 = require 'lore_events.tuto1'

return {
    title = "Even further clarifications",
    text = [[
It seems you still haven't finished the puzzle. Let me make everything clear.

You should head on to the {tab}<code> {end}tab. No, not now. Finish reading this email first. There, you can code instructions to solve puzzles. You can only write one instruction per line, and you can use the {tab}<code> {end}tab just as you would with any text editor.

After you write the instructions, use the buttons on the bottom of the {tab}<code> {end}tab to run your code. You have three available speeds to choose from. Whenever your robot completes the objective, the puzzle will be finished automatically. If your code crashes or your robot dies, the simulation will be restarted and you'll receive a new test subject.

After replying a puzzle or job proposal, read the {tab}<info> {end}tab to better understand your objectives in the room.

If you forget any of the instructions, check the {tab}<manual> {end}tab to see a list of them, with explanations.

Any remaining doubts can be emailed to {red}REDACTED{end}.

Carry on.]],
    author = "Automated Introduction System",
    open_func = tuto1.after_help2_email,
    can_be_deleted = true
}
