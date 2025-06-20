local maniaPlayField = Class:extend("maniaPlayField")

function maniaPlayField:new(chart, parent)
    self.parent = parent
    self.chart = chart
    self.laneYOffset = maniaLaneYOffset
    self.lanes = {}
    for i = 1, self.chart.meta.laneCount do
        print(self.chart.meta.laneCount)
        local hitObjects = {}
        for _, HitObject in ipairs(self.chart.hitObjects) do
            if i == HitObject.lane then
                table.insert(hitObjects, {
                    type = HitObject.type,
                    startTime = HitObject.startTime,
                    length = HitObject.length
                })
            end
        end
        table.insert(self.lanes, maniaLane(i, self.laneSpacing, self.laneYOffset, hitObjects, self))
    end
end

function maniaPlayField:getPositionFromTime(time, index)
    index = index or -1

    return time -- TODO: Implement SV's
end

function maniaPlayField:update(dt)
    for _, Lane in ipairs(self.lanes) do
        Lane:update(dt)
    end
end

function maniaPlayField:draw()
    for _, Lane in ipairs(self.lanes) do
        Lane:draw()
    end
end

return maniaPlayField