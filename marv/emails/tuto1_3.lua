local tuto1 = require 'lore_events.tuto1'

return {
    title = "Further instructions",
    text = [[
It seems you have not understood this system completely. Let me explain it further.

When you enter a puzzle, there are four tabs: %blue% <email> %end% , %blue% <code> %end% , %blue% <info> %end% and %blue% <manual> %end% .
You are on the first one, and here you can read your emails.
On the %blue% <code> %end% tab you can write and run commands. For now you only need the one I taught you ( %inst% walk %end% ) to solve this introductory puzzle.
On the tab %blue% <info> %end% you can check the puzzle's objectives and the current test robot information.
On the last tab, %blue% <manual> %end% , you can check the commands you know, with detailed explanations when you click on the commands.

After writing the commands in the %blue% <code> %end% tab, press the %orange% play %end% button to start the simulation. The %red% "robot" %end% will follow instructions from top to bottom, and you can't write more commands until the program stops or you press the %orange% stop %end% button.

Whenever you're lost, you can reread these emails. Unless you've deleted them. Don't do that. Unless you want to. Then do it.

Good Luck, and carry on.]],
    author = "Automated Introduction System",
    open_func = tuto1.after_help1_email,
    can_be_deleted = true
}
