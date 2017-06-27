--MODULE FOR SETUP STUFF--

local setup = {}

--------------------
--SETUP FUNCTIONS
--------------------

--GLOBAL VARIABLES--
W = love.graphics.getWidth() --Current width of the game window
H = love.graphics.getHeight() --Current height of the game window

ROWS = 21
COLS = 21

WIN_BORD = 20

-- End of turn signal
SIGEND = "end_turn"

--FONTS--

--Fira-mono regular font table
FIRA = {}
--Fira-mono bold font table
FIRA_BOLD = {}
--Roboto regular font table
ROBOTO = {}
--Roboto bold font table
ROBOTO_BOLD = {}
--Roboto thin font table
ROBOTO_LIGHT = {}
--Global fonts table
FONTS = {
    fira = function(size)
        if FIRA[size] then return FIRA[size] end

        FIRA[size] = love.graphics.newFont("assets/fonts/fira-mono-regular.ttf", size)
        return FIRA[size]
    end,
    firaBold = function(size)
        if FIRA_BOLD[size] then return FIRA_BOLD[size] end
        FIRA_BOLD[size] = love.graphics.newFont("assets/fonts/fira-mono-bold.ttf", size)
        return FIRA_BOLD[size]
    end,
    roboto = function(size)
        if ROBOTO[size] then return ROBOTO[size] end
        ROBOTO[size] = love.graphics.newFont("assets/fonts/Roboto-Regular.ttf", size)
        return ROBOTO[size]
    end,
    robotoBold = function(size)
        if ROBOTO_BOLD[size] then return ROBOTO_BOLD[size] end
        ROBOTO_BOLD[size] = love.graphics.newFont("assets/fonts/Roboto-Bold.ttf", size)
        return ROBOTO_BOLD[size]
    end,
    robotoLight = function(size)
        if ROBOTO_LIGHT[size] then return ROBOTO_LIGHT[size] end
        ROBOTO_LIGHT[size] = love.graphics.newFont("assets/fonts/Roboto-Light.ttf", size)
        return ROBOTO_LIGHT[size]
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
BUTS_IMG["step"] = love.graphics.newImage("assets/images/button_step.png")

-- Move orientations
NORTH, EAST = Vector.new(0, -1), Vector.new(1, 0)
SOUTH, WEST = Vector.new(0, 1), Vector.new(-1, 0)
ORIENT = {NORTH, EAST, SOUTH, WEST}


--TIMERS--
MAIN_TIMER = Timer.new()  --General Timer

-- Rotational orientations
NORTH_R, EAST_R, SOUTH_R, WEST_R = {math.pi}, {3*math.pi/2}, {0}, {math.pi/2}
ORIENT_R = {NORTH_R, EAST_R, SOUTH_R, WEST_R}
for i=1, #ORIENT_R do
    ORIENT_R[i][2] = i
end

--IMAGES--

-- Tiles
TILES_IMG = {}
TILES_IMG["white_floor"] = love.graphics.newImage("assets/images/white_tile.png")
TILES_IMG["black_floor"] = love.graphics.newImage("assets/images/black_tile.png")
TILES_IMG["grey_tile"] = love.graphics.newImage("assets/images/grey_tile.png")
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
OBJS_IMG["bucket_content"] = love.graphics.newImage("assets/images/bucket_content.png")
OBJS_IMG["console"] = love.graphics.newImage("assets/images/console.png")
OBJS_IMG["emitter"] = love.graphics.newImage("assets/images/emitter.png")

-- Spritesheets
SHEET_IMG = {}
SHEET_IMG["ray"] = {love.graphics.newImage("assets/images/ray_sheet.png"), 2}
SHEET_IMG["lava"] = {love.graphics.newImage("assets/images/lava_sheet.png"), 4}
SHEET_IMG["paint"] = {love.graphics.newImage("assets/images/paint_sheet.png"), 4}

-- Room Img
ROOM_CAMERA_IMG = love.graphics.newImage("assets/images/room_camera.png")
-- Background
BG_IMG = love.graphics.newImage("assets/images/background.png")

-- Miscellaneous images
MISC_IMG = {}
MISC_IMG["static"] = love.graphics.newImage("assets/images/static.png")
MISC_IMG["star"] = love.graphics.newImage("assets/images/star.png")

-- Bot images (assume array part only)
HEAD = {
    love.graphics.newImage("assets/images/head_1.png"),
}
BODY = {
    love.graphics.newImage("assets/images/body_1.png")
}


--Set game's global variables, random seed, window configuration and anything else needed
function setup.config()

    --RANDOM SEED--
    love.math.setRandomSeed( os.time() )

    --GLOBAL VARIABLES--
    DEBUG = true --DEBUG mode status

    TABS_LOCK = 0 -- If the tabs cant be clicked
    EVENTS_LOCK = 0 -- All events but popup mouse pressed are locked

    EMPLOYEE_NUMBER = love.math.random(200, 2000)

    UNREAD_EMAILS = 0 -- Number of unread emails

    -- Current room
    ROOM = nil

    NAMES = {"Barry", "Larry", "Terry", "Mary", "Fieri", "Danny", "Kenny", "Benny", "Kelly",
             "Harry", "Carie", "Perry", "Sally", "Abby", "Genny", "Figgy", "Ginnie", "Jenny",
             "Nancy", "Manny", "Ellie", "Lenny", "Ziggy", "Tammy", "Kerry", "Gerry", "Bonnie",
             "Tony", "Jammy", "Fanny", "Yammy", "Jerry", "Omarry", "Ury"
            }
    TRAITS = {"hates pizza", "socially awkward", "likes Phantom Menace", "collects stamps", "color blind",
              "puppy lover", "arachnophobic", "lactose intolerant", "snorts when laughing",
              "germophobe", "insomniac", "lives with mom", "has a cool car", "listens to emo rock",
              "addicted to caffeine", "explorer at heart", "never pays service", "jerk",
              "sympathetic", "funny", "cool", "11 toes", "logical", "irrational", "creepy", "nice cook",
              "liked lost's ending", "bought an ouya", "hates soda", "has heterochromia", "artistic",
              "smells", "inconvenient", "hates sports", "uses hashtags", "rad dance moves",
              "types with just one finger", "has a russian accent", "eats m&ms by color", "obsessed with michael cera",
              "eats toothpaste", "grammar nazi", "collects purple kilts", "very rosy cheeks", "eats fingernails",
              "hears voice", "terribly shy", "blinks furiously when lying", "memorized moby dick", "lost an eye in a bear accident",
              "hates bears", "never finished a game without a walkthrough", "overachiever", "underacheiver",
              "always drunk", "addicted to HIMYM", "never tips", "vegan without the powers", "has to touch everything",
              "has OCD", "class clown", "in a relationship with a pet rock", "literally allergic to bad jokes",
              "terrified of babies", "picks scabs", "pretends is a mime at parties", "proud believer of crab people",
              "reads minds", "can play the theremin", "can recite de alphabet backwards perfectly",
              "loves costume parties", "can correctly give current latitude and longitude at all times",
              "accidently makes sexual innuendos", "has a catchphrase", "has an unhealthy obession with Kermit the Frog",
              "can't ride a bike", "is always seen wearing pajamas", "afraid of the internet", "is agressively against socks",
              "speaks in a monotone voice", "born in a leap year", "slow walker", "never showers", "sweats profusely",
              "chews ice cube for dinner", "heavy sleeper", "fear of closed doors", "saves their urine in a jar",
              "kleptomaniac", "only watches SpongeBob reruns", "constantly makes animal noises", "afraid of feet",
              "has a foot fetish", "TYPES IN ALL CAPS", "know it all", "has bad acne"
             }


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
    ResManager.init()
    ResManager.adjustWindow(W, H)

    --CAMERA--
    CAM = Camera(W/2, H/2) --Set camera position to center of screen

    --SHADERS--

    --AUDIO--
    SFX = {}
    SFX.loud_static = love.audio.newSource("assets/sound/pink_noise.wav", "static")
    SFX.loud_static:setLooping(true)
    SFX.tab_switch = love.audio.newSource("assets/sound/tab_switch.ogg", "static")
    SFX.new_email = love.audio.newSource("assets/sound/new_email.wav", "static")
    SFX.new_email:setVolume(.5)
    SFX.buzz = love.audio.newSource("assets/sound/buzz.ogg", "static")
    SFX.fail = love.audio.newSource("assets/sound/fail.mp3", "static")
    SFX.click = love.audio.newSource("assets/sound/click.wav", "static")
end

--Return functions
return setup
