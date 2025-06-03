local mania = Class:extend("mania")

local allInputs = {
    "lane14K",
    "lane24K",
    "lane34K",
    "lane44K",
}

function mania:new(chart)
    self.chart = mania:setUpChart(chart)
    self.laneSpacing = 30
    self.laneYOffset = 30
    self.playField = {maniaPlayField(self.chart)}
    

    self.judgements = require("Modules.maniaJudgements")
end

function mania:setUpChart(chart)
    local chart = ChartParse.harmc(chart)
    local maniaChart = {}
    maniaChart.meta = {}
    maniaChart.hitObjects = {}

    for i, Data in pairs(chart.meta) do
        maniaChart.meta[i] = Data
       -- print(i, Data)
    end
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

function mania:update(dt)
    for i,PlayFeild in ipairs(self.playField) do
        PlayFeild:update(dt)
    end

    self:input()
end

function mania:draw()
    for i,PlayFeild in ipairs(self.playField) do
        PlayFeild:draw()
    end
end

return mania