local mania = Class:extend("mania")

function mania:new(chart)
    self.chart = mania:setUpChart(chart)
    self.laneSpacing = 30
    self.laneYOffset = 30
    self.lanes = {}
    for i = 1, self.chart.meta.laneCount do
        local hitObjects = {}
        for j, HitObject in ipairs(self.chart.hitObjects) do
            if i == HitObject.lane then
                table.insert(hitObjects, {
                    type = HitObject.type,
                    startTime = HitObject.startTime,
                    length = HitObject.length
                })
            end
        end
        table.insert(self.lanes, maniaLane(i, self.laneSpacing, self.laneYOffset, hitObjects))
    end
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

function mania:update(dt)
    for i,Lane in ipairs(self.lanes) do
        Lane:update(dt)
    end
end

function mania:draw()
    for i,Lane in ipairs(self.lanes) do
        Lane:draw()
    end
end

return mania