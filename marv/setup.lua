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
BUTS_IMG["fast_blocked"] = love.graphics.newImage("assets/images/button_fast_blocked.png")
BUTS_IMG["superfast"] = love.graphics.newImage("assets/images/button_superfast.png")
BUTS_IMG["superfast_blocked"] = love.graphics.newImage("assets/images/button_superfast_blocked.png")
BUTS_IMG["pause"] = love.graphics.newImage("assets/images/button_pause.png")
BUTS_IMG["pause_blocked"] = love.graphics.newImage("assets/images/button_pause_blocked.png")
BUTS_IMG["stop"] = love.graphics.newImage("assets/images/button_stop.png")
BUTS_IMG["stop_blocked"] = love.graphics.newImage("assets/images/button_stop_blocked.png")
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
TILES_IMG["building_floor"] = love.graphics.newImage("assets/images/building_floor.png")
TILES_IMG["black_floor"] = love.graphics.newImage("assets/images/black_tile.png")
TILES_IMG["grey_tile"] = love.graphics.newImage("assets/images/grey_tile.png")
TILES_IMG["red_tile"] = love.graphics.newImage("assets/images/red_tile.png")
TILES_IMG["green_tile"] = love.graphics.newImage("assets/images/green_tile.png")
TILES_IMG["blue_tile"] = love.graphics.newImage("assets/images/blue_tile.png")
TILES_IMG["solid_lava"] = love.graphics.newImage("assets/images/cold_lava_tile.png")
TILES_IMG["blood_splat_1"] = love.graphics.newImage("assets/images/blood_splat_1.png")
TILES_IMG["blood_splat_2"] = love.graphics.newImage("assets/images/blood_splat_2.png")
TILES_IMG["blood_splat_3"] = love.graphics.newImage("assets/images/blood_splat_3.png")
TILES_IMG["blood_splat_4"] = love.graphics.newImage("assets/images/blood_splat_4.png")

-- Objects
OBJS_IMG = {}
OBJS_IMG["wall_none"] = love.graphics.newImage("assets/images/wall_none.png")
OBJS_IMG["building_wall"] = love.graphics.newImage("assets/images/building_wall.png")
OBJS_IMG["building_outside"] = love.graphics.newImage("assets/images/building_outside.png")
OBJS_IMG["building_corner"] = love.graphics.newImage("assets/images/building_wall_corner.png")
OBJS_IMG["wall_o"] = love.graphics.newImage("assets/images/wall_o.png")
OBJS_IMG["black_block"] = love.graphics.newImage("assets/images/black_tile.png")
OBJS_IMG["red_tile"] = TILES_IMG.red_tile
OBJS_IMG["green_tile"] = TILES_IMG.green_tile
OBJS_IMG["blue_tile"] = TILES_IMG.blue_tile
OBJS_IMG["bucket"] = love.graphics.newImage("assets/images/bucket.png")
OBJS_IMG["bucket_content"] = love.graphics.newImage("assets/images/bucket_content.png")
OBJS_IMG["console"] = love.graphics.newImage("assets/images/console.png")
OBJS_IMG["emitter"] = love.graphics.newImage("assets/images/emitter.png")
OBJS_IMG["papers"] = love.graphics.newImage("assets/images/papers.png")
OBJS_IMG["table"] = love.graphics.newImage("assets/images/fancy_table.png")

OBJS_IMG["dead_body1"] = love.graphics.newImage("assets/images/dead_body_1.png")
OBJS_IMG["dead_body2"] = love.graphics.newImage("assets/images/dead_body_2.png")
OBJS_IMG["dead_body3"] = love.graphics.newImage("assets/images/dead_body_3.png")
OBJS_IMG["dead_body_hair"] = love.graphics.newImage("assets/images/dead_hair_1.png")

