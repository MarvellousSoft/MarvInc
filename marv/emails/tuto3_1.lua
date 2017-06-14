return {
    title = "Making good progress",
    text = [[
Good job, Employee #]].. EMPLOYEE_NUMBER .. [[. Lets learn some new instructions.

Use the %red% turn %end% command to, *surprise*, turn the test subject and change the direction he is facing. You can provide a %pink% direction %end% , or the special arguments %pink% clock %end% or %pink% counter %end% , to turn the robot clockwise or counterclockwise, respectively.

Examples:
    - %red% turn %pink% south %end%
    - %red% turn %pink% clock %end%
    - %red% turn %pink% counter %end%

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
