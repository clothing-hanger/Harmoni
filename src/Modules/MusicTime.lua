musicTime = 0

function updatemusicTimeFunction()
    if updatemusicTime then        -- TEMPORARY FIX FOR SONGS NOT RESETTING
        musicTime = musicTime + (love.timer.getTime() * 1000) - (previousFrameTime or (love.timer.getTime()*1000))
        previousFrameTime = love.timer.getTime() * 1000
    end
end