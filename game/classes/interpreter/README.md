## Interpreter

Almost everything related to interpreting game code.

- parser.lua receives strings and transforms them in code.
- operations.lua is a list and interpreter of all instructions.
- code.lua stores the code created by parser, it is basically a fancy list of operations.
- memory.lua handles the register, reading, writing and stuff.
