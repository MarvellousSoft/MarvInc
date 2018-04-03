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

function SoundEffect:play()
    self.source:setVolume(self.base_volume * SOUND_EFFECT_MOD)
    self.source:play()
end

Music = Class {
    __includes = {Audio}
}

function Music:updateVolume()
    self.source:setVolume(self.base_volume * MUSIC_MOD)
end

function Music:play()
    self.source:setVolume(self.base_volume * MUSIC_MOD)
    self.source:play()
end
