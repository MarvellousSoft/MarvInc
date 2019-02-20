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
-- The number of lines of code available for the user (int). If <= 0, sets it to 99.
Meta.SetLines(30)
-- The number of registers available for the user (int). Must be >= 0.
Meta.SetMemory(12)
-- A description of this puzzle's objectives (string).
Objective.SetText [[
These are the objectives for this puzzle:
- Write code.
- Be efficient.
- Don't be messy.
- Have fun.
]]
-- Extra information you might want to inform the user of (string).
Meta.SetInfo [[
Share us your solutions!
]]

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
             "..........=.........."..
             "..........=.........."..
             "..........=.........."..
             "......=========......"..
             ".....................")

-- Each character in the string Floor.L is a tile sprite. To register a tile sprite to a character,
-- use the function Floor:Register.
Floor.Register("white_floor", '.')
Floor.Register("red_tile",    '*')
Floor.Register("green_tile",  '@')
Floor.Register("blue_tile",   '=')

-- Alternatively, if you want to generate a floor map procedurally, it can be easier to just give
-- the tile positions. Indexing starts at 1. PS: Remember to register the tiles before placing them!
Floor.Register("blood_splat_1", 'b')
Floor.Register("blood_splat_2", 'd')
Floor.PlaceAt("blood_splat_1", 1, 1)
Floor.PlaceAt("blood_splat_2", ROWS, COLS)

-- The following are keywords for constants:
-- ROWS: number of rows
-- COLS: number of columns

-- Declaration of the Floor map is not required. You can use Floor:PlaceAt to cover all tiles and
-- not declare the Floor object. Note, however, that if the map floor is not completely filled, the
-- parser will stop and output an error.

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

-- You can also use PlaceAt the same way.
d = Bucket {
    content = "paint",
    color = "red"
}
Objects.Register(d, 'd')
Objects.PlaceAt(d, 10, 10)

Objects.Register(Lava {}, 'l')

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

-- If you want to use a sprite (an animated image), you can import a spritesheet. We only accept
-- horizontal spritesheets, meaning the spritesheet must contain one line. To import a spritesheet,
-- use the builtin function Import:Sprite. This function accepts three arguments: its reference key,
-- the number of frames in the spritesheet and its path.
Import.Sprite("my_sprite", 3, "example_sheet.png")

-- You can add a new floor tile image using the function below.
Import.Tile("my_tile", "tile.png")

-- And place the new tile using Floor:Register. Note that Floor gives preference to custom tiles.
-- So if you name your new tile "white_floor", all "white_floor" tiles placed in this puzzle will
-- be look like the one you imported.

-- All paths must point to your puzzle directory.

-- CAUTION! --
-- Reference keys for Images and Sprites cannot have same names! Otherwise it becomes ambiguous
-- whether you're refering to a sprite or an image. Also note that not all objects support sprites
-- (as of yet, we may add this feature later). If you're not sure if a constructor accepts an
-- image, a sprite or both, check the list below.

-- Each object has its own constructor. Below is a list of objects, their constructors and
-- arguments they admit.

--[[
// A Bucket. Stores liquid dropable content.
Bucket(content, cnt_color)
    content   - initial content of this bucket ['paint', 'water', 'empty']
    cnt_color - color of contents [see /classes/color for a list of colors]

// An Obstacle. Doesn't allow player to move to this object's tile position.
Obstacle(bg, key, d, c)
    bg  - whether to draw the background (floor) image behind this object [boolean]
    key - this object's reference key [string]
    d   - delay if it's a sprite [float]
    c   - color [string]

// A Dead. Terrible naming, I know. This is an object that kills the bot on touch (when bot reaches
// this object's tile position.
Dead(bg, key, bg, c, d)
    bg  - whether to draw the background (floor) image behind this object [boolean]
    key - a reference key either to a sprite or image [string]
    c   - color to be used to color over this object [string]
    d   - if key is a reference to a sprite, d is how fast the sprite should cycle (higher is faster) [float]

// A DeadSwitch. A Dead object that can be "switched" on (kill mode) or off (harmless mode).
// Examples of DeadSwitches are Lava and Lasers.
DeadSwitch(bg, key_on, d, c, img_off, bckt)
    bg      - whether to draw the background (floor) image behind this object [boolean]
    key_on  - reference key to either a sprite or image for when the DeadSwitch is "on" [string]
    d       - if key is a reference to a sprite, d is how fast the sprite should cycle (higher is faster) [float]
    c       - color to be used to color over this object [string]
    key_off - reference key to an image for when the DeadSwitch is "off" (if nil or omitted, it just disappears) [string]
    bckt    - whether this DeadSwitch can be turned off with a bucket's content (if omitted, false) [boolean]

// Lava. It behaves just like real-world lava, in that if you throw water or paint in it, it
// instantly becomes a solid piece of rock. Lava is a DeadSwitch triggered by water.
Lava()

// A Container is an infinite source of water or paint.
Container(bg, key, d, c, cnt, cnt_c)
    bg    - whether to draw the background (floor) image behind this object [boolean]
    key   - a reference key either to a sprite or image [string]
    d     - if key is a reference to a sprite, d is how fast the sprite should cycle (higher is faster) [float]
    c     - color to be used to color over this object [string]
    cnt   - initial content of this bucket ['paint', 'water', 'empty']
    cnt_c - color of contents [see /classes/color for a list of colors]

// A Console object is a computer that allows either input or output (but not both).
Console(img, c, bg, data, n)
    img  - key reference to an image [string]
    c    - console color [string]
    bg   - whether to draw the background (floor) image behind this object [boolean]
    data - if data is nil, then this console accepts data and is classified as 'output'. Else, the
           console is of type 'input', and the bot may take data from it. In this case, if data is
           a function with return type array, then its internal data shall be the function's return
           value. If data is an array, then this console's internal data shall be the array. [nil, func, table]
    n    - how many entries should the console show above it [int]

// An emitter emits a constant stream of deadly laser to a certain direction until obstructed by something.
// An emitter can be turned on or off by a console of the same color as its laser's color.
Emitter(img, bg, c, r_key, r_bg, r_d, r_c)
    img   - key reference to an image [string]
    bg    - whether to draw the background (floor) image behind this object [boolean]
    c     - this emitter's color [string]
    r_key - laser ray's sprite reference key [string]
    r_bg  - whether to draw the background (floor) image behind this ray [boolean]
    r_d   - this laser ray's sprite delay [float]
    r_c   - this laser ray's color [string]
--]]

