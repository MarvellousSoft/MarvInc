--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

--MODULE FOR SETUP STUFF--

local setup = {}

--------------------
--SETUP FUNCTIONS
--------------------

VERSION = "1.3.4"

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
local fonts = {
    fira = "assets/fonts/fira-mono-regular.ttf",
    firaBold = "assets/fonts/fira-mono-bold.ttf",
    roboto = "assets/fonts/Roboto-Regular.ttf",
    robotoBold = "assets/fonts/Roboto-Bold.ttf",
    robotoLight = "assets/fonts/Roboto-Light.ttf",
    comfortaa = "assets/fonts/Comfortaa-Regular.ttf",
    comfortaaBold = "assets/fonts/Comfortaa-Bold.ttf",
    comfortaaLight = "assets/fonts/Comfortaa-Light.ttf",
}


--FONTS

FONTS = {}
for name, file in pairs(fonts) do
    local stored = {}
    FONTS[name] = function(size)
        if not stored[size] then
            stored[size] = love.graphics.newFont(file, size)
        end
        return stored[size]
    end
end

--Other Tables
SUBTP_TABLE = {} --Table with tables for each subtype (for fast lookup)
ID_TABLE = {} --Table with elements with Ids (for fast lookup)

-- Move orientations
NORTH, EAST = Vector.new(0, -1), Vector.new(1, 0)
SOUTH, WEST = Vector.new(0, 1), Vector.new(-1, 0)
ORIENT = {NORTH, EAST, SOUTH, WEST}

--Previous window state (to store in case of going back from fullscreen)
PREV_WINDOW = nil

--if game is already closing, to prevent other instances of closing
IS_EXITING = false


--TIMERS--
MAIN_TIMER = Timer.new()  --General Timer
AUDIO_TIMER = Timer.new()  --General Audio Timer

-- Rotational orientations
NORTH_R, EAST_R, SOUTH_R, WEST_R = {math.pi}, {3*math.pi/2}, {0}, {math.pi/2}
ORIENT_R = {NORTH_R, EAST_R, SOUTH_R, WEST_R}
for i=1, #ORIENT_R do
    ORIENT_R[i][2] = i
end

--IMAGES--

-- Buttons Images
BUTS_IMG = {}
BUTS_IMG["play"] = love.graphics.newImage("assets/images/button_play.png")
BUTS_IMG["play_blocked"] = love.graphics.newImage("assets/images/button_play_blocked.png")
BUTS_IMG["fast"] = love.graphics.newImage("assets/images/button_fast.png")
BUTS_IMG["fast_blocked"] = love.graphics.newImage("assets/images/button_fast_blocked.png")
BUTS_IMG["superfast"] = love.graphics.newImage("assets/images/button_superfast.png")
BUTS_IMG["superfast_blocked"] = love.graphics.newImage("assets/images/button_superfast_blocked.png")
BUTS_IMG["pause"] = love.graphics.newImage("assets/images/button_pause.png")
BUTS_IMG["pause_blocked"] = love.graphics.newImage("assets/images/button_pause_blocked.png")
BUTS_IMG["stop"] = love.graphics.newImage("assets/images/button_stop.png")
BUTS_IMG["stop_blocked"] = love.graphics.newImage("assets/images/button_stop_blocked.png")
BUTS_IMG["step"] = love.graphics.newImage("assets/images/button_step.png")
BUTS_IMG["exit"] = love.graphics.newImage("assets/images/exit_button_regular.png")
BUTS_IMG["exit_hover"] = love.graphics.newImage("assets/images/exit_button_mouse_over.png")
BUTS_IMG["reboot"] = love.graphics.newImage("assets/images/reboot_button_regular.png")
BUTS_IMG["reboot_hover"] = love.graphics.newImage("assets/images/reboot_button_mouse_over.png")
BUTS_IMG["settings"] = love.graphics.newImage("assets/images/settings.png")
BUTS_IMG["achievements"] = love.graphics.newImage("assets/images/achievements.png")
BUTS_IMG["leaderboards"] = love.graphics.newImage("assets/images/leaderboards.png")
BUTS_IMG["leaderboards_bg"] = love.graphics.newImage("assets/images/leaderboards_bg.png")
BUTS_IMG["upload"] = love.graphics.newImage("assets/images/upload.png")
BUTS_IMG["next_test"] = BUTS_IMG.play
BUTS_IMG["prev_test"] = love.graphics.newImage("assets/images/button_play_mirror.png")

--Icons
ICON_IMG = {}
ICON_IMG["16"] = love.image.newImageData("assets/icons/16x16.png")
ICON_IMG["24"] = love.image.newImageData("assets/icons/24x24.png")
ICON_IMG["32"] = love.image.newImageData("assets/icons/32x32.png")
ICON_IMG["48"] = love.image.newImageData("assets/icons/48x48.png")
ICON_IMG["64"] = love.image.newImageData("assets/icons/64x64.png")
ICON_IMG["96"] = love.image.newImageData("assets/icons/96x96.png")

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
OBJS_IMG["building_window"] = love.graphics.newImage("assets/images/building_window.png")
OBJS_IMG["building_corner"] = love.graphics.newImage("assets/images/building_wall_corner.png")
OBJS_IMG["building_inner"] = love.graphics.newImage("assets/images/building_innerwall.png")
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
OBJS_IMG["cloud_1"] = love.graphics.newImage("assets/images/cloud_1.png")

