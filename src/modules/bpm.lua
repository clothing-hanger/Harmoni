local bpmHandler = {}

function bpmHandler:init()
    self.lastBeatTime = 0
    self.currentMusicTime = 0
    self.nextBeatTime = 0
    self.fullBeatTime = 0
    self.beatHitOnFrame = false
end

function bpmHandler:setBpm(bpm)
    self.bpm = tonumber(bpm) or 0
    if self.bpm == 0 then GlobalNotificationsHandler:addNotification("current BPM is 0? thats not right", "error") end
end

function bpmHandler:getBpmInterval()
    return 60/self.bpm
end

function bpmHandler:getTimeToNextBeat()
    local nextBeatTime = (self.currentBeatTime + 1) * self.beatInterval
    return nextBeatTime - self.currentMusicTime
end

function bpmHandler:update(dt)
    if not self.bpm then return end
    self.beatInterval = self:getBpmInterval()
    self.currentMusicTime = (MusicTime or 0)/1000
    self.currentBeatTime = math.floor(self.currentMusicTime / self.beatInterval)
    self.fullBeatTime = self.currentMusicTime / self.beatInterval
    self.beatHitOnFrame = false
    if self.currentBeatTime > (self.lastBeatTime or -1) then
        self.lastBeatTime = self.currentBeatTime
        self.beatHitOnFrame = true
    end
end

function bpmHandler:wasBeatHit()
    return self.beatHitOnFrame
end

return bpmHandler