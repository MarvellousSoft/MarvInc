--MODULE FOR SETUP STUFF--

local setup = {}

--------------------
--SETUP FUNCTIONS
--------------------

--Set game's global variables, random seed, window configuration and anything else needed
function setup.config()

    --IMAGES--

    --RANDOM SEED--
    love.math.setRandomSeed( os.time() )

    --GLOBAL VARIABLES--
    DEBUG = true --DEBUG mode status

    W = love.graphics.getWidth() --Current width of the game window
    H = love.graphics.getHeight() --Current height of the game window

    --TIMERS--
    MAIN_TIMER = Timer.new()  --General Timer

    --INITIALIZING TABLES--

    --Drawing Tables
    DRAW_TABLE = {
    BG  = {}, --Background (bottom layer, first to draw)
    L1  = {}, --Layer 1
    L2  = {}, --Layer 2
    GUI = {}  --Graphic User Interface (top layer, last to draw)
    }

    --Other Tables
    SUBTP_TABLE = {} --Table with tables for each subtype (for fast lookup)
    ID_TABLE = {} --Table with elements with Ids (for fast lookup)

    --WINDOW CONFIG--
    love.window.setMode(W, H, {resizable = true, minwidth = 800, minheight = 600})

    --CAMERA--
    CAM = Camera(love.graphics.getWidth()/2, love.graphics.getHeight()/2) --Set camera position to center of screen

    --SHADERS--

    --AUDIO--

end

--Return functions
return setup
