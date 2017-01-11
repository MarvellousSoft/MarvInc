return {
    title = "More brainfuck examples",
    text = [[
Hello, this is Rick again. I'll send some more brainfuck examples, now with loops. Make sure you understand all of these. I always assume the data pointer starts at position 0, and all data is 0 (unless stated).

    "[>]"
This will point DP (data pointer) to the next position that has value 0.

    "<[>,]"
This will read values from the input until it reads a 0, and store them in adjacent positions.

    "++++++[>++++++++++<-]>+++"
This will set the value at position 1 to 63, using position 0 as an 'auxiliar' for a loop.

    "[[->+<]>]"
Assuming everything else except the value in position 0 is 0, will endlessly move that value to position 1, and then 2, etc.

    "++++++++[[>],[<]>-]"
This will read 8 values from the input and place them in positions 1..8, assuming none of them are 0.

Hope you got it. If you need more help, don't ask Liv because she will mock you.

Thank you for your attention, carry on.

Richard Black
Programmer intern at Marvellous Inc.s Software Development Department]],
    author = "Richard Black (rick.black@sdd.marv.com)",
    can_be_deleted = true
}
