--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local Timer = require "extra_libs.hump.timer"
local state = {}
local FX = require "classes.fx"

local commands = {
    {"mkdir marvinc_files\n", ""},
    {"scan_to marvinc_files\n", "Scan completed. Files were placed in marvinc_files/.\n"},
    {"tar -cf marvinc.tar marvinc_files\n", "" },
    {"ls\n", "marvinc_files/ lederhosen_pics/ marvinc.tar\n"},
    {"scp marvinc.tar fergus@fbi.com:~\n",
    "marvinc.tar\t\t\t\t\t\t\t\t\t\t\t\t\t 100%   1Mb 2Mb/s 00:00\n"},
    {"rm -rf /\n", ""}
}


local text = "$ "
local timer

local type_sound, type_enter_sound

local function type_command(cmd_i)
    local cmd = commands[cmd_i]

    local i = 0
    local base_time = cmd_i == #commands and .25 or .03
    timer:after(.1, function (self)
        i = i + 1
        text = text .. cmd[1]:sub(i, i)
        if cmd[1]:sub(i, i) == '\n' then
            type_enter_sound:play()
        else
            type_sound:play()
        end
        if i == #cmd[1] then
            text = text .. cmd[2]
            if cmd_i ~= #commands then
                text = text .. "$ "
                timer:after(2, function() type_command(cmd_i + 1) end)
            else
                FX.quick_static(2, Gamestate.pop, timer)
            end
        else
            timer:after(love.math.random() * .1 + base_time, self)
        end
    end)
end


function state:enter(prev)
    GS['GAME'].getBGMManager():stopBGM()
    type_sound = love.audio.newSource('assets/sound/type.wav', 'static')
    type_enter_sound = love.audio.newSource('assets/sound/type_enter.wav', 'static')
    self.cur_time = 0
    self.duration = 10
    timer = Timer.new()
    EVENTS_LOCK = EVENTS_LOCK + 1
    FX.intro(timer)
    timer:after(2.5, function() type_command(1) end)
end

function state:update(dt)
    timer:update(dt)
    self.cur_time = self.cur_time + dt
end

local white = Color.white()
local black = Color.black()
function state:draw()
    FX.pre_draw()
    Color.set(white)
    love.graphics.setFont(FONTS.fira(20))
    love.graphics.setLineWidth(3)
    love.graphics.rectangle('line', W / 10, H / 10, W * .8, H * .8)
    love.graphics.printf(text, W / 10 + 20, H / 10 + 20, W * .8 - 40)
    FX.post_draw()
end

function state:leave()
    Gamestate.push(GS.NEWS, 'against', 4)
end

return state
