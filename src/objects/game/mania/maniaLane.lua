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
                hitObject.endTime,
                self.maniaLane,
                self.maniaMode,
                hitObject.initialSVTime,
                hitObject.initialSVEndTime,
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
    self:checkHoldReleases()
    self:checkForMisses()

    self.empty = (#self.notes == 0 and #self.drawableNotes == 0)
end

function maniaLane:isOnScreen(note)
    return note.startTime - MusicTime <= 10000
end

function maniaLane:handleInput()
    if not Input then return end -- why would input be nil???????????


    
    if not self.parent.parent.mods["BP"] then
        if not Input:pressed(self.inputBind) then return end
    end
    table.insert(self.parent.parent.inputsPerSecond, 1000)


    local bestJudgement = nil
    local bestTimeDiff = math.huge
    local note = self.drawableNotes[1]
    if not note then return end

    local timeDiff = math.abs(MusicTime - note.startTime)
    if not self.parent.parent.mods["BP"] then
        for _, judgement in ipairs(mania.judgements) do
            if timeDiff <= judgement.timing and timeDiff < bestTimeDiff then
                bestTimeDiff = timeDiff
                bestJudgement = judgement
            end
        end
    else
        local judgement = mania.judgements[1] -- should always be perfect
        if timeDiff <= judgement.timing and timeDiff < bestTimeDiff and not note.botplayhit then
            bestTimeDiff = timeDiff
            bestJudgement = judgement
            note.botplayhit = true
        end
    end

    if bestJudgement then
        local state = self.parent.parent
        if not note.holdLength then
            table.remove(self.drawableNotes, 1)
            table.insert(self.parent.parent.notesPerSecond, 1000)
        else
            note.held = true
            note.holdStartTime = MusicTime
        end

        state.judgementObject:judge(bestJudgement.name)
        if bestJudgement.name == "Miss" then self.parent.parent.comboCount:breakCombo() end -- pretty self explanitory, huh?

        state.scoreHandler:addScore(bestJudgement.score)
        local healthChange

        if self.parent.parent.mods["EZ"] and bestJudgement.name == "Miss" then
            healthChange = bestJudgement.health/2   -- i have no clue if this works or not honestly
        else
            healthChange = bestJudgement.health
        end

        --if self.parent.parent.mods["SD"] and bestJudgement.name == "Miss" then state.healthBar:justFuckingDie() end

        state.healthBar:changeHealth(healthChange)

        state.comboCount:incrementCombo()
    end
end

function maniaLane:checkHoldReleases()
    if not Input then return end

    if not self.parent.parent.mods["BP"] then
        if not Input:released(self.inputBind) then return end
    end

    for i = #self.drawableNotes, 1, -1 do
        local note = self.drawableNotes[i]

        if note.holdLength and note.held and not note.released then
            local releaseDiff = math.abs(MusicTime - note.endTime)

            local bestJudgement = nil
            local bestDiff = math.huge

            if self.parent.parent.mods["BP"] then
                if math.abs(MusicTime - note.endTime) <= mania.judgements[1].timing then
                    bestDiff = releaseDiff
                    bestJudgement = mania.judgements[1]
                end
            else

                for _, judgement in ipairs(mania.judgements) do
                    local holdWindow = judgement.timing * 1.5
                    if judgement.name == "Miss" then
                        holdWindow = judgement.timing
                    end
                    if releaseDiff <= holdWindow and releaseDiff < bestDiff then
                        bestDiff = releaseDiff
                        bestJudgement = judgement
                    end
                end

            end
            if bestJudgement then
                note.held = false
                note.released = true
                table.remove(self.drawableNotes, i)

                -- Uncomment this block to enable hold note release judgements -Guglio
                --[[
                local parentParent = self.parent.parent
                parentParent.comboCount:incrementCombo()
                parentParent.judgementObject:judge(bestJudgement.name)
                parentParent.healthBar:changeHealth(bestJudgement.health)
                --]]
                
            end
        end
    end
end

function maniaLane:checkForMisses()
    local missJudgement = nil
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

        if not note.holdLength and currentTime - note.startTime > timingWindow then
            table.remove(self.drawableNotes, i)
            local parentParent = self.parent.parent
            parentParent.comboCount:breakCombo()
            parentParent.judgementObject:judge("Miss")
            parentParent.scoreHandler:addScore(missJudgement.score)
            parentParent.healthBar:changeHealth(missJudgement.health)
        end

        if note.holdLength and not note.released then
            if currentTime > note.endTime + 100 then
                table.remove(self.drawableNotes, i)
                note.held = false
                note.released = true

                local parentParent = self.parent.parent
                parentParent.comboCount:breakCombo()
                parentParent.judgementObject:judge("Miss")
                parentParent.scoreHandler:addScore(missJudgement.score)
                parentParent.healthBar:changeHealth(missJudgement.health)
            end
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
