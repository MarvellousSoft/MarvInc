local tuto1 = require 'lore_events.tuto1'

return {
    title = "First Puzzle",
    text = [[
There are many commands to control the test subjects. For now, you just need to know one: %red% walk %end%

You can provide a cardinal direction ( %green% north %end% , %green% east %end% , %green% south %end% or %green% west %end% ) or a regular direction ( %green% up %end% , %green% right %end% , %green% down %end% or %green% left %end% ). If you don't, your robot will walk to the direction it is facing. This command will make the test subject walk until it encounters an obstacle.

Examples:
    - %red% walk %end%
    - %red% walk %green% east %end%
    - %red% walk %green% down %end%

After writing the instructions in the appropriate place, use the %green% play %end% button to start running the commands. Use the two buttons to the right of the %green% play %end% button to move your bot faster.

We are assured you are an expert, so no more instructions are needed. Complete the following puzzle quickly.


Reply this email to start the puzzle.

Best of Luck, and carry on.]],
    author = "Automated Introduction System",
    puzzle_id = 'tuto1',
    open_func =
        function()
            Util.findId('manual_tab'):addCommand("walk1")
            tuto1.after_puzzle_email()
        end
}
