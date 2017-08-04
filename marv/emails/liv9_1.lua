return {
    title = "Improving the language",
    text = [[
Nicely done {red}(Y){end}

For now the {blue}language {end}is quite horrible, no condition-checking or loops, makes it impossible to do even the simplest algorithm. Well, let's fix this.

There is a {inst}loop structure {end}in {blue}brainfuck{end}. It is done using {inst}brackets{end}. {inst}[{blue}code{inst}] {end}means that the segment {blue}code {end}will be executed as long as the {num}value {end}pointed by the {addr}data pointer {end}is non-zero.

More formally, imagine there is an {blue}instruction pointer{end}, that points to the instruction that is currently executing (like the white indicator you see on the right when executing L++). Excluding the loop, all instructions just make the {blue}IP (instruction pointer) {end}increment. When the {blue}IP {end}is at a {inst}[{end}, it will jump to the matching {inst}] {end}if the {num}value {end}pointed by the {addr}DP (data pointer) {end}is 0, otherwise it will just increment. In the same way, when the {blue}IP {end}is at a {inst}]{end}, it will jump to the matching {inst}[ {end}if the {num}value {end}pointed by the {addr}DP {end}is non-zero.

A simple example: suppose the value pointed by the {addr}DP {end}is positive*, then using {blue}[-] {end}will make that {num}value {end}become 0, because it will subtract 1 until it is so. From this you can see that {blue}brainfuck {end}is {red}WAY {end}simpler than L++, since you need an {red}ALGORITHM {end}just to make a position become 0.

If instead you write {blue}[->+<]{end}, then what you're actually doing is zeroing the position {addr}DP {end}and adding that value do position {addr}DP+1{end}. Notice that there can be {red}loops inside loops{end}! (This will make the interpreter much harder than the previous one {red}:P{end})

We'll give you enough registers to {red}store the whole code {end}in memory, relax. The white console output will be {red}ended by a 0{end}, so you will know when to stop reading the code.

Good luck, you'll need it. Carry on.

-- Liv

* If you're a real L++ expert, you'll see that this works even if the value is negative, since -999 - 1 = 999 (it will take a LOT of time, though).
]],
    author = "Olivia Kavanagh (liv.k@sdd.marv.com)",
    puzzle_id = 'liv9'
}
