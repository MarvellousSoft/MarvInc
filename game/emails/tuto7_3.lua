return {
    title = "Some read command examples",
    text = [[
In case you need some further guidance, here are some examples using the read command and conditional jumping.

Example where the bot reads an input from the console below him, and writes in the console above him. In both cases he is using the register #0 to store the values.
    - read 0 down
    - write [0] up

Example where the bot will keep reading the input from the console to his left (west) until it equals the input he got from the console to his right (east). Then he will be able to walk down
    - read 0 east
    - marv: read 1 west
    - jne [0] [1] marv
    - walk down

With the read command you can read inputs from the consoles, while with the write you can output to the consoles.

Use the conditional jumps to make logical loops for your programs. Understanding all this is essencial for every member of our company.

Follow you dreams, and carry on.
]],
    author = "Automated Introduction System",
    can_be_deleted = true
}