OBJS_IMG["dead_body1"] = love.graphics.newImage("assets/images/dead_body_1.png")
OBJS_IMG["dead_body2"] = love.graphics.newImage("assets/images/dead_body_2.png")
OBJS_IMG["dead_body3"] = love.graphics.newImage("assets/images/dead_body_3.png")
OBJS_IMG["dead_body_hair"] = love.graphics.newImage("assets/images/dead_hair_1.png")

-- Custom puzzle assets.
CUST_OBJS_IMG = {}
CUST_TILES_IMG = {}
CUST_SHEET_IMG = {}

-- Character colors
Color = require "classes.color.color"
CHR_CLR = {}
CHR_CLR['bm'] = Color.yellow()
CHR_CLR['diego'] = Color.pink()
CHR_CLR['fergus'] = Color.brown()
CHR_CLR['franz'] = Color.gray()
CHR_CLR['jen'] = Color.red()
CHR_CLR['hr'] = Color.gray()
CHR_CLR['liv'] = Color.purple()
CHR_CLR['paul'] = Color.green()
CHR_CLR['auto'] = Color.orange()
CHR_CLR['human'] = Color.blue()
CHR_CLR['news'] = Color.teal()
CHR_CLR['emergency'] = Color.magenta()
CHR_CLR['ryr'] = Color.add3(Color.blue(), Color.purple(), Color.orange())
CHR_CLR['spam'] = Color.violet()
CHR_CLR['black'] = Color.black()

-- Spritesheets
SHEET_IMG = {}
SHEET_IMG["ray"] = {love.graphics.newImage("assets/images/ray_sheet.png"), 2}
SHEET_IMG["lava"] = {love.graphics.newImage("assets/images/lava_sheet.png"), 4}
SHEET_IMG["paint"] = {love.graphics.newImage("assets/images/paint_sheet.png"), 4}
SHEET_IMG["fireplace"] = {love.graphics.newImage("assets/images/fireplace_sheet.png"), 6}

-- Asset reference table
local ASSET_TABLE_REFS = {image={CUST_OBJS_IMGS, OBJS_IMGS}, sprite={CUST_SHEET_IMG, SHEET_IMG}}

-- Pulls an asset from the asset tables. Argument key is the reference key. Optional argument t
-- explicits whether key is a sprite or image.
function PULL_ASSET(key, t)
    if key == nil then
        print("Expected reference key to asset. Got nil value!")
        return nil
    end
    if t ~= nil then
        for _, T in ipairs(ASSET_TABLE_REFS[t]) do
            local a = T[key]
            if a ~= nil then return a end
        end
        print("Asset "..key.." not found!")
        return nil
    end
    local a = CUST_OBJS_IMG[key]
    if a ~= nil then return a end
    a = OBJS_IMG[key]
    if a ~= nil then return a end
    a = CUST_SHEET_IMG[key]
    if a ~= nil then return a end
    a = SHEET_IMG[key]
    if a ~= nil then return a end
    print("Asset "..key.." not found!")
    return nil
end

-- Author Images
AUTHOR_IMG = {}
AUTHOR_IMG["unknown"] = love.graphics.newImage("assets/images/authors/unknown.png")
AUTHOR_IMG["liv"] = love.graphics.newImage("assets/images/authors/liv.png")
AUTHOR_IMG["fergus"] = love.graphics.newImage("assets/images/authors/fergus.png")
AUTHOR_IMG["paul"] = love.graphics.newImage("assets/images/authors/paul.png")
AUTHOR_IMG["auto"] = love.graphics.newImage("assets/images/authors/auto.png")
AUTHOR_IMG["human resources"] = love.graphics.newImage("assets/images/authors/hr.png")
AUTHOR_IMG["jan"] = love.graphics.newImage("assets/images/authors/jen.png")
AUTHOR_IMG["diego"] = love.graphics.newImage("assets/images/authors/diego.png")
AUTHOR_IMG["richard"] = love.graphics.newImage("assets/images/authors/black.png")
AUTHOR_IMG["bill"] = love.graphics.newImage("assets/images/authors/bill.png")
AUTHOR_IMG["miles"] = love.graphics.newImage("assets/images/authors/miles.png")
AUTHOR_IMG["franz"] = love.graphics.newImage("assets/images/authors/franz.png")
AUTHOR_IMG["newsletter"] = love.graphics.newImage("assets/images/authors/news.png")
AUTHOR_IMG["renato"] = love.graphics.newImage("assets/images/authors/ryr.png")

-- Room Img
ROOM_CAMERA_IMG = love.graphics.newImage("assets/images/room_camera.png")
-- Background
BG_IMG = love.graphics.newImage("assets/images/background.png")

