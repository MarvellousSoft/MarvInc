return {
    title = "Lets use some loops",
    text = [[
Remember loops from Hacking101 classes? Well, you better.

The new command is %red% jmp %end% . You provide a %purple% label %end% , and it will jump to the line you defined the %purple% label %end% on. To define a %purple% label %end% , just write any single alphanumeric word (that means only letters and numbers, dummy) followed by a  %purple% colon ' : ' %end% .

After defining a %purple% label %end% , you can optionally write any one command in the same line, however the command must be written after the %purple% ' : ' %end% .
You can use this to save lines in your code.

Example that makes the bot walk in circles:
    - %purple% banana: %end%
      %red% walk %end% 2
      %red% turn %pink% counter %end%
      %red% jmp %end% %purple% banana %end%

Example that makes the bot spin endlessly:
    - %purple% awesomeLabel66: %red% turn %pink% clock %end%
      %red% jmp %purple% awesomeLabel66 %end%

Complete this puzzle quickly. We'd greatly appreciate it. Don't forget the experiment ends as soon as the objective requirements are completed.

As always, carry on.
]],
    author = "Automated Introduction System",
    puzzle_id = 'tuto4',
    open_func =
        function()
            -- Util.findId('manual_tab'):addCommand("label") maybe add an entry for labels
            Util.findId('manual_tab'):addCommand("jmp1")
        end
}
