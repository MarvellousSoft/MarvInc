return {
    title = "Using memory",
    text = [[
Let's take it up a notch shall we? You will now learn to use the %cyan% registers %end% and two new commands: %red% write %end% and %red% add %end% .

%cyan% Registers %end% can hold %green% values %end% . Think of them as the memory in your %blue% <code> %end% . To access the %green% content %end% of the %cyan% register #n %end% , just write %green% [n] %end% . So if you want the %green% value %end% in the %cyan% register #5 %end% , you write %green% [5] %end% . You can see them just below your %blue% <code> %end% notepad, with their respective numbers and contents. %cyan% Register %end% numbers start from 0, and are located in the top-left corner of a %cyan% register %end% , while the %green% content %end% is the big number centered on the box.

The %red% add %end% command receives three arguments: Two %green% values %end% to be added, and the %cyan% address %end% where their sum will be stored.

Look at the following examples:
    - %red% add %green% [1] 3 %cyan% 7 %end% # adds 3 to the content of register #1, and stores it at register #7.
    - %red% add %green% [2] [5] %cyan% 2 %end% # adds register #2 contents to register #5 contents and stores it at register #2 again.

Finally, the %red% write %end% command receives a %green% value %end% argument, and a second optional %pink% direction %end% argument. You'll use the %red% write %end% command to write %green% values %end% in a %orange% console %end% , which are the big colorful computer objects in the room. The %pink% direction %end% determines which direction the %orange% console %end% is. If not provided, as usual, the robot will try to write in the direction he is facing.

Make sure to understand all these concepts. You can do it.

Best of Luck. Carry on. :)
]],
    author = "Automated Introduction System",
    puzzle_id = 'tuto6',
    open_func =
        function()
            Util.findId('manual_tab'):addCommand("add1")
            Util.findId('manual_tab'):addCommand("sub1")
            Util.findId('manual_tab'):addCommand("mov1")
            Util.findId('manual_tab'):addCommand("read1")
            Util.findId('manual_tab'):addCommand("write1")
        end
}
