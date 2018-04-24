--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

local state = {}

local imgs = {}
local n
local w, h

local paper = {}
local p_y = 0
local firesound
local timer

function state:enter(prev)
    GS['GAME'].getBGMManager():stopBGM()
    timer = Timer.new()
    n = 5
    for i = 1, n do
        imgs[i] = love.graphics.newImage('assets/images/fire' .. i .. '.png')
    end
    w, h = imgs[1]:getWidth(), imgs[1]:getHeight()
    for i = 1, 5 do
        paper[i] = love.graphics.newImage('assets/images/paper_burn' .. i .. '.png')
    end
    firesound = love.audio.newSource('assets/sound/fire.ogg', 'stream')
    firesound:setLooping(true)
    firesound:play()
    self.sound_vol = SOUND_EFFECT_MOD
    timer:after(7.5, function() timer:tween(1, self, {sound_vol = 0}) end)
    timer:after(8.5, Gamestate.pop)
end

local cur = 0
local step = .15
local i, j = 1, 1
local p_ct = 0
local cur_a = 255
local s_y = 200

local time = 0
local bg_a = 0
function state:update(dt)
    timer:update(dt)
    AUDIO_TIMER:update(dt)
    firesound:setVolume(self.sound_vol)
    cur = cur + dt
    if cur > step then
        cur = 0
        local oi = i
        i = math.floor(love.math.random() * (n - 1)) + 1
        if i >= oi then i = i + 1 end
    end
    p_ct = p_ct + dt
    cur_a = cur_a - dt * 105
    if cur_a < 0 then cur_a = 0 end
    if p_ct > .3 and j < 5 then
        p_ct = 0
        j = j + 1
    end
    s_y = s_y + 150 * dt
    if p_y < H * .5 then
        p_y = p_y + s_y * dt
    end
    time = time + dt
    if time > 4 then
        bg_a = bg_a + (255 / 3) * dt
        if bg_a > 255 then bg_a = 255 end
    end
end

local white = Color.white()
local black = Color.black()
function state:draw()
    white.a = 255
    Color.set(white)
    local sx, sy = W / w, H / h
    love.graphics.draw(imgs[i], 0, 0, 0, sx, sy)

    if j < 5 then
        white.a = cur_a * (1 - p_ct / .3)
        Color.set(white)
        love.graphics.draw(paper[j], W / 5, p_y, 0, sx / 2, sy / 2)
        white.a = cur_a * (p_ct / .3)
        Color.set(white)
        love.graphics.draw(paper[j + 1], W / 5, p_y, 0, sx / 2, sy / 2)
    else
        white.a = cur_a
        Color.set(white)
        love.graphics.draw(paper[j], W / 5, p_y, 0, sx / 2, sy / 2)
    end
    black.a = bg_a
    Color.set(black)
    love.graphics.rectangle('fill', 0, 0, W, H)
end

function state:leave()
    firesound:stop()
    Gamestate.push(GS.NEWS, 'pro', 4)
end

return state
