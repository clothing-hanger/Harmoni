local maniaPlayField = Class:extend("maniaPlayField")

function maniaPlayField:new(chart)
    self.chart = chart
    self.laneYOffset = maniaLaneYOffset
    self.lanes = {}
    for i = 1, self.chart.meta.laneCount do
        print(self.chart.meta.laneCount)
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

function maniaPlayField:update(dt)
    for i, Lane in ipairs(self.lanes) do
        Lane:update(dt)
    end
end

function maniaPlayField:draw()
    for i, Lane in ipairs(self.lanes) do
        Lane:draw()
    end
end

return maniaPlayField