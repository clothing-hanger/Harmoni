local maniaPlayField = Class:extend("maniaPlayField")

function maniaPlayField:new(chart, parent)
    self.totalNotes = 0
    self.parent = parent
    self.chart = chart
    self.laneYOffset = maniaLaneYOffset
    self.lanes = {}
    self.svMarks = {}
    self.empty = false
    self.svIndex = 1
    self.currentTime = 0

    if #self.chart.scrollVelocities > 0 then
        local first = self.chart.scrollVelocities[1]
        table.insert(self.chart.scrollVelocities, {
            startTime = self.chart.scrollVelocities[#self.chart.scrollVelocities].startTime + 1000,
            multiplier = first.multiplier
        })

        local time = first.startTime
        table.insert(self.svMarks, time)

        for i = 2, #self.chart.scrollVelocities do
            local prev = self.chart.scrollVelocities[i - 1]
            local current = self.chart.scrollVelocities[i]

            time = time + (current.startTime - prev.startTime) * prev.multiplier
            table.insert(self.svMarks, time)
        end
    end

    local mode = tonumber(self.chart.meta.laneCount)
    for i = 1, self.chart.meta.laneCount do
        print(self.chart.meta.laneCount)
        local hitObjects = {}
        for _, HitObject in ipairs(self.chart.hitObjects) do
            if i == HitObject.lane then
                table.insert(hitObjects, {
                    type = HitObject.type,
                    startTime = HitObject.startTime,
                    length = HitObject.length,
                    initialSVTime = self:getPositionFromTime(HitObject.startTime)
                })
            end
        end
        table.insert(self.lanes, maniaLane(mode, i, self.laneSpacing, self.laneYOffset, hitObjects, self))
    end
end

function maniaPlayField:getPositionFromTime(time, index)
    index = index or -1

    if index <= 1 then
        for i = 1, #self.chart.scrollVelocities do
            if time < self.chart.scrollVelocities[i].startTime then
                index = i
                break
            end
        end
    end

    if index <= 1 then
        return time * self.chart.meta.initialSV
    end

    local prev = self.chart.scrollVelocities[index - 1]

    return self.svMarks[index - 1] + (time - prev.startTime) * prev.multiplier
end

function maniaPlayField:update(dt)
    local allLanesEmpty
    while (self.svIndex <= #self.chart.scrollVelocities and MusicTime >= self.chart.scrollVelocities[self.svIndex].startTime) do
        self.svIndex = self.svIndex + 1
    end

    self.currentTime = self:getPositionFromTime(MusicTime, self.svIndex)
    self.totalNotes = 0
    for _, Lane in ipairs(self.lanes) do
        allLanesEmpty = true
        Lane:update(dt)
        if Lane.empty == false then allLanesEmpty = false end
    end

    self.empty = allLanesEmpty
end

function maniaPlayField:draw()
    for _, Lane in ipairs(self.lanes) do
        Lane:draw()
    end

    love.graphics.print(tostring(self.empty), 20, 300, nil, 3,3)
end

return maniaPlayField