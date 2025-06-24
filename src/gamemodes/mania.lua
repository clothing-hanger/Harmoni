local mania = Class:extend("mania")

function mania:new(chart, parent)
    self.parent = parent
    self.chartPath = getDirectory(chart)
    print("with file", chart, "without file", self.chartPath)
    self.chart = mania:setUpChart(chart)
    self.laneSpacing = 30
    self.laneYOffset = 30
    self.playField = {maniaPlayField(self.chart, self)}
    self.song = love.audio.newSource(self.chartPath .. "/" .. self.chart.meta.audioFile,"stream")

    mania.judgements = require("Modules.maniaJudgements")
    self.judgements = mania.judgementObject

    self.judgements = require("Modules.maniaJudgements")

    self:setUpObjects()

    local songCountDown = 2

    Timer.after(0.15, function() self:startSong(songCountDown) end)
end

function mania:startSong(countdown)
    self.parent:startSong(countdown)
end

function mania:setUpObjects(guglio, i, hate, you)

    local backgroundPath = self.chartPath .. self.chart.meta.backgroundFile
    self.background = sharedBackground(backgroundPath, 0.8, 1)
    local songLengthInSeconds = self.song:getDuration("seconds")

    self.timeRemaingBar = UITimeRemaing(0, songLengthInSeconds, 0, baseScreenRatio.y-50, baseScreenRatio.x, self,10,-5,5,30)

    self.judgementObject = maniaJudgement(Skin.Params["Judgement X Offset"], Skin.Params["Judgement Y Offset"], Skin.Params["Judgement Size"], self.judgements, self)

end

function mania:setUpChart(chart)
    local chart = ChartParse.harmc(chart)
    local maniaChart = {}
    maniaChart.meta = chart.meta
    maniaChart.hitObjects = {}

    for i, BpmChange in ipairs(chart.bpm) do
        
       -- print(i, BpmChange.startTime, BpmChange.bpm)
    end
    for i, SliderVeloticy in ipairs(chart.sliderVelocities) do
       -- print(i, SliderVeloticy.startTime, SliderVeloticy.multiplier)
    end
    for i, HitObject in ipairs(chart.hitObjects) do
       -- print(i, HitObject.type, HitObject.startTime, HitObject.length)
        table.insert(maniaChart.hitObjects, {
            type = HitObject.type,
            startTime = HitObject.startTime,
            length = HitObject.length,
            lane = HitObject.lane
        })
    end
    return maniaChart
end

--[[
function mania:input()
    for p,PlayField in ipairs(self.playField) do
        for l,Lane in ipairs(PlayField.lanes) do
            for h,HitObject in ipairs(Lane.hitObjects) do
                if Input:pressed(allInputs[l]) then
                    for j,Judgement in ipairs(self.judgements) do
                        print(Judgement.timing)
                        if math.abs(HitObject.startTime - MusicTime) > Judgement.timing then
                           -- HitObject:hit()
                            --table.remove(Lane.hitObjects, h)
                            break
                        end
                    end
                end
            end
        end
    end
end
--]]

function mania:update(dt)
    self:updateObjects(dt)
    for i,PlayFeild in ipairs(self.playField) do
        PlayFeild:update(dt)
    end
    if MusicTime >=0 and not self.song:isPlaying() then self.song:play() end
end

function mania:updateObjects(dt)
    self.background:update(dt)
    self.judgementObject:update(dt)
    self.timeRemaingBar:update(dt)
end

function mania:draw()
    self.background:draw()

    for i,PlayFeild in ipairs(self.playField) do
        PlayFeild:draw()
    end
    self.judgementObject:draw()
    --TEMP
    love.graphics.setFont(songButtonFontLarge)
    love.graphics.printf(mania.currentTEMPJudgement or "i dont fucking know yet", baseScreenRatio.x/2-1000, baseScreenRatio.y/2, 1000, "center")

    self.timeRemaingBar:draw()
end

return mania