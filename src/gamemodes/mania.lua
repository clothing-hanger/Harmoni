local mania = Class:extend("mania")

function mania:new(chart)
    self.chartPath = getDirectory(chart)
    print("with file", chart, "without file", self.chartPath)
    self.chart = mania:setUpChart(chart)
    self.laneSpacing = 30
    self.laneYOffset = 30
    self.playField = {maniaPlayField(self.chart)}
    self.song = love.audio.newSource(self.chartPath .. "/" .. self.chart.meta.audioFile,"stream")

    mania.judgements = require("Modules.maniaJudgements")
    self.judgements = mania.judgements
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
    for i,PlayFeild in ipairs(self.playField) do
        PlayFeild:update(dt)
    end
    if MusicTime >=0 and not self.song:isPlaying() then self.song:play() end
end

function mania:draw()
    for i,PlayFeild in ipairs(self.playField) do
        PlayFeild:draw()
    end

    --TEMP
    love.graphics.setFont(songButtonFontLarge)
    love.graphics.printf(mania.currentTEMPJudgement or "i dont fucking know yet", baseScreenRatio.x/2-1000, baseScreenRatio.y/2, 1000, "center")
end

return mania