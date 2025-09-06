local maniaPlayField = Class:extend("maniaPlayField")

function maniaPlayField:new(chart, parent)
    self.parent = parent
    self.chart = chart
    self.laneYOffset = maniaLaneYOffset
    self.lanes = {}
    self.svMarks = {}
    self.finished = false
    self.svIndex = 1
    self.currentTime = 0
    self.endNoteTime = 0
    self.totalNotes = 0
    self.laneSpacing = 0

    if #self.chart.scrollVelocities > 0 then
        local svs = self.chart.scrollVelocities
        local first = svs[1]

        table.insert(svs, {
            startTime = svs[#svs].startTime + 1000,
            multiplier = first.multiplier
        })

        local time = first.startTime
        table.insert(self.svMarks, time)

        for i = 2, #svs do
            local prev, current = svs[i - 1], svs[i]
            time = time + (current.startTime - prev.startTime) * prev.multiplier
            table.insert(self.svMarks, time)
        end
    end

    local mode = tonumber(self.chart.meta.laneCount)

    for laneIndex = 1, mode do
        local hitObjects = {}

        for _, hitObj in ipairs(self.chart.hitObjects) do
            if laneIndex == hitObj.lane then
                table.insert(hitObjects, {
                    type = hitObj.type,
                    startTime = hitObj.startTime,
                    endTime = hitObj.endTime,
                    initialSVTime = self:getPositionFromTime(hitObj.startTime)
                })

                local noteEndTime = hitObj.startTime
                if hitObj.endTime and hitObj.endTime > noteEndTime then
                    noteEndTime = hitObj.endTime

                   printToConsole("song SHOULD end at " .. noteEndTime .. " if it doesnt im deleting the fucking game")
                end
                if noteEndTime > self.endNoteTime then
                    self.endNoteTime = noteEndTime
                end
            end
        end

        table.insert(self.lanes, maniaLane(mode, laneIndex, self.laneSpacing, self.laneYOffset, hitObjects, self))
    end
end

function maniaPlayField:getPositionFromTime(time, index)
    index = index or -1

    if index <= 1 then
        for i, sv in ipairs(self.chart.scrollVelocities) do
            if time < sv.startTime then
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
    while self.svIndex <= #self.chart.scrollVelocities and
          MusicTime >= self.chart.scrollVelocities[self.svIndex].startTime do
        self.svIndex = self.svIndex + 1
    end

    self.currentTime = self:getPositionFromTime(MusicTime, self.svIndex)

    self.totalNotes = 0
    for _, lane in ipairs(self.lanes) do
        lane:update(dt, self.currentTime)
        self.totalNotes = self.totalNotes + #lane.notes
    end

    if MusicTime > self.endNoteTime  then
        self.finished = true
    end
end

function maniaPlayField:draw()
    for _, lane in ipairs(self.lanes) do
        lane:draw()
    end
end

return maniaPlayField
