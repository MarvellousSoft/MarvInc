--HUMP STUFF
Gamestate = require "hump.gamestate"
Timer     = require "hump.timer"
Class     = require "hump.class"
Camera    = require "hump.camera"
Vector    = require "hump.vector"


--CLASSES

require "classes.primitive"
require "classes.color.rgb"
require "classes.color.hsl"
require "classes.color.color"


--MY MODULES
local Util      = require "util"
local Draw      = require "draw"
local Setup     = require "setup"


--GAMESTATES
GS = {
--MENU     = require "gamestate.menu",     --Menu Gamestate
GAME     = require "gamestates.game",     --Game Gamestate
--PAUSE    = require "gamestate.pause",    --Pause Gamestate
--GAMEOVER = require "gamestate.gameover"  --Gameover Gamestate
}

function love.load()

    Setup.config() --Configure your game

    Gamestate.registerEvents() --Overwrites love callbacks to call Gamestate as well
    Gamestate.switch(GS.GAME) --Jump to the inicial state

end

-----------------
--MOUSE FUNCTIONS
-----------------

function love.mousepressed(x, y, button, istouch)

    --[[
    if button == 1 then  --Left mouse button
        Button.checkCollision(x,y)
    end
    ]]

end
