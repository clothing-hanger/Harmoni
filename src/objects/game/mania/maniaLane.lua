local maniaLane = Class:extend("maniaLane")

function maniaLane:new(mode, laneIndex, spacing, yOffset, hitObjects, parent)
    self.maniaMode = mode
    self.maniaLane = laneIndex
    self.spacing = spacing
    self.yOffset = yOffset
    self.hitObjects = hitObjects
    self.parent = parent
    self.notes = {}
    self.drawableNotes = {}
    self.empty = false

    self.inputBind = maniaInputs[mode][self.maniaLane]

    local laneCountKey = self.parent.chart.meta.laneCount .. "K"
    self.x = maniaLanePositions[laneCountKey][self.maniaLane]
    self.y = self.yOffset

    self:setUpHitObjects(self.hitObjects)
    self:setUpReceptor()
end

function maniaLane:setUpReceptor()
    self.receptor = maniaReceptor(self.maniaMode, self.maniaLane, self.inputBind, self.x, self.y, self)
end

function maniaLane:setUpHitObjects(hitObjects)
    for _, hitObject in ipairs(hitObjects) do
        if hitObject.type == "note" then
            table.insert(self.notes, maniaNote(
                hitObject.startTime,
                hitObject.length,
                self.maniaLane,
                self.maniaMode,
                hitObject.initialSVTime,
                self
            ))
        end
    end
end

function maniaLane:update(dt)
    while #self.notes > 0 and self:isOnScreen(self.notes[1]) do
        table.insert(self.drawableNotes, table.remove(self.notes, 1))
    end

    for _, note in ipairs(self.drawableNotes) do
        note:update(dt)
    end

    self.receptor:update(dt)
    self:handleInput()
    self:checkForMisses()

    self.empty = (#self.notes == 0 and #self.drawableNotes == 0)
end

function maniaLane:isOnScreen(note)
    return note.startTime - MusicTime <= 5000
end

function maniaLane:handleInput()
    if not Input then return end
    if not Input:pressed(self.inputBind) then return end

    local bestNoteIndex = nil
    local bestJudgement = nil
    local bestTimeDiff = math.huge

    for i, note in ipairs(self.drawableNotes) do
        local timeDiff = math.abs(MusicTime - note.startTime)
        for _, judgement in ipairs(mania.judgements) do
            if timeDiff <= judgement.timing and timeDiff < bestTimeDiff then
                bestTimeDiff = timeDiff
                bestNoteIndex = i
                bestJudgement = judgement
            end
        end
    end

    if bestNoteIndex and bestJudgement then
        local note = self.drawableNotes[bestNoteIndex]
        local parentParent = self.parent.parent
        table.remove(self.drawableNotes, bestNoteIndex)
        parentParent.comboCount:incrementCombo()
        parentParent.judgementObject:judge(bestJudgement.name)
        parentParent.healthBar:changeHealth(bestJudgement.health)
    end
end


function maniaLane:checkForMisses()
    local missJudgement
    for _, judgement in ipairs(mania.judgements or {}) do
        if judgement.name == "Miss" then
            missJudgement = judgement
            break
        end
    end

    if not missJudgement then return end

    local currentTime = MusicTime
    local timingWindow = missJudgement.timing

    for i = #self.drawableNotes, 1, -1 do
        local note = self.drawableNotes[i]
        if currentTime - note.startTime > timingWindow then
            local parentParent = self.parent.parent
            parentParent.judgementObject:judge(missJudgement.name)
            parentParent.comboCount:breakCombo()
            parentParent.healthBar:changeHealth(missJudgement.health)

            table.remove(self.drawableNotes, i)
        end
    end
end

function maniaLane:draw()
    self.receptor:draw()
    for _, note in ipairs(self.drawableNotes) do
        note:draw()
    end
end

return maniaLane
