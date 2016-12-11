--MODULE FOR SETUP STUFF--

local setup = {}

--------------------
--SETUP FUNCTIONS
--------------------

--GLOBAL VARIABLES--
W = love.graphics.getWidth() --Current width of the game window
H = love.graphics.getHeight() --Current height of the game window

WIN_BORD = 20

--FONTS--

--Fira-mono table
FIRA = {}
--Global fonts table
FONTS = {
    fira = function(size)
        if FIRA[size] then return FIRA[size] end

        FIRA[size] = love.graphics.newFont("assets/fonts/fira-mono-regular.ttf", size)
        return FIRA[size]
    end,
}

--Other Tables
SUBTP_TABLE = {} --Table with tables for each subtype (for fast lookup)
ID_TABLE = {} --Table with elements with Ids (for fast lookup)

--Set game's global variables, random seed, window configuration and anything else needed
function setup.config()

    --IMAGES--

    -- Tiles
    TILES_IMG = {}
    TILES_IMG["white_floor"] = love.graphics.newImage("assets/images/white_tile.png")

    -- Objects
    OBJS_IMG = {}
    OBJS_IMG["wall_o"] = love.graphics.newImage("assets/images/wall_o.png")
    OBJS_IMG["black_block"] = love.graphics.newImage("assets/images/black_tile.png")

    ROOM_CAMERA_IMG = love.graphics.newImage("assets/images/room_camera.png")

    -- Bot images (assume array part only)
    HEAD = {}
    table.insert(HEAD, love.graphics.newImage("assets/images/body_1.png"))
    BODY = {}
    table.insert(BODY, love.graphics.newImage("assets/images/head_1.png"))

    --RANDOM SEED--
    love.math.setRandomSeed( os.time() )

    --GLOBAL VARIABLES--
    DEBUG = true --DEBUG mode status

    TABS_LOCK = false -- If the tabs cant be clicked

    UNREAD_EMAILS = 0 -- Number of unread emails

    -- Current room
    ROOM = nil

    NAMES = {"Barry", "Larry", "Terry", "Mary", "Fieri", "Danny", "Kenny", "Benny", "Kelly",
        "Harry", "Carie", "Perry", "Sally", "Abby", "Genny", "Figgy", "Ginnie", "Jenny", "Nancy",
        "Manny", "Ellie", "Lenny" }

    -- Move orientations
    NORTH, EAST = Vector.new(0, -1), Vector.new(1, 0)
    SOUTH, WEST = Vector.new(0, 1), Vector.new(-1, 0)
    ORIENT = {NORTH, EAST, SOUTH, WEST}

    -- Rotational orientations
    NORTH_R, EAST_R, SOUTH_R, WEST_R = {math.pi}, {3*math.pi/2}, {0}, {math.pi/2}
    ORIENT_R = {NORTH_R, EAST_R, SOUTH_R, WEST_R}
    for i=1, #ORIENT_R do
        ORIENT_R[i][2] = i
    end

    --TIMERS--
    MAIN_TIMER = Timer.new()  --General Timer

    --INITIALIZING TABLES--

    --Drawing Tables
    DRAW_TABLE = {
    BG   = {}, --Background (bottom layer, first to draw)
    L1   = {}, --Layer 1
    L1u  = {}, --Layer 1 upper
    L2   = {}, --Layer 2
    GUI  = {}  --Graphic User Interface (top layer, last to draw)
    }

    --WINDOW CONFIG--
    love.window.setMode(W, H, {resizable = true, minwidth = 800, minheight = 600})

    --CAMERA--
    CAM = Camera(love.graphics.getWidth()/2, love.graphics.getHeight()/2) --Set camera position to center of screen

    --SHADERS--

    --AUDIO--
end

--Return functions
return setup
