return {
    title = "Lets use some loops",
    text = [[
Remember loops from Hacking101 classes? Well, you better.

The new command is jmp. You provide a label, and it will jump to the line you defined the label on. To define a label, just write any single alphanumeric word (that means only letters and numbers, dummy) followed by a ':'.

After defining a label, you can write any one command in the same line, however the label must come before the command.
But that is optional.

Example that makes the bot walk in circles:
    - banana:
      walk 2
      turn counter
      jmp banana

Example that makes the bot spin endlessly:
    - awesomeLabel66: turn clock
      jmp awesomeLabel66

Complete this puzzle quickly. We'd greatly appreciate it. Don't forget the experiment ends as soon as the objective requirements are completed.

As always, carry on.
]],
    author = "Automated Introduction System", 
    puzzle_id = 'tuto4',
    open_func =
        function()
            -- Util.findId('manual_tab'):addCommand("label") maybe add an entry for labels
            Util.findId('manual_tab'):addCommand("jmp")
        end
}
