
MusicTime = 0
function updateMusicTimeFunction()
    if updateMusicTime then
        MusicTime = MusicTime + (love.timer.getTime() * 1000) - (previousFrameTime or (love.timer.getTime()*1000))
        previousFrameTime = love.timer.getTime() * 1000
    end
end