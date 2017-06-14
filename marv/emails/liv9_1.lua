return {
    title = "Improving the language",
    text = [[
Nicely done (Y)

For now the language is quite horrible, no condition-checking or loops, makes it impossible to do even the simplest algorithm. Well, let's fix this.

There is a loop structure in brainfuck. It is done using brackets. [code] means that the segment code will be executed as long as the value pointed by the data pointer is non-zero.

More formally, imagine there is an instruction pointer, that points to the instruction that is currently executing (like the white dot you see on the left when executing L++). Excluding the loop, all instructions just make the IP (instruction pointer) increment. When the IP is at a '[', it will jump to the matching ']' if the value pointed by the DP (data pointer) is 0, otherwise it will just increment. In the same way, when the IP is at a ']', it will jump to the matching '[' if the value pointed by the DP is non-zero.

A simple example: suppose the value pointed by the DP is positive*, then using "[-]" will make that value become 0, because it will subtract 1 until it is so. From this you can see that brainfuck is WAY simpler than L++, since you need an ALGORITHM just to make a position become 0.

If instead you write "[->+<]", then what you're actually doing is zeroing the position DP and adding that value do position DP+1. Notice that there can be loops inside loops! (This will make the interpreter much harder than the previous one :P)

We'll give you enough registers to store the whole code in memory, relax. The white console output will be ended by a 0, so you will know when to stop reading the code.

Good luck, you'll need it. Carry on.

-- Liv

* If you're a real L++ expert, you'll see that this works even if the value is negative, since -999 - 1 = 999 (it will take a LOT of time, though).
]],
    author = "Olivia Kavanagh (liv.k@sdd.marv.com)",
    puzzle_id = 'liv9'
}