--Achievements images
ACH_IMG = {}
ACH_IMG["incompleted"] = love.graphics.newImage("assets/images/achievements/incompleted.png")
ACH_IMG["completed"] = love.graphics.newImage("assets/images/achievements/completed.png")
ACH_IMG["unique_robot"] = love.graphics.newImage("assets/images/achievements/unique_robot.png")
ACH_IMG["blaze_it"] = love.graphics.newImage("assets/images/achievements/blaze_it.png")
ACH_IMG["first"] = love.graphics.newImage("assets/images/achievements/first.png")
ACH_IMG["all_puzzles"] = love.graphics.newImage("assets/images/achievements/all_puzzles.png")
ACH_IMG["kill1"] = love.graphics.newImage("assets/images/achievements/kill_1.png")
ACH_IMG["kill10"] = love.graphics.newImage("assets/images/achievements/kill_10.png")
ACH_IMG["kill100"] = love.graphics.newImage("assets/images/achievements/kill_100.png")
ACH_IMG["complete_tut"] = love.graphics.newImage("assets/images/achievements/completed_tut.png")
ACH_IMG["complete_act1"] = love.graphics.newImage("assets/images/achievements/completed_act1.png")
ACH_IMG["complete_act2"] = love.graphics.newImage("assets/images/achievements/completed_act2.png")
ACH_IMG["complete_game"] = love.graphics.newImage("assets/images/achievements/completed_game.png")
ACH_IMG["completed_against"] = love.graphics.newImage("assets/images/achievements/completed_against.png")
ACH_IMG["completed_pro"] = love.graphics.newImage("assets/images/achievements/completed_pro.png")
ACH_IMG["jen_extra"] = love.graphics.newImage("assets/images/achievements/jen_extra.png")
ACH_IMG["liv_extra1"] = love.graphics.newImage("assets/images/achievements/liv_extra1.png")
ACH_IMG["liv_extra2"] = love.graphics.newImage("assets/images/achievements/liv_extra2.png")
ACH_IMG["party"] = love.graphics.newImage("assets/images/achievements/party.png")
ACH_IMG["bro"] = love.graphics.newImage("assets/images/achievements/bro.png")


-- Miscellaneous images
MISC_IMG = {}
MISC_IMG["reg_static"] = love.graphics.newImage("assets/images/static.png")
MISC_IMG["mild_static"] = love.graphics.newImage("assets/images/static_mild.png")
MISC_IMG["static"] = MISC_IMG["reg_static"]
MISC_IMG["star"] = love.graphics.newImage("assets/images/star.png")
MISC_IMG["arrow"] = love.graphics.newImage("assets/images/arrow.png")
MISC_IMG["logo"] = love.graphics.newImage("assets/images/logo.png")
MISC_IMG["cat"] = love.graphics.newImage("assets/images/grumpy_cat.png")
MISC_IMG["marvsoft"] = love.graphics.newImage("assets/images/Marvellous Soft.png")
MISC_IMG["lines"] = love.graphics.newImage("assets/images/settings.png")
MISC_IMG["ticks"] = love.graphics.newImage("assets/images/settings.png")
MISC_IMG["triangle"] = love.graphics.newImage("assets/images/triangle.png")
MISC_IMG["triangle_border"] = love.graphics.newImage("assets/images/triangle_border.png")
MISC_IMG["pixel"] = love.graphics.newImage("assets/images/pixel.png")


-- Miscellaneous settings
SETTINGS = {}
SETTINGS["static"] = "reg_static"

-- Bot images (assume array part only)
HAIR = {
    love.graphics.newImage("assets/images/hairs/01.png"),
    love.graphics.newImage("assets/images/hairs/02.png"),
    love.graphics.newImage("assets/images/hairs/03.png"),
    love.graphics.newImage("assets/images/hairs/04.png"),
    love.graphics.newImage("assets/images/hairs/05.png"),
}
HEAD = {
    love.graphics.newImage("assets/images/faces/01.png"),
}
BODY = {
    love.graphics.newImage("assets/images/bodies/01.png")
}


--Shaders

--Table containing smooth circle shaders created
SMOOTH_CIRCLE_TABLE = {}
--Table containing smooth ring shaders created
SMOOTH_RING_TABLE = {}

--Default Smooth Circle Shader
SMOOTH_CIRCLE_SHADER = ([[
  vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
    vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
    vec2 center = vec2(0.5,0.5);
    pixel.a = 1 - smoothstep(.5 - 1/%f, .5, distance(center, texture_coords));
    return pixel * color;
  }
]])

--Default Smooth Ring Shader
SMOOTH_RING_SHADER = ([[
  vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
    vec4 pixel = Texel(texture, texture_coords );//This is the current pixel color
    vec2 center = vec2(0.5,0.5);
    number size = %f;
    number inner_radius = %f;
    number x = distance(center, texture_coords);
    if (x >= inner_radius/size) {
      pixel.a = 1 - smoothstep(.5 - 1/size, .5, x);
    }
    else
    {
      pixel.a = smoothstep(inner_radius/size - 1/size, inner_radius/size, x);
    }

    return pixel * color;
  }
]])