-- Some objects may accept a colorifying argument. This will draw the object under a certain color
-- scale. If you don't want to color over, use 'white' instead. This will retain the object's
-- original colorscale.

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
Objects.PlaceAt(C1, 15, 5)
Objects.PlaceAt(C2, 5, 15)

C3 = Console {
    color = "orange",
    type  = "IO",
    dir   = "north",
    data  = {1, 2}
}
Objects.Register(C3, "y")
Objects.PlaceAt(C3, 15, 15)
Objects.PlaceAt(C3, 15, 14)

-- When you create a new object from one of the constructors above, you're not actually creating
-- the game object itself, but just a prototype so that the game engine knows what to create and
-- look for. Once the level is loaded, the floor is drawn and the objects are created, the level
-- parser then stores the real game objects to the prototype's attribute Object. After this, the
-- builtin function OnStart() is then called. You can use this function for more complex
-- initializations.

Game.SetOnStart(function()
    print("This should print right after the puzzle is loaded.")
end)

-- A second Game function is Game.OnEnd(). It runs as soon as the puzzle is completed. You can use
-- this function to send a message to the player.
Game.SetOnEnd(function()
    -- The return value of OnEnd generates a Popup window for the user. You may want to give
    -- different popup options depending on the outcome of the puzzle. Return order is:
    --   title - Popup window title
    --   text  - Popup text
    --   color - Popup frame color
    --   f_msg - First button text
    --   f_clr - First button color
    --   s_msg - Second button text
    --   s_clr - Second button color
    return "Title", "Text", "blue", "Option 1", "red", "Option 2", "green"
end)

-- A third Game function is Game.OnDeath(). This function triggers anytime the bot dies. You can use
-- this function to count how many times the player killed bots in this puzzle, and later remind
-- them of how many lives they wasted on Game.OnEnd().

kill_count = 0
best_time = 0

Game.SetOnDeath(function()
    kill_count = kill_count + 1
    best_time = 0
end)

-- The Game function Game.OnTurn triggers on every instruction counter (every tick). Use this to
-- update or handle any objects that may change at every turn.
Game.SetOnTurn(function()
    best_time = best_time + 1
end)


-- Function set by Objective.SetCheck() is run at every end of tick (each turn, command instruction) so that
-- you can check for any objectives being met. It returns true when all objectives have been
-- completed.

v_pairs = (function()
    local v = {}
    for i = 0, N-1 do
        if i % 2 == 0 then
            table.insert(v, i)
        end
    end
    return v
end)()

Objective.SetCheck(function(grid)
    local v = grid[5][15].list
    if table.getn(v) ~= table.getn(v_pairs) then return false end
    for i, n in ipairs(v) do
        if n ~= v_pairs[i] then return false end
    end
    return true
end)

-- The bot's initial position (pair of int).
Bot.SetPosition(math.floor(ROWS/2), math.floor(COLS/2))
Bot.SetPosition(3, 5)
-- The bot's initial orientation (string: 'WEST', 'NORTH', 'EAST' or 'SOUTH').
Bot.SetOrientation "SOUTH"
