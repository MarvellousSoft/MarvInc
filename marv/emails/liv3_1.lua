--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

return {
    title = "Results results results",
    text = SaveManager.current_user .. [[
, let's get some results!

I've just created a new command, {inst}walkc{end}. It's kind of like {inst}walk{end}, but it {red}always{end} walks until it hits an {red}obstacle{end}. What's the catch? It stores the {num}number {end}of walked steps on a {addr}register position{end}!!!

This allows the bot to 'visualize' the environment, and you can {red}automatize {end}some stuff that wasn't previously possible. The complete command is '{inst}walkc {addr}address {dir}direction{end}', it turns to {dir}direction{end}, walks until it hits an obstacle, and then stores the {num}number {end}of steps walked on the register given by {addr}address{end}. The {dir}direction {end}argument is optional, of course, like in the normal {inst}walk{end}.

Example:
    - {inst}walkc {num}12{end}
      {inst}turn {dir}clock{end}
      {inst}turn {dir}clock{end}
      {inst}walk {num}[12]{end}
This will walk until it hits an obstacle, then return to the initial position. GOSH alright I'm done explaining

Just do this puzzle so we can impress Franz. He'll be {red}watching{end}.

Make us proud, and carry on.

-- Liv


(Great party @ Paul's, right? You have {red}nice {end}dance moves)]],
    author = "Olivia Kavanagh (liv.k@sdd.marv.com)",
    puzzle_id = 'liv3a',
    open_func =
        function()
            Util.findId('manual_tab'):addCommand("walkc")
            Util.findId('manual_tab'):changeCommand("jmp2", "jmp")
        end
}