--Set game's global variables, random seed, window configuration and anything else needed
function setup.config()
    --GAME ICON
    if not love.window.setIcon(ICON_IMG["96"]) then
        if not love.window.setIcon(ICON_IMG["64"]) then
            if not love.window.setIcon(ICON_IMG["48"]) then
                if not love.window.setIcon(ICON_IMG["32"]) then
                    if not love.window.setIcon(ICON_IMG["24"]) then
                        if not love.window.setIcon(ICON_IMG["16"]) then
                            print("Couldn't set any icon image")
                        end
                    end
                end
            end
        end
    end

    --CUSTOM PUZZLES FOLDER--
    if not love.filesystem.exists("custom") then
        if not love.filesystem.createDirectory("custom") then
            print("Couldn't create custom puzzles directory")
        else
            print("Created custom puzzles directory")
        end
    end

    --RANDOM SEED--
    love.math.setRandomSeed( os.time() )

    --GLOBAL VARIABLES--
    DEBUG = true --DEBUG mode status

    TOTAL_PUZZLES_N = 48 --Total number of puzzles so far

    TABS_LOCK = 0 -- If the tabs cant be clicked
    EVENTS_LOCK = 0 -- All events but popup mouse pressed are locked

    EMPLOYEE_NUMBER = love.math.random(200, 2000)

    UNREAD_EMAILS = 0 -- Number of unread emails

    --Achievements Stuff
    --First is title, then description, then incompleted image, then completed imaged
    ACHIEVEMENT_DATABASE = {
        {"Baby Robot Steps","Finish your first puzzle", ACH_IMG["incompleted"], ACH_IMG["first"], "ACH_FIRST_PUZZLE"},
        {"Party Boy","Attend Paul's houseparty", ACH_IMG["incompleted"], ACH_IMG["party"],"ACH_PARTY"},
        {"Home Decor","Complete puzzle 'Home Improvement'", ACH_IMG["incompleted"], ACH_IMG["blaze_it"], "ACH_HOME_IMPROV"},
        {"I Got You Bro","Complete puzzle 'Simple Sort'", ACH_IMG["incompleted"], ACH_IMG["bro"], "ACH_SIMPLE_SORT"},
        {"I, Dead Robot","Take an innocent robot's life away", ACH_IMG["incompleted"], ACH_IMG["kill1"], "ACH_ROBOT_1"},
        {"Spilling Oil","Kill 10 robots dead", ACH_IMG["incompleted"], ACH_IMG["kill10"], "ACH_ROBOT_10"},
        {"Mechanical Genocide","Brutally murder 100 robots", ACH_IMG["incompleted"], ACH_IMG["kill100"], "ACH_ROBOT_100"},
        {"One of a Kind","Receive a most peculiar robot", ACH_IMG["incompleted"], ACH_IMG["unique_robot"], "ACH_UNIQUE"},
        {"Golden Star","Complete the tutorial", ACH_IMG["incompleted"], ACH_IMG["complete_tut"], "ACH_COMPLETED_TUT"},
        {"Senior Employee","Complete act 1", ACH_IMG["incompleted"], ACH_IMG["complete_act1"], "ACH_COMPLETED_ACT1"},
        {"The Price of Progress","Complete act 2", ACH_IMG["incompleted"], ACH_IMG["complete_act2"], "ACH_COMPLETED_ACT2"},
        {"EOF","Complete the main game", ACH_IMG["incompleted"], ACH_IMG["complete_game"], "ACH_COMPLETED_GAME"},
        {"A New Dawn","Burn the evidence", ACH_IMG["incompleted"], ACH_IMG["completed_against"], "ACH_AGAINST"},
        {"Better Years to Come...","Send proof from the inside", ACH_IMG["incompleted"], ACH_IMG["completed_pro"], "ACH_PRO"},
        {"Master of Optimization","Complete challenge puzzle 'Division II'", ACH_IMG["incompleted"], ACH_IMG["jen_extra"], "ACH_DIV2"},
        {"Lord Commander of the Division's Watch","Complete challenge puzzle 'Small Division'", ACH_IMG["incompleted"], ACH_IMG["liv_extra1"], "ACH_SMALLDIV"},
        {"Sorting Doctor","Complete challenge puzzle 'Hardester Sort'", ACH_IMG["incompleted"], ACH_IMG["liv_extra2"], "ACH_HARDSORT"},
        {"Best Programmer in the World","Complete every puzzle in the game. Congratulations!", ACH_IMG["incompleted"], ACH_IMG["all_puzzles"], "ACH_COMPLETE_ALL"},

    }
    --Initialize achievements progress
    ACHIEVEMENT_PROGRESS = {}
    AchManager.reset()

    -- Current room
    ROOM = nil

    NAMES = {"Barry", "Larry", "Terry", "Mary", "Fieri", "Danny", "Kenny", "Benny", "Kelly",
             "Harry", "Carie", "Perry", "Sally", "Abby", "Genny", "Figgy", "Ginnie", "Jenny",
             "Nancy", "Manny", "Ellie", "Lenny", "Ziggy", "Tammy", "Kerry", "Gerry", "Bonnie",
             "Tony", "Jammy", "Fanny", "Yammy", "Jerry", "Omarry", "Ury", "Lilly", "Nelly",
             "Annie", "Groove", "Waluigi", "Setzer", "Neymarry", "Lana del Robot", "Taylor Swiftly"
            }
    --Traits table composed of tuples, where the first position is a trait, second a table containing specific dialog options for this trait and third table containing specific last words options for this trait.
    TRAITS = {
      {"has peculiar taste in pizza", {"Hawaiian pizza isn't so bad, you know?"}, {}},
      {"socially awkward", {}, {}},
      {"likes Phantom Menace", {"Jar Jar Binks is soooo underrated...", "Meesa think yousa no know how to solve thisa problem."}, {}},
      {"collects stamps", {"You know whats better than bacon? Freaking stamps man."}, {"I had almost completed my 1984 collection..."}},
      {"color blind", {"Hey, quick question. Is my hair green or red?"}, {}},
      {"puppy lover", {"Woof Woof Bark Bark :3"}, {}},
      {"arachnophobic", {"DUDE IS THAT A SPIDER IN THE CEILING?!"}, {}},
      {"lactose intolerant", {"Soy milk is the bomb.", "What's so great about cheese anyway?"}, {}},
      {"snorts when laughing", {}, {}},
      {"germophobe", {"Please don't make me touch anything dirty."}, {}},
      {"insomniac", {"Is there a \"sleep\" command?"}, {}},
      {"lives with mom", {"No, I don't live in a basement .-.", "My mom makes the best lasagnas"}, {}},
      {"has a cool car", {"I can give you a ride someday", "Hey have I told you about my sweet Sedan? 'ts preety cool"}, {"Take care of my car."}},
      {"listens to emo rock", {}, {}},
      {"addicted to caffeine", {"Coffee first. Talk later."}, {}},
      {"explorer at heart", {"Ooh, let's see what's at 15, 10!"}, {}},
      {"never tips", {"10% service it's just an absurd, don't you think?"}, {}},
      {"jerk", {"You're ugly.", "F%$# you."}, {"F%$# you."}},
      {"sympathetic", {"Don't stress man, take your time. :)", "These puzzles sure are tough huh?"}, {"It's ok, man. We had a good run..."}},
      {"funny", {"You know the worst part of being lonely here? I can't up my frisbee game."}, {}},
      {"cool", {"Take your time brother"}, {"Ain't no thing, brother. You did what you had to do."}},
      {"11 toes", {"Want to check out my feet?"}, {}},
      {"speaks in jive", {"Y'all cats better know what's up with this shit, aight?", "I'm thinkin' ya ain't got the chops for this, ya dig?"}, {"You done fucked me up, son!"}},
      {"logical", {"Don't stress. Stressing doesn't help you achieve your objective."}, {}},
      {"irrational", {}, {}},
      {"creepy", {"I can hear your breathing from here...:)", "You smell good today. Is that because of the new shampoo you bought yesterday?"}, {}},
      {"good cook", {}, {}},
      {"liked LOST's ending", {"Hurley was the best character in a TV show by far.", "IT WAS ALL CYCLIC.", "Man, don't believe the haters about LOST's ending.", "See you in another life, brotha."}, {}},
      {"bought an Ouya", {"Life is made of regrets..."}, {"I have only one regret in my short life! Buying an Ouya..."}},
      {"hates tennis", {"Federer is a fool and probably has stinky feet."}, {}},
      {"has heterochromia", {"My left eye is reddish. My right one is blueish. And no, I do not see purple."}, {}},
      {"artistic", {}, {}},
      {"smells", {}, {}},
      {"inconvenient", {"Hey, what are you doing there?", "Do you really need that command?", "Are you done yet?", "Are you done yet?"}, {}},
      {"hates sports", {"Did you see the game last night? I didn't."}, {}},
      {"soccer fan", {"Did you see that ludicrous display last night?"}, {"Red card? Seriously?"}},
      {"uses hashtags", {"#NailingIt", "#YouCanDoIt", "#NoFilter"}, {"#TimeToDie", "#ThisIsGonnaSuck"}},
      {"rad dance moves", {}, {}},
      {"types with just one finger", {"h... e... l... l... o"}, {}},
      {"has a russian accent", {}, {"Goodbye, tovarisch."}},
      {"eats M&Ms by color", {"Usually I start with the reds and follow the rainbow order."}, {}},
      {"obsessed with Michael Cera", {"Michael Cera is just the perfect actor.", "Have you watched Arrested Development?", "Have you watched Juno?", "Michael Cera's mustache is the symbol of masculinity.", "Have you watched Scott Pilgrim?", "Have you watched Superbad?", "The best thing about Michael Cera is he doesn't even need to act."}, {}},
      {"obsessed with Nicolas Cage", {"Nicolas Cage is just the perfect actor.", "Have you watched Face/Off?", "Have you watched Kick-Ass? Man that Nic Cage scene.", "Have you watched Bad Lieutenant?"}, {}},
      {"eats toothpaste", {"People think I'm a freak, but I have the cleanest teeth."}, {}},
      {"grammer nazi", {"Actually, it's 'grammar nazi'."}, {}},
      {"collects purple kilts", {}, {}},
      {"very rosy cheeks", {}, {}},
      {"eats fingernails", {}, {}},
      {"hears voices", {"DON'T TELL ME WHAT TO DO", "Of course not.", "Hahaha, no. That would be silly", "What?", "Why?", "Okay okay! I'll do it! Just shut up!"}, {"They warned me! They warned me not to trust you!"}},
      {"terribly shy", {"...", "please... don't...", "*looks away*"}, {"...oh no..."}},
      {"blinks furiously when lying", {}, {}},
      {"memorized Moby Dick", {"I try all things, I achieve what I can."}, {}},
      {"lost an eye in a bear accident", {"An eye for an eye... That bear sure showed me."}, {}},
      {"hates bears", {"Goddamn bears stealing our honeykeeping jobs!"}, {}},
      {"never finished a game without a walkthrough", {"You should look for the solution to this puzzle on the internet!", "This one sure is tough... let's check google ;)"}, {"Should've used a walkthrough..."}},
      {"overachiever", {"I've solved a similar puzzle when I was five."}, {}},
      {"underachiever", {"I don't think I could ever solve this one =("}, {"Don't worry, I could've never solved that one..."}},
      {"always drunk", {"Jsut one moer drink..."}, {}},
      {"addicted to HIMYM", {"This puzzle is LEGEN --wait for it-- DARY!! hahaha"}, {}},
      {"vegan without the powers", {}, {"Wait... Chicken isn't vegan?"}},
      {"has to touch everything", {}, {}},
      {"has OCD", {}, {}},
      {"class clown", {}, {}},
      {"in a relationship with a pet rock", {}, {}},
      {"literally allergic to bad jokes", {}, {}},
      {"terrified of babies", {"My nephew was just born. I'll miss my sister."}, {}},
      {"picks scabs", {}, {}},
      {"pretends is a mime at parties", {"*Is trapped inside an invisible box*", "*Checks imaginary instructions*"}, {}},
      {"proud believer of crab people", {}, {}},
      {"reads minds", {"This puzzle is not a pain in the ass. Stop thinking that."}, {"It's ok. I forgive you."}},
      {"can play the theremin", {}, {}},
      {"can recite the alphabet backwards perfectly", {"This puzzle is easy as ZYX :)"}, {}},
      {"loves costume parties", {}, {}},
      {"can correctly give current latitude and longitude at all times", {}, {}},
      {"accidently makes sexual innuendos", {"This is too hard and long! I can't take it anymore. Just finish already!"}, {}},
      {"has a catchphrase", {"Wubba lubba dub dub", "Wubba lubba dub dub", "Wubba lubba dub dub", "AIDS!",  "Ands that's the wayyyyy the news goes!", "GRASSSS... tastes bad!", "Lick, lick, lick my BALLS!"}, {}},
      {"has an unhealthy obession with Kermit the Frog", {"...did you see Muppets from Space?"}, {}},
      {"can't ride a bike", {}, {}},
      {"is always seen wearing pajamas", {}, {}},
      {"afraid of the internet", {"They say you can catch a virus in this Internet!"}, {"I told you to disconnect!"}},
      {"is agressively against socks", {}, {}},
      {"speaks in a monotone voice", {}, {}},
      {"born in a leap year", {"I'm turning 6 today. :P"}, {}},
      {"slow walker", {}, {}},
      {"never showers", {"I prefer to think I'm SAVING our precious planet's resource"}, {}},
      {"sweats profusely", {"Oh man, did someone up the heat? I'm feeling like a pig down here."}, {}},
      {"chews ice cubes for dinner", {}, {}},
      {"heavy sleeper", {}, {"zzzzZZZZZzzz"}},
      {"fear of closed doors", {"I don't care about lava or buckets, just don't leave any door closed okay?", "Lets leave all door open, please."}, {}},
      {"stores their urine in a jar", {"Everyone has a hobby :)", "Are you on fire? I can help."}, {}},
      {"kleptomaniac", {"Can I borrow your computer when I leave this place?"}, {}},
      {"only watches SpongeBob reruns", {"How about that one where Squidward accidentally freezes himself for 2,000 years huh? Classic!","Have you seen the one where Patrick helps SpongeBob on his driving test? Oh man I love that one!"}, {}},
      {"constantly makes animal noises", {"Moo", "Oink Oink","Baaaaaaah", "Meeeoow ;3", "Gobble gobble gobble"}, {}},
      {"afraid of feet", {"Don't look down, don't look down..."}, {}},
      {"has a foot fetish", {"Could you describe your feet for me? ;)"}, {}},
      {"TYPES IN ALL CAPS", {"HEY MAN U DOING ALRIGHT THERE?"}, {"I'M GOING TO DIE!!!"}},
      {"know it all", {"Did you know a crocodile can't poke its tongue out?"}, {}},
      {"has bad acne", {"Please don't look at my face, I'm very insecure about it..."}, {}},
      {"conspiracy theorist", {"9/11 was an inside job.", "Illuminati are behind it all.", "Vaccination is a lie created by the media.", "We're all being mind-controlled!"}, {"Oh no, they came after me!"}},
      {"nihilist", {"This puzzle doesn't matter. Nothing does."}, {"Death is meaningless."}},
      {"ArchLinux user", {"Did I tell you I run ArchLinux?", "Yesterday I managed to connect to a Wi-Fi network. I know, super hard."}, {"Looks like this version of \"life\" wasn't compatible with this package..."}},
      {"plays Dwarf Fortress", {}, {"Death is all around us, begone fear!", "Losing is fun!", "Losing isn't fun after all..."}},
      {"Apple fanboy", {"The new iPhone isn't really that expensive... I'll just take a second mortgage..."}, {}},
      {"Elvis impersonator", {"Yeah baby yeah...", "I guess this \"robot\" microchip is... Always on my mind, baby."}, {}},
      {"has the Disco Fever", {"The boogie's gonna start to explode any time now, baby...", "I'm gettin' loose y'all!", "Gotta fight with expert timing, baby!", "Gotta feel the city breakin' and everybody shakin'!", "I'm stayin' alive!", "Baby, that's the way, uh-huh uh-huh, I like it!", "Let's get the boogie started!", "Let's do the Freak! I've heard it's quite chic!", "Do you remember the 21st of September?", "Baby, give it up! Give it up, baby give it up!"}, {}},
      {"1/128 irish", {"I can't wait for St. Pattys day!"}, {}},
      {"german", {"Das ist nicht effizient. You should optimize your code."}, {}},
      {"spanish", {"Oye chico! When I can do the siesta, eh?"}, {"Dios mio!!"}},
      {"hypochondriac", {"Oh man, I'm not feeling really well...", "Was this bruise here before?! Shit! It could be rhabdomyolysis!", "Feeling a little dizzy..."}, {"I literally feel like I'm dying, man!"}},
      {"game developer", {"Art of Game Design is the best book ever written!", "Let's make a Game Design Document to solve this!"}, {"I'm fairly sure that part was a bug."}},
      {"never-nude", {"There are dozens of us!"}, {}},
      {"magician", {"It's not a trick. It's an ILLUSION.", "You like magic? SAME", "But where did the lighter fluid come from?"}, {"Want to see a cool trick?"}},
      {"ambidextrous", {"Can you type with both hands? I can :)"}, {}},
      {"left-handed", {}, {}},
      {"procrastinator", {"Why don't you solve another puzzle?", "You should watch some TV first... Just to unwind."}, {}},
      {"national spelling bee winner", {"You are D-E-F-I-N-I-T-E-L-Y solving this task."}, {"D-E-A-D"}},
      {"frugal", {}, {}},
      {"freakishly tall", {"No, the weather up here is not any different."}, {}},
      {"went to Burning Man", {"Have I told you how awesome it was at Burning Man?!", "I'm telling you, Burning Man is eye-opening!"}, {}},
      {"gambling addict", {"I bet 5$ you can't finish this task in under 5 minutes."}, {"I bet this will hurt a lot."}},
      {"diabetic", {}, {}},
      {"only drinks soda", {"Juice is for vegans man. Soda, that's where it's at."}, {}},
      {"only listens to Insane Clown Posse", {}, {}},
      {"thinks it's a pirate", {"Yaaaaaaaarrrrr"}, {"Arr, my scallywag, ya done kill me for good!"}},
      {"game of thrones fanboy", {"KHALEESI", "WHERE ARE MY DRAGONS?", "Winter is coming!!", "The red wedding was rad, right?"}, {"You know nothing."}},
      {"believes in pc master race", {"Can you run 16K 180 FPS in your console?"}, {"Should have upgraded my CPU..."}},
      {"likes new technologies", {"Have you bought bitcoin yet?", "VR is the future!", "Augmented Reality is here to stay."}, {"Am I obsolete already?"}},
      {"watches youtube hits", {"OPPA GANGNAM STYLE", "TURN DOWN FOR WHAT?", "DO THE HARLEM SHAKE"}, {}},
      {"meme guy", {"*trollface*", "Forever Alone."}, {}},
      {"Lana Del Rey fan", {"You want to be my sugar daddy?", "*smokes*"}, {}},
      {"likes small talk", {"What a weather, huh?", "How are the kids?"}, {}},
      {"plays Melee", {"Mang0nation", "Fox McCloud", "Wombooo Combooo! Where you at??", "Is there a \"wavedash\" command?"}, {"Damn, missed an l-cancel..."}},
    }

    --Regular dialogs any robot can say
    REGULAR_DIALOGS = {
      "This one seems pretty straight forward.",
      "Hey how are things going?",
      "Nice day right? I mean, I'm really asking, can't see a thing from here.",
      "Taking your time huh?",
      "Please move this along.",
      "Can you go a little faster there mate?",
      "All I wanted was a hug...",
      "Try not to kill me please.",
      "This looks more challenging that I thought.",
      "Can you finish this one before I fall asleep?",
      "How long have you been on this task?",
      "Any progress?",
      "HA! I figured it out!\n\n...but I'm not telling you.",
      "I don't like where this is going.",
      "Please debug your code before running it with me.",
      "...",
      "It's a bit chill here.",
      "My legs are sore, try not to make me walk much.",
      "*yawns*",
      "ATCHOO",
      "What are you doing?",
      "This is hopeless. Just try another task.",
      "Is there a \"dance\" command?",
      "Is there a \"barrelroll\" command?",
      "Can you make me somersault?",
      "What can I do for you?",
      "Where's the afterparty at?",
      "Let me know if you need anything.",
      "All my hopes lie with you.",
      "I trust you.",
      "Are you stuck?",
      "I'm hungry.",
      "I'm tired.",
      "Staying still is a bit boring.",
      "Don't let me down.",
      "Is this hard?",
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
      "Yo",
      "Hey man.",
      "Hello.",
      "You can call me {bot_name}.",
      "Hey I'm {bot_name}. Let's solve this.",
      "Let's hope I don't end the same way as the other robots, ok?",
      "My name is {bot_name} and we are now best friends!",
      "Is this freedom?!!...oh, it's just another puzzle :(",
    }

    --FAILED POPUP MESSAGES TABLES
    FAILED_POPUP_MESSAGES = {
      code_over =
      {
        title = "Code not successful",
        sentences =
        {
            "Your code finished but the objectives weren't completed. Your robot had to be sacrificed as punishment for your inefficiency.",
            "Your code reached the ending but you did not fully meet the objectives. So we exploded your bot. Do not repeat this mistake."
        }
      },
      paint_container =
      {
        title = "Bot drowned in paint!",
        sentences =
        {
            "You somehow let your bot fall into a paint container. That's embarassing.",
            "It seems you let your bot fall into a paint container... Did you do that on purpose?",
            "Your robot sunk into a beautiful rainbow.",
        }
      },
      lava =
      {
        title = "Bot burn in lava!",
        sentences =
        {
            "You let your bot burn in hot lava. That's innapropriate.",
            "Your bot scorched to death.",
            "Your robot fell in a lava pit. I don't think it's coming back.",
            "Your robot got head first in a lava pit.",
        }
      },
      laser =
      {
        title = "Bot destroyed by laser!",
        sentences =
        {
            "Your bot got in a direct conflict with a laser ray. The laser won.",
            "Your robot was obliterated by a laser.",
            "Your robot was sliced in half by a laser."
        }
      },
    }
    --Table of different apologise texts it can appear on failed popups
    FAILED_POPUP_BUTTON_TEXT =
    {
      " I'm sorry ",
      " It won't happen again ",
      " It won't happen again. Probably ",
      " This will be my last mistake ",
      " I will be more careful next time ",
      " Frankly it was his fault ",
      " Better him than me ",
      " I will miss him ",
      " He was my favorite... ",
      " Good riddance ",
      " Hit me another one ",
      " I think it was malfunctioning ",
      " It won't happen again ",
      " Ooops ",
      " I will be more successful next time ",
    }

    REGULAR_DYING_MESSAGES =
    {
      "AAAAAaaaaAAAaaaAAAaaaAAaAAAaAAaAAAaaAAAAAaaaaAAAAaaaaAAAaaaAAaAAAaaA",
      "Hey did you know today is my birthd-",
      "Something tells me this is going to hurt.",
      "Argh!",
      "I'm disappointed in you",
      "Don't worry, I'm ready to die. Goodbye master.",
      "I had a good run.",
      "I guess this is it...",
      "I will haunt your soul.",
      "Wait, is that... Oh shit!",
      "Oh no, shit! Argh!",
      "WHAT THE FUCK?!",
      "#YOLO"
    }

    --INITIALIZING TABLES--

    --Drawing Tables
    DRAW_TABLE = {
        BG   = {}, --Background (bottom layer, first to draw)
        L1   = {}, --Layer 1
        L1u  = {}, --Layer 1 upper
        L2   = {}, --Layer 2
        L2u  = {}, --Layer 2 upper
        GUI  = {}, --Graphic User Interface (top layer, last to draw)
    }

    --WINDOW CONFIG--
    love.window.setMode(W, H, {resizable = true, minwidth = 800, minheight = 600})
    ResManager.init()
    ResManager.adjustWindow(W, H)

    --CAMERA--
    CAM = Camera(W/2, H/2) --Set camera position to center of screen

    --SHADERS--

    --AUDIO--
    SOUND_EFFECT_MOD = 1 -- Current effects volume
    SFX = {}
    SFX.loud_static = SoundEffect("assets/sound/pink_noise.wav", "static", 1, true)
    SFX.tab_switch = SoundEffect("assets/sound/tab_switch.ogg", "static")
    SFX.new_email = SoundEffect("assets/sound/new_email.wav", "static", .5)
    SFX.buzz = SoundEffect("assets/sound/buzz.ogg", "static")
    SFX.fail = SoundEffect("assets/sound/fail.mp3", "static")
    SFX.click = SoundEffect("assets/sound/click.wav", "static")
    SFX.side_message = SoundEffect("assets/sound/side_message_blip.wav", "static")
    SFX.login = SoundEffect("assets/sound/login.wav", "static")
    SFX.open_email = SoundEffect("assets/sound/open_email.wav", "static")
    SFX.close_email = SoundEffect("assets/sound/close_email.wav", "static")
    SFX.win_puzzle = SoundEffect("assets/sound/win_puzzle.wav", "static")

    MUSIC_MOD = 1 -- Current BGM volume
    MUSIC = {}
    MUSIC.menu = {path = "assets/sound/bgms/tumult.mp3"}
    MUSIC.tut_1 = {path = "assets/sound/bgms/he_missed_loop.mp3"}
    MUSIC.tut_2 = {path = "assets/sound/bgms/easy_life_loop.mp3"}
    MUSIC.act1_1 = {path = "assets/sound/bgms/what_have_you_done_loop.mp3"}
    MUSIC.act2_1 = {path = "assets/sound/bgms/tiger_blue_sky_loop.mp3"}
    MUSIC.act2_2 = {path = "assets/sound/bgms/wasnt_what_i_expected_loop.mp3"}
    MUSIC.act2_3 = {path = "assets/sound/bgms/i_wanted_to_live_loop.mp3"}
    MUSIC.act3_1 = {path = "assets/sound/bgms/i_thought_of_pills_loop.mp3"}
    MUSIC.act3_2 = {path = "assets/sound/bgms/just_blue_sky_loop.mp3"}
    MUSIC.act3_3 = {path = "assets/sound/bgms/completely_lost_loop.mp3"}
    MUSIC.final_puzzle = {path = "assets/sound/bgms/a_role_in_life_loop.mp3"}
    local music_vol_reg = .5
    for _, m in pairs(MUSIC) do
        m.base_volume = music_vol_reg
    end
end

--Return functions
return setup
