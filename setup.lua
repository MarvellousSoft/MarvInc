--MODULE FOR SETUP STUFF--

local setup = {}

--------------------
--SETUP FUNCTIONS
--------------------

--GLOBAL VARIABLES--
W = love.graphics.getWidth() --Current width of the game window
H = love.graphics.getHeight() --Current height of the game window

ROWS = 20
COLS = 20

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

-- Buttons Images
BUTS_IMG = {}
BUTS_IMG["play"] = love.graphics.newImage("assets/images/button_play.png")
BUTS_IMG["fast"] = love.graphics.newImage("assets/images/button_fast.png")
BUTS_IMG["superfast"] = love.graphics.newImage("assets/images/button_superfast.png")
BUTS_IMG["pause"] = love.graphics.newImage("assets/images/button_pause.png")
BUTS_IMG["stop"] = love.graphics.newImage("assets/images/button_stop.png")

--Set game's global variables, random seed, window configuration and anything else needed
function setup.config()

    --IMAGES--

    -- Tiles
    TILES_IMG = {}
    TILES_IMG["white_floor"] = love.graphics.newImage("assets/images/white_tile.png")
    TILES_IMG["black_floor"] = love.graphics.newImage("assets/images/black_tile.png")
    TILES_IMG["red_tile"] = love.graphics.newImage("assets/images/red_tile.png")
    TILES_IMG["green_tile"] = love.graphics.newImage("assets/images/green_tile.png")
    TILES_IMG["blue_tile"] = love.graphics.newImage("assets/images/blue_tile.png")
    TILES_IMG["solid_lava"] = love.graphics.newImage("assets/images/cold_lava_tile.png")

    -- Objects
    OBJS_IMG = {}
    OBJS_IMG["wall_none"] = love.graphics.newImage("assets/images/wall_none.png")
    OBJS_IMG["wall_o"] = love.graphics.newImage("assets/images/wall_o.png")
    OBJS_IMG["black_block"] = love.graphics.newImage("assets/images/black_tile.png")
    OBJS_IMG["red_tile"] = TILES_IMG.red_tile
    OBJS_IMG["green_tile"] = TILES_IMG.green_tile
    OBJS_IMG["blue_tile"] = TILES_IMG.blue_tile
    OBJS_IMG["bucket"] = love.graphics.newImage("assets/images/bucket.png")
    OBJS_IMG["console"] = love.graphics.newImage("assets/images/console.png")

    -- Spritesheets
    SHEET_IMG = {}
    SHEET_IMG["ray"] = {love.graphics.newImage("assets/images/ray_sheet.png"), 2}
    SHEET_IMG["lava"] = {love.graphics.newImage("assets/images/lava_sheet.png"), 4}

    -- Room Img
    ROOM_CAMERA_IMG = love.graphics.newImage("assets/images/room_camera.png")
    -- Background
    BG_IMG = love.graphics.newImage("assets/images/background.png")

    -- Miscellaneous images
    MISC_IMG = {}
    MISC_IMG["static"] = love.graphics.newImage("assets/images/static.png")

    -- Bot images (assume array part only)
    HEAD = {}
    table.insert(HEAD, love.graphics.newImage("assets/images/head_1.png"))
    BODY = {}
    table.insert(BODY, love.graphics.newImage("assets/images/body_1.png"))


    --RANDOM SEED--
    love.math.setRandomSeed( os.time() )

    --GLOBAL VARIABLES--
    DEBUG = true --DEBUG mode status

    TABS_LOCK = false -- If the tabs cant be clicked
    EVENTS_LOCK = false -- All events but popup mouse pressed are locked

    EMPLOYER_NUMBER = love.math.random(100, 99999)

    EMPLOYER_NUMBER = love.math.random(100, 99999)

    UNREAD_EMAILS = 0 -- Number of unread emails

    -- Current room
    ROOM = nil

    NAMES = {"Barry", "Larry", "Terry", "Mary", "Fieri", "Danny", "Kenny", "Benny", "Kelly",
             "Harry", "Carie", "Perry", "Sally", "Abby", "Genny", "Figgy", "Ginnie", "Jenny",
             "Nancy", "Manny", "Ellie", "Lenny", "Ziggy"
            }
    TRAITS = {"Hates Pizza", "Socially Awkward", "Likes Phantom Menace", "Collect Stamps", "Color Blind",
              "Puppy Lover", "Arachnophobic", "Lactose Intolerant", "Snorts when Laughing",
              "Germophobe", "Insomniac", "Lives with his Mom", "Has a Cool Car", "Listens to Emo Rock",
              "Addicted to Caffeine", "Explorer at Heart", "Never Pays Service", "Jerk",
              "Sympathetic", "Funny", "Cool", "11 Toes", "Logical", "Irrational", "Creepy"
             }

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
    SFX = {}
    SFX.loud_static = love.audio.newSource("assets/sound/pink_noise.wav", "static")
    SFX.loud_static:setLooping(true)
    SFX.tab_switch = love.audio.newSource("assets/sound/tab_switch.ogg", "static")
    SFX.new_email = love.audio.newSource("assets/sound/new_email.wav", "static")
    SFX.buzz = love.audio.newSource("assets/sound/buzz.ogg", "static")
    SFX.fail = love.audio.newSource("assets/sound/fail.mp3", "static")
    SFX.click = love.audio.newSource("assets/sound/click.wav", "static")
end

--Return functions
return setup
