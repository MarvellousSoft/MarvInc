-- This is a sample level script.
-- We showcase how to write your own puzzles and emails.

-- DISCLAIMER:
-- Before we start, we would like to give out a warning. Puzzles are made by the community, and not
-- the developers, meaning we are not responsible for any deaths, injuries or damages to you or
-- your loved ones (this includes your PC) in case you decide running some sketchy guy's puzzle
-- script. Puzzles are run in a separate environment which contains only safe-ish (emphasis on ish)
-- lua functions. Having said that, we still highly recommend you scanning over any community
-- puzzle for malicious or obfuscated code.  Of course, the art of code obfuscation is a pathway
-- many would consider unnatural, so sometimes just looking through one's code may not reveal
-- anything. In order to prevent any of this naughty business, we give out these three do's and
-- three don'ts for anyone who writes puzzles for MarvInc:
--  1. Do document your code (so people know what they're running on their machines).
--  2. Do have fun writing your puzzle.
--  3. Do give support for those who play your puzzle.
--  4. Don't obfuscate code.
--  5. Don't falsely advertise what your puzzle does (this just raises suspicions on your code).
--  6. Don't be a dick.
-- If everyone followed these rules, the world would be a better place. So make the world better.

-- We call a Level Script (LS for short) a .lua file that contains a puzzle. We call an Email
-- Script (ES) a .lua file that contains an email that should trigger the puzzle. Another sample
-- .lua named email.lua can be found in this same directory explaining how to create your
-- Email Script.

-- A custom puzzle file structure should be as follows. Let / (root) directory be where MarvInc
-- stores its user data (for Windows that'd be AppData, on Linux ~/.local/share/love/marvellous/).
-- A typical puzzle looks something like this:
--
-- /
-- *- custom/
-- *--*-- my_puzzle/
-- *--*--*-- level.lua
-- *--*--*-- email.lua
-- *--*--*-- assets/
-- *--*--*--*-- my_tile.png
-- *--*--*--*-- my_image.png
-- *--*--*--*-- my_sprite.png
--
-- Directory /custom/ is where custom puzzles should be stored. Each puzzle should have its own
-- directory with a unique name. Inside each puzzle directory, two .lua files should be present.
-- The first, level.lua, is the Level Script. The second, email.lua is the Email Script. Any assets
-- should be inside your puzzle directory. How you're going to name them, or where they're going to
-- be located inside this directory is up to you. Just recall that when importing assets, you
-- should tell the parser its relative path in relation to your puzzle directory. So in the above
-- example, you should import my_image.png through the relative path "assets/my_image.png".

-- PUZZLE SCRIPT

-- Just like in any programming language, a LS has reserved keywords. Reserved keywords all begin
-- with a capital letter. We list the reserved keywords, as well as their descriptions and types
-- below:

-- The puzzle's title (string). This should appear in the info tab.
Meta.SetName "Puzzle name"
-- Its unique numbering (string). Usually it follows a certain pattern related to the email chain.
Meta.SetRoomName "S.1"
-- The number of lines of code available for the user (int). Must be > 0 and < 100.
Meta.SetLines(30)
-- The number of registers available for the user (int). Must be >= 0 and <= 200.
Meta.SetMemory(12)
-- The number of test cases to run. Must be >= 1 and <= 10.
Meta.SetTestCount(1)
-- A description of this puzzle's objectives (string).
Meta.SetObjectiveText {
    "Take all even numbers from the green console and place them on the blue console.",
    "Write code.",
    "Be efficient.",
    "Don't be messy.",
    "Have fun."
}

-- Extra information you might want to inform the user of (list of strings).
Meta.SetExtraInfo {
    "Share us your solutions!",
    "I love MarvInc!"
}

-- A puzzle map is two-layered. The bottom-most layer only draws the floor, whilst the top layer
-- handles objects. We refer to the bottom layer as the Floor Layer, and the top one as the Object
-- Layer.

-- During development, we found that the easiest way to both visualize and code a puzzle map was to
-- have a single string representing layers, instead of a matrix. Graphically, it is simpler, but
-- it comes with restrictions: objects must be represented by a single character.

-- The Floor Layer (string).
Floor.SetAll("....................."..
             "....................."..
             "......*.......*......"..
             "......***...***......"..
             "......*..*.*..*......"..
             "......*...*...*......"..
             "......*.......*......"..
             "....................."..
             ".......@..@..@......."..
             "........@.@.@........"..
             "......@@@@@@@@@......"..
             "........@.@.@........"..
             ".......@..@..@......."..
             "....................."..
             "......=========......"..
             "..........=.........."..
             "..mm......=.........."..
             "..mm......=.........."..
             "..........=.........."..
             "......=========......"..
             ".....................")

-- Each character in the Floor's string representation is a tile sprite. To register a tile sprite
-- to a character, use the function Floor.Register.
Floor.Register("white_floor", '.')
Floor.Register("red_tile",    '*')
Floor.Register("green_tile",  '@')
Floor.Register("blue_tile",   '=')

-- Alternatively, if you want to generate a floor map procedurally, it can be easier to just give
-- the tile positions. Indexing starts at 1. PS: Remember to register the tiles before placing them!
Floor.Register("blood_splat_1", 'b')
Floor.Register("blood_splat_2", 'd')
Floor.PlaceAt("b", 1, 1)
Floor.PlaceAt("d", ROWS, COLS)

-- The following are keywords for constants:
-- ROWS: number of rows
-- COLS: number of columns

-- Declaration of the Floor map is not required. You can use Floor:PlaceAt to cover all tiles and
-- not declare the Floor object.

-- For both Object and Floor maps, unregistered characters are set to nothing.

-- The Object Layer (string).
Objects.SetAll("---------------------"..
               "---------------------"..
               "---------------------"..
               "---------------------"..
               "---------------------"..
               "---------------------"..
               "---------------------"..
               "---------------------"..
               "---------------------"..
               "---------------------"..
               "--------------b------"..
               "--------------l------"..
               "---------------------"..
               "---------------------"..
               "---------------------"..
               "---------------------"..
               "---------------------"..
               "---------------------"..
               "---------------------"..
               "---------------------"..
               "---------------------")

-- The Object map works the same way as the Floor map. To register an object, you must first
-- construct a new object instance and link a character to it.

b = Bucket {
    content = "water"
}
Objects.Register(b, 'b')

-- A Bucket may contain paint, water or be otherwise empty. Only paint can be colored.
d = Bucket {
    content = "paint",
    color = "red"
}
Objects.Register(d, 'd')
-- You can also use PlaceAt the same way.
Objects.PlaceAt('d', 10, 10)

Objects.Register(Lava (), 'l')

-- If you want to limit the player's range without having to place a bunch of objects as obstacles,
-- you can simply use InvWall to set invisible walls throughout the map. Just like Floor and
-- Objects, InvWall uses similar syntax and functions. However, it can be kept undeclared and
-- the game will assume there are no invisible walls. Each position in the InvWall can either be ' '
-- (no invisible wall) or '*' (invisible wall).

InvWall.SetAll("                     "..
               "   ***************   "..
               "   *             *   "..
               "   *             *   "..
               "   *             *   "..
               "   *             *   "..
               "   *             *   "..
               "   *             *   "..
               "   *             *   "..
               "   *             *   "..
               "   *             *   "..
               "   *             *   "..
               "   *             *   "..
               "   *             *   "..
               "   *             *   "..
               "   *             *   "..
               "   *             *   "..
               "   *             *   "..
               "   *             *   "..
               "   ***************   "..
               "                     ")

InvWall.Wall(3, 2)
InvWall.NoWall(1, 1)

-- If you want to use a custom image, you can import it using the builtin function Import:Image. It
-- accepts two arguments. The first is a key you want to refer the image as. The second is its
-- relative path (to this .lua file). This image will then be imported to an image table, and can
-- be referred later through its key.
Import.Image("my_img", "example.png")

-- You can add a new floor tile image using the function below.
Import.Tile("my_tile", "tile.png")
Import.Tile("marv_tile", "example.png")

-- And place the new tile using Floor:Register. Note that Floor gives preference to custom tiles.
-- So if you name your new tile "white_floor", all "white_floor" tiles placed in this puzzle will
-- look like the one you imported.

Floor.Register("marv_tile", 'm')

-- All paths must point to your puzzle directory.

-- Each object has its own constructor. Below is a list of objects, their constructors and
-- arguments they admit. Each constructor is a function that takes a table with specific fields as
-- argument.

--[[
// A Bucket. Stores liquid dropable content.
Bucket {
    content   - initial content of this bucket ['paint', 'water', 'empty']
    color     - color of contents [see /classes/color for a list of colors]
}

// Lava. It behaves just like real-world lava, in that if you throw water in it, it
// instantly becomes a solid piece of rock.
Lava {}

// A Console object is a computer that allows either input and/or output.
Console {
    color - console color
    type  - type of console ['input', 'output', 'IO']
    preview_numbers - how many numbers in the console to preview
    data - console input data (when type is 'output', data must be nil or not specified)
    dir - console's orientation ['north', 'east', 'south', 'west']
}

// A Wall
Wall {
    img - wall's image. If none is given, uses game's default wall image.
}
--]]

N = 20

local nums = (function()
    local v = {}
    for i = 0, N-1 do
        table.insert(v, i)
    end
    return v
end)()

C1 = Console {
    color           = "green",
    type            = "input",
    dir             = "east",
    data            = nums,
    preview_numbers = 5,
}
C2 = Console {
    color           = "blue",
    type            = "output",
    dir             = "south",
}
Objects.Register(C1, "c")
Objects.Register(C2, "z")
Objects.PlaceAt("c", 15, 5)
Objects.PlaceAt("z", 5, 15)

C3 = Console {
    color = "orange",
    type  = "IO",
    dir   = "north",
    data  = {1, 2}
}
Objects.Register(C3, "y")
Objects.PlaceAt("y", 15, 15)
Objects.PlaceAt("y", 15, 14)

-- When you create a new object from one of the constructors above, you're not actually creating
-- the game object itself, but just a prototype so that the game engine knows what to create and
-- look for. Once the level is loaded, the floor is drawn and the objects are created, the level
-- parser then allows access to the objects through special functions. Consoles can be accessed
-- through Util.CheckConsoleOutput. After everything has been created, the builtin function
-- passed in Meta.SetOnStart() is then called. You can use this function for more complex
-- initializations.

Meta.SetOnStart(function()
    print("This should print right after the puzzle is loaded.")
end)

-- A second builtin function is Meta.SetCompletedPopup(). It runs as soon as the puzzle is
-- completed. You can use this function to send a message to the player.
Meta.SetCompletedPopup {
    title = "Completed popup title",
    text = "Completed popup body text.",
    color = "blue",
    button1 = {
        text = "Option 1",
        color = "red"
    },
    button2 = {
        text = "Option 2",
        color = "green"
    }
}

v_pairs = (function()
    local v = {}
    for i = 0, N-1 do
        if i % 2 == 0 then
            table.insert(v, i)
        end
    end
    return v
end)()

-- The function set by Meta.SetObjectiveCheck() is run at every end of tick (each turn, command
-- instruction) so that you can check for any objectives being met. It should return true when all
-- objectives have been completed. Return false if it should noop. Return a string if an error
-- should be output and the bot destroyed.

Meta.SetObjectiveCheck(function(grid)
    local v = grid[5][15]
    local ret = Util.CheckConsoleOutput(v, v_pairs)
    return ret
end)

-- The bot's initial position (pair of int).
Bot.SetPosition(math.floor(ROWS/2), math.floor(COLS/2))
Bot.SetPosition(3, 5)
-- The bot's initial orientation (string: 'WEST', 'NORTH', 'EAST' or 'SOUTH').
Bot.SetOrientation "SOUTH"
