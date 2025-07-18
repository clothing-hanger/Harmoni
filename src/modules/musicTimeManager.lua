local MusicTimeManager = {}

function MusicTimeManager.updateMusicTime(musicTime, dt)
    return musicTime + 1000 * dt
end

return MusicTimeManager