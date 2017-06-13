return {
    title = "Making good progress",
    text = [[
Good job, Employee #]].. EMPLOYEE_NUMBER .. [[. Lets learn some new instructions.

Use the %red% turn %end% command to, *surprise*, turn the test subject and change the direction he is facing. You can provide a direction, or the special arguments %green% clock %end% or %green% counter %end% , to turn the robot clockwise or counterclockwise, respectively.

Examples:
    - %red% turn %green% south %end%
    - %red% turn %green% clock %end%
    - %red% turn %green% counter %end%

You will need this for future tasks, so don't forget about it. Use the next room to apply this new command, and don't forget to check the objectives on the %blue% <info> %end% tab.

As always, reply this email to start the puzzle.

Carry on.
]],
    author = "Automated Introduction System",
    puzzle_id = 'tuto3',
    open_func =
        function()
            Util.findId('manual_tab'):addCommand("turn")
        end
}
