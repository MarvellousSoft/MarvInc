--[[
#####################################
Marvellous Inc.
Copyright (C) 2017  MarvellousSoft & USPGameDev
See full license in file LICENSE.txt
(https://github.com/MarvellousSoft/MarvInc/blob/dev/LICENSE.txt)
#####################################
]]--

--Local functions

local function GetNextBGM(previous)
    local possible_bgms = {}
    if ROOM.version == "0.1" then
        table.insert(possible_bgms, MUSIC.tut_1)
        table.insert(possible_bgms, MUSIC.tut_2)
    elseif ROOM.version == "1.0" then
        table.insert(possible_bgms, MUSIC.act1_1)
    elseif ROOM.version == "2.0" then
        table.insert(possible_bgms, MUSIC.act2_1)
        table.insert(possible_bgms, MUSIC.act2_2)
        table.insert(possible_bgms, MUSIC.act2_3)
    elseif ROOM.version == "3.0" then
        table.insert(possible_bgms, MUSIC.act3_1)
        table.insert(possible_bgms, MUSIC.act3_2)
        table.insert(possible_bgms, MUSIC.act3_3)
    end

    if ROOM.puzzle_id == "ryr" and ROOM:connected() then
        possible_bgms = {}
        table.insert(possible_bgms, MUSIC.final_puzzle)
    end

    --Get a different bgm, if possible
    local bgm
    if #possible_bgms > 1 then
        repeat
            bgm = Util.randomElement(possible_bgms)
        until not previous or bgm.path ~= previous.path
    else
        bgm = Util.randomElement(possible_bgms)
    end

    return Music(bgm.path, "stream", bgm.base_volume)
end

Audio = Class {
}

function Audio:init(file, mode, base_volume, loop)
    self.source = love.audio.newSource(file, mode)
    if loop then
        self.source:setLooping(true)
    end
    self.base_volume = base_volume or 1
end

function Audio:stop()
    self.source:stop()
end


SoundEffect = Class {
    __includes = {Audio}
}

function SoundEffect:play(mod)
    mod = mod or 1
    self.source:setVolume(self.base_volume * SOUND_EFFECT_MOD * mod)
    self.source:play()
end

Music = Class {
    __includes = {Audio}
}

function Music:init(file, mode, base_volume)
    Audio.init(self, file, mode, base_volume, true)

    self.path = file
end

function Music:updateVolume()
    self.source:setVolume(self.base_volume * MUSIC_MOD)
end

function Music:play()
    self.source:setVolume(self.base_volume * MUSIC_MOD)
    self.source:play()
end

function Music:fadein(duration)
    duration = duration or 4

    self.source:setVolume(0)
    self.source:play()

    --Create fadein effect
    local delay = 0.1
    AUDIO_TIMER:every(delay,
        function()
            local rate = (self.base_volume * MUSIC_MOD)/(duration/delay)
            self.source:setVolume((self.source:getVolume() + rate))
        end,
    duration/delay)
    AUDIO_TIMER:after(duration,
        function()
            self.source:setVolume(self.base_volume * MUSIC_MOD)
        end)
end

function Music:fadeout(duration)
    duration = duration or 2

    self.source:setVolume(self.base_volume * MUSIC_MOD)

    --Create fadeout effect
    local delay = 0.1
    local rate = self.base_volume/(duration/delay)
    AUDIO_TIMER:every(delay,
        function()
            self.source:setVolume((self.source:getVolume() - rate) * MUSIC_MOD)
        end,
    duration/delay)
    --Stop source after fadeout
    AUDIO_TIMER:after(duration, function() self.source:stop() end)
end

BGMManager = Class {

}

function BGMManager:init()
    self.bgm_duration_base = 180
    self.timer = 0
end

function BGMManager:newBGM(optional_bgm)
    self.bgm_duration = self.bgm_duration_base + love.math.random(-20, 20)

    if self.current_bgm then
        self.current_bgm:fadeout()
    end
    if optional_bgm then
        self.current_bgm = Music(optional_bgm.path, "stream", optional_bgm.base_volume)
    else
        self.current_bgm = GetNextBGM(self.current_bgm)
    end

    self.current_bgm:fadein()
end

function BGMManager:stopBGM()
    if self.current_bgm then
        self.current_bgm.source:stop()
    end
end

function BGMManager:update(dt)
    self.timer = self.timer + dt
    if self.timer >= self.bgm_duration then
        self.timer = self.timer - self.bgm_duration
        self:newBGM()
    end
end

function BGMManager:updateVolume()
    self.current_bgm:updateVolume()
end
