local Info = require 'classes.tabs.info'

return {
    title = "Results results results",
    text = SaveManager.current_user .. [[
, let's get some results!

I've just created a new command, 'walkc'. It's kind of like walk, but it always walks until it hits an obstacle. What's the catch? It stores the number of walked steps on a register position!!!

This allows the bot to 'visualize' the environment, and you can automatize some stuff that wasn't previously possible. The complete command is 'walkc address direction', it turns to direction, walks until it hits an obstacle, and then stores the number of steps walked on the register given by address. The direction argument is optional, of course, like in the normal walk.

Example:
    - walkc 12
      turn clock
      turn clock
      walk [12]
This will walk until it hits an obstacle, then return to the initial position. GOSH alright I'm done explaining

Just do this puzzle so we can impress Franz. He'll be watching.

Make us proud, and carry on.

-- Liv


(Great party @ Paul's, right? You have nice dance moves)]],
    author = "Olivia Kavanagh (liv.k@sdd.marv.com)",
    puzzle_id = 'liv3a',
    open_func =
        function()
            Info.addCommand("walkc <address>")
            Info.addCommand("walkc <address> <direction>")
        end
}
