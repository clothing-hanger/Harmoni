local BPMTimer = 0
local beatInterval = 0
local frame = 1
local previousFrameTime = love.timer.getTime() * 1000

debugBeatTime = 0

---@param bpm number
function calculateBeatLength(bpm)
    print(bpm)
    beatInterval = 60000 / bpm
    print("Beat Inverval: " .. beatInterval)
    onBeat = false
    BPMTimer = 0
end

function updateBPM()
    local currentTime = love.timer.getTime() * 1000
    BPMTimer = BPMTimer + (currentTime - previousFrameTime)
    previousFrameTime = currentTime

    debugBeatTime = BPMTimer
    if BPMTimer >= beatInterval then 
        beat()
        frame = 1  
    else
        frame = frame + 1
    end

    if frame == 2 and onBeat then onBeat = false end
end

function beat()
    BPMTimer = 0
    onBeat = true
    --print("Beat")
end
