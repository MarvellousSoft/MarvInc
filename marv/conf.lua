--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

--MODULE FOR CONFIGURING STUFF--

function love.conf(t)
    t.identity = "marvellous"           -- The name of the save directory (string)
    t.version = "0.10.2"                -- The LÖVE version this game was made for (string)
    t.console = false                   -- Attach a console (boolean, Windows only)
    t.accelerometerjoystick = false     -- Enable the accelerometer on iOS and Android by exposing it as a Joystick (boolean)
    t.externalstorage = false           -- True to save files (and read from the save directory) in external storage on Android (boolean)
    t.gammacorrect = false              -- Enable gamma-correct rendering, when supported by the system (boolean)

    t.window.title = "Marvellous Inc."     -- The window title (string)

    t.window.icon = 'assets/images/amoeba.png' -- Filepath to an image to use as the window's icon (string)
    t.window.width = 1366                  -- The window width (number)
    t.window.height = 768                  -- The window height (number)
    t.window.borderless = false            -- Remove all border visuals from the window (boolean)
    t.window.resizable = false             -- Let the window be user-resizable (boolean)
    t.window.minwidth = 1                  -- Minimum window width if the window is resizable (number)
    t.window.minheight = 1                 -- Minimum window height if the window is resizable (number)
    t.window.fullscreen = false            -- Enable fullscreen (boolean)
    t.window.fullscreentype = "desktop"    -- Choose between "desktop" fullscreen or "exclusive" fullscreen mode (string)
    t.window.vsync = true                  -- Enable vertical sync (boolean)
    t.window.msaa = 0                      -- The number of samples to use with multi-sampled antialiasing (number)
    t.window.display = 1                   -- Index of the monitor to show the window in (number)
    t.window.highdpi = false               -- Enable high-dpi mode for the window on a Retina display (boolean)
    t.window.x = nil                       -- The x-coordinate of the window's position in the specified display (number)
    t.window.y = nil                       -- The y-coordinate of the window's position in the specified display (number)

    t.modules.audio = true              -- Enable the audio module (boolean)
    t.modules.event = true              -- Enable the event module (boolean)
    t.modules.graphics = true           -- Enable the graphics module (boolean)
    t.modules.image = true              -- Enable the image module (boolean)
    t.modules.joystick = true           -- Enable the joystick module (boolean)
    t.modules.keyboard = true           -- Enable the keyboard module (boolean)
    t.modules.math = true               -- Enable the math module (boolean)
    t.modules.mouse = true              -- Enable the mouse module (boolean)
    t.modules.physics = true            -- Enable the physics module (boolean)
    t.modules.sound = true              -- Enable the sound module (boolean)
    t.modules.system = true             -- Enable the system module (boolean)
    t.modules.timer = true              -- Enable the timer module (boolean), Disabling it will result 0 delta time in love.update
    t.modules.touch = true              -- Enable the touch module (boolean)
    t.modules.video = true              -- Enable the video module (boolean)
    t.modules.window = true             -- Enable the window module (boolean)
    t.modules.thread = true             -- Enable the thread module (boolean)

    -- Stuff for love-release
    t.releases = {
        title = "Marvellous_Inc",                          -- The project title (string)
        package = "marvellous",                             -- The project command and package name (string)
        loveVersion = t.version,                            -- The project LÖVE version
        version = "1.3.4",                                  -- The project version
        author = "Marvellous Soft",                         -- Your name (string)
        email = "marvellous.amoeba@gmail.com",              -- Your email (string)
        description = "Zachlike with an immersive storyline told through emails.", -- The project description (string)
        homepage = "https://github.com/MarvellousSoft/MarvInc", -- The project homepage (string)
        excludeFilelist = {''},
        compile = false,                                     -- compile with LuaJIT
        identifier = 'public.executable',                    -- The project Uniform Type Identifier (string)
        releaseDirectory = "../build",                      -- Where to store the project releases (string)
    }
end
