--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

return {
    title = "I'm sorry",
    text = [[
Hey ]] .. SaveManager.current_user .. [[,

I wanted to say {orange}I'm sorry{end} with how I treated you before. I guess being {orange}screamed at{end} and {orange}humiliated{end} by my bosses made me look back and realize that I was doing basically the same with my {gray}'power'{end}.

I was gonna say it was just some innocent joke, but let's face it, it wasn't. {orange}I hope you can forgive me, I'm trying to change my ways{end}.

The bosses, however, are not very forgiving, and are demanding {orange}a lot{end} of me. They've sent me more tasks this week than I've received for the last 3 months. And they want it done {red}fast{end}.

I know I shouldn't be doing this, but you're the last person I have to turn to, and {orange}it's my own fault{end}. If you could help me in this, I would be very grateful. Reply this email and I will send you the task. I've already done some of it, so you just need to do the end. It is about painting the floor, I've updated your manual so the {inst}pickup{end} and {inst}drop{end} commands now explain this better.

Thank you anyway!

Fergus
]],
    author = "Fergus Gerhard Jacobsen (jacobsen@rtd.marv.com)",
    puzzle_id = 'fergus3',
    open_func =
        function()
            Util.findId('manual_tab'):changeCommand("pickup1", "pickup")
            Util.findId('manual_tab'):changeCommand("drop1", "drop")
        end
}
