local BPMTimer = 0
local beatInterval = 0


function calculateBeatLength(bpm)
    print("Calculate Beat Length " .. bpm)
    beatInterval = 60000/bpm
    onBeat = false
end

function updateBPM()
    local previousFrameTime
    BPMTimer = BPMTimer + (love.timer.getTime() * 1000) - (previousFrameTime or (love.timer.getTime()*1000))
    previousFrameTime = love.timer.getTime() * 1000

    if BPMTimer > beatInterval then 
        beat()
        frame = 1 
    end


    if frame == 2 and onBeat then onBeat = false end

  --  print(tostring(onBeat))
end

function beat()
    onBeat = true
end