local MusicTimeManager = {}

function MusicTimeManager.updateMusicTime(musicTime, dt)
    return musicTime + dt * 1000
end

function MusicTimeManager.needsResync(song)
    if song and song:isPlaying() then
        local audioTime = song:tell() * 1000
        if math.abs(audioTime - MusicTime) > 20 then -- ~20ms
            return true
        end
    end
    return false
end

function MusicTimeManager.resyncMusicTime(song)
    if song then
        local audioTime = song:tell() * 1000
        MusicTime = audioTime
    end
    return MusicTime
end

return MusicTimeManager