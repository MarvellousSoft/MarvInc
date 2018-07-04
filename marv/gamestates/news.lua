--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local state = {}

local time = 12
local intro_time
local cur = 1
local tot
local news = {}
function state:enter(prev, typ, n, _intro_time)
    if typ == "pro" then
        GS['GAME'].getBGMManager():newBGM(MUSIC.act3_3)
    else
        GS['GAME'].getBGMManager():newBGM(MUSIC.act1_1)
    end
    intro_time = _intro_time or 2
    tot = n
    for i = 1, n do
        news[i] = {
            img = love.graphics.newImage('assets/images/newspaper_' .. typ .. i .. '.png'),
            r = love.math.random() * .55 - .275,
            x = W / 2,
            y = H / 2
        }
    end
end

local function rnd()
    local v = love.math.random() * 100 + 200
    if love.math.random() < .5 then v = -v end
    return v
end

local fade_in = 255
local on_leave = false
local times = {0, 8, 16, 16}
local sx, sy = 0, 0
function state:update(dt)
    AUDIO_TIMER:update(dt)
    if intro_time > 0 then
        intro_time = intro_time - dt
        return
    end
    if fade_in > 0 then
        fade_in = fade_in - dt * 50
    end
    if not on_leave then
        time = time - dt
        if time <= 0 then
            on_leave = true
            time = 4
            sx, sy = rnd(), rnd()
        end
    else
        time = time - dt
        news[cur].x = news[cur].x + sx * dt
        news[cur].y = news[cur].y + sy * dt
        if time <= 0 then
            if cur < tot then
                on_leave = false
                cur = cur + 1
                time = times[cur]
            else
                Gamestate.pop()
            end
        end
    end

end

local white = Color.white()
local black = Color.black()
function state:draw()
    Color.set(white)
    for i = tot, cur, -1 do
        local n = news[i]
        local w = n.img:getWidth()
        local h = n.img:getHeight()
        love.graphics.draw(n.img, n.x, n.y, n.r, nil, nil, w / 2, h / 2)
    end
    black.a = fade_in
    Color.set(black)
    love.graphics.rectangle('fill', 0, 0, W, H)
end

function state:mousepressed(x, y, button, isTouch)
    if not on_leave then
        on_leave = true
        time = 4
        sx, sy = rnd(), rnd()
    end
end

function state:leave()
    Gamestate.push(GS.CREDITS)
end

return state