-- Character colors
Color = require "classes.color.color"
CHR_CLR = {}
CHR_CLR['bm'] = Color.yellow()
CHR_CLR['diego'] = Color.pink()
CHR_CLR['fergus'] = Color.brown()
CHR_CLR['franz'] = Color.gray()
CHR_CLR['jen'] = Color.red()
CHR_CLR['liv'] = Color.purple()
CHR_CLR['paul'] = Color.green()

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
MISC_IMG["arrow"] = love.graphics.newImage("assets/images/arrow.png")

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
             "Tony", "Jammy", "Fanny", "Yammy", "Jerry", "Omarry", "Ury", "Lilly", "Nelly",
             "Annie",
            }
    --Traits table composed of tuples, where the first position is a trait and the second a table containing specific dialog options for this trait
    TRAITS = {
      {"hates pizza", {"Hawaiian pizza isn't so bad, you know?"}},
      {"socially awkward", {}},
      {"likes Phantom Menace", {"Jar Jar Binks is soooo underrated...", "Meesa think yousa no know how to solve thisa problem."}},
      {"collects stamps", {"You know whats better than bacon? Freaking stamps man."}},
      {"color blind", {"Hey, quick question. Is my hair green or red?"}},
      {"puppy lover", {"Woof Woof Bark Bark :3"}},
      {"arachnophobic", {"DUDE IS THAT A SPIDER IN THE CEILING?!"}},
      {"lactose intolerant", {"Soy milk is the bomb."}},
      {"snorts when laughing", {}},
      {"germophobe", {"Please don't make me touch anything dirty."}},
      {"insomniac", {}},
      {"lives with mom", {}},
      {"has a cool car", {"I can give you a ride someday", "Hey have I told you about my sweet Sedan? 'ts preety cool"}},
      {"listens to emo rock", {}},
      {"addicted to caffeine", {}},
      {"explorer at heart", {}},
      {"never tips", {"10% service it's just an absurd, don't you think?"}},
      {"jerk", {"You're ugly.", "F%$# you."}},
      {"sympathetic", {"Don't stress man, take your time. :)", "These puzzles sure are tough huh?"}},
      {"funny", {"You know the worst part of being lonely here? I can't up my frisbee game."}},
      {"cool", {}},
      {"11 toes", {}},
      {"logical", {}},
      {"irrational", {}},
      {"creepy", {"I can hear your breathing from here...:)", "You smell good today. Is that because of the new shampoo you bought yesterday?"}},
      {"good cook", {}},
      {"liked LOST's ending", {"Hurley was the best character in a TV show by far"}},
      {"bought an Ouya", {}},
      {"hates soda", {}},
      {"has heterochromia", {}},
      {"artistic", {}},
      {"smells", {}},
      {"inconvenient", {}},
      {"hates sports", {}},
      {"soccer fan", {"Did you see that ludicrous display last night?"}},
      {"uses hashtags", {"#NailingIt", "#YouCanDoIt"}},
      {"rad dance moves", {}},
      {"types with just one finger", {}},
      {"has a russian accent", {}},
      {"eats M&Ms by color", {}},
      {"obsessed with Michael Cera", {}},
      {"obsessed with Nicolas Cage", {}},
      {"eats toothpaste", {}},
      {"grammer nazi", {"Actually, it's 'grammar nazi'."}},
      {"collects purple kilts", {}},
      {"very rosy cheeks", {}},
      {"eats fingernails", {}},
      {"hears voices", {"DON'T TELL ME WHAT TO DO", "Of course not.", "Hahaha, no. That would be silly", "What?", "Why?", "Okay okay! I'll do it! Just shut up!"}},
      {"terribly shy", {"..."}},
      {"blinks furiously when lying", {}},
      {"memorized Moby Dick", {}},
      {"lost an eye in a bear accident", {"An eye for an eye... That bear sure showed me."}},
      {"hates bears", {"Goddamn bears stealing our honeykeeping jobs!"}},
      {"never finished a game without a walkthrough", {"You should look for the solution to this puzzle on the internet!"}},
      {"overachiever", {}},
      {"underachiever", {}},
      {"always drunk", {"Jsut one moer drink..."}},
      {"addicted to HIMYM", {"This puzzle is LEGEN --wait for it-- DARY!! hahaha"}},
      {"vegan without the powers", {}},
      {"has to touch everything", {}},
      {"has OCD", {}},
      {"class clown", {}},
      {"in a relationship with a pet rock", {}},
      {"literally allergic to bad jokes", {}},
      {"terrified of babies", {}},
      {"picks scabs", {}},
      {"pretends is a mime at parties", {}},
      {"proud believer of crab people", {}},
      {"reads minds", {"This puzzle is not a pain in the ass. Stop thinking that."}},
      {"can play the theremin", {}},
      {"can recite the alphabet backwards perfectly", {"This puzzle is easy as ZYX :)"}},
      {"loves costume parties", {}},
      {"can correctly give current latitude and longitude at all times", {}},
      {"accidently makes sexual innuendos", {"This is too hard and long! I can't take it anymore. Just finish already!"}},
      {"has a catchphrase", {"Wubba lubba dub dub"}},
      {"has an unhealthy obession with Kermit the Frog", {}},
      {"can't ride a bike", {}},
      {"is always seen wearing pajamas", {}},
      {"afraid of the internet", {"They say you can catch a virus in this Internet!"}},
      {"is agressively against socks", {}},
      {"speaks in a monotone voice", {}},
      {"born in a leap year", {"I'm turning 6 today. :P"}},
      {"slow walker", {}},
      {"never showers", {}},
      {"sweats profusely", {}},
      {"chews ice cubes for dinner", {}},
      {"heavy sleeper", {}},
      {"fear of closed doors", {}},
      {"stores their urine in a jar", {}},
      {"kleptomaniac", {"Can I borrow your computer when I leave this place?"}},
      {"only watches SpongeBob reruns", {}},
      {"constantly makes animal noises", {"Moo", "Oink Oink","Baaaaaaah", "Meeeoow ;3", "Gobble gobble gobble"}},
      {"afraid of feet", {}},
      {"has a foot fetish", {"Could you describe your feet for me? ;)"}},
      {"TYPES IN ALL CAPS", {"HEY MAN U DOING ALRIGHT THERE?"}},
      {"know it all", {"Did you know a crocodile can't poke its tongue out?"}},
      {"has bad acne", {}},
      {"conspiracy theorist", {"9/11 was an inside job.", "Illuminati are behind it all.", "Vaccination is a lie created by the media.", "We're all being mind-controlled!"}},
      {"nihilist", {"This puzzle doesn't matter. Nothing does."}},
      {"ArchLinux user", {"Did I tell you I run ArchLinux?"}},
      {"Apple fanboy", {"The new iPhone isn't really that expensive... I'll just take a second mortgage..."}},
      {"Elvis impersonator", {"Yeah baby yeah...", "I guess this \"robot\" microchip is... Always on my mind, baby."}},
      {"has the Disco Fever", {"The boogie's gonna start to explode any time now, baby...", "I'm gettin' loose y'all!", "Gotta fight with expert timing, baby!", "Gotta feel the city breakin' and everybody shakin'!", "I'm stayin' alive!", "Baby, that's the way, uh-huh uh-huh, I like it!", "Let's get the boogie started!", "Let's do the Freak! I've heard it's quite chic!", "Do you remember the 21st of September?"}, {"Baby, give it up! Give it up, baby give it up!"}},
      {"1/128 irish", {"I can't wait for St. Pattys day!"}},
      {"german", {"Das ist nicht effizient. You should optimize your code."}},
      {"spanish", {"Oye chico! When I can do the siesta, eh?"}},
      {"hypochondriac", {"Oh man, I'm not feeling really well...", "Was this bruise here before?! Shit! It could be rhabdomyolysis!", "Feeling a little dizzy..."}},
      {"game developer", {"Art of Game Design is the best book ever written!", "Let's make a Game Design Document to solve this!"}},
      {"never-nude", {"There are dozens of us!"}},
      {"ambidextrous", {}},
      {"left-handed", {}},
      {"procrastinator", {}},
      {"national spelling bee winner", {}},
      {"frugal", {}},
      {"freakishly tall", {}},
      {"went to Burning Man", {"Have I told you how awesome it was at Burning Man?!", "I'm telling you, Burning Man is eye-opening!"}},
      {"gambling addict", {}},
      {"diabetic", {}},
      {"only drinks soda", {}},
      {"only listens to Insane Clown Posse", {}},
      {"thinks it's a pirate", {"Yaaaaaaaarrrrr"}},
    }

    --Regular dialogs any robot can say
    REGULAR_DIALOGS = {
      "This one seems pretty straight forward",
      "Hey how are things going?",
      "Nice day right? I mean, I'm really asking, can't see a thing from here.",
      "Taking your time huh?",
      "Please move this along",
      "Can you go a little faster there mate?",
      "All I wanted was a hug...",
      "Try not to kill me please.",
      "This looks more challenging that I thought.",
      "Can you finish this one before I fall asleep?",
      "How long have you been on this task?",
      "Any progress?",
      "HA! I figured it out!\n\n...but I'm not telling you.",
    }

    --Introduction dialogs any robot can say once, where {bot_name} will be replaced by its name
    INTRO_DIALOGS = {
      "Hello, my name is {bot_name}.",
      "{bot_name}. Nice to meet you.",
      "Bot {bot_name} waiting your instructions.",
      "Sup.",
      "Hey there, looks like we'll be stuck together for a while :)",
      "{bot_name} is my name. Serving you is my game ;)",
      "I hope you don't kill me like the last one...",
      "Hi buddy!",
      "Hey man.",
      "Hello.",
      "You can call me {bot_name}.",
      "Hey I'm {bot_name}. Let's solve this.",
      "Let's hope I don't end the same way as the other robots, ok?",
      "My name is {bot_name} and we are now best friends!",
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
    SFX.side_message = love.audio.newSource("assets/sound/side_message_blip.wav", "static")
end

--Return functions
return setup
