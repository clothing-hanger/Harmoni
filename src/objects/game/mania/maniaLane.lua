local maniaLane = Class:extend("maniaLane")

function maniaLane:new(maniaLane,spacing,YOffset,hitObjects,parent)
    self.maniaLane = maniaLane
    self.spacing = spacing
    self.yOffset = YOffset
    self.hitObjects = hitObjects
    self.inputBind = maniaInputs[self.maniaLane]
    self.parent = parent
    self.notes = {}
    self.drawableNotes = {}

    self:setUpHitObjects(self.hitObjects)
    self:setUpReceptor()
    print("hi",maniaLanePositions[self.maniaLane])
    self.x,self.y = maniaLanePositions[self.maniaLane], self.yOffset

end

function maniaLane:setUpReceptor()  -- does this really need to be a whole function lol
    self.receptor = maniaReceptor:new(self.lane, self.inputBind, self)
end

function maniaLane:setUpHitObjects(hitObjects)
    for i, HitObject in ipairs(hitObjects) do
        if HitObject.type == "note" then
            table.insert(self.notes, maniaNote(HitObject.startTime, HitObject.length, self.maniaLane, self))
        end
    end
end

function maniaLane:update(dt)
    while #self.notes > 0 and self:isOnScreen(self.notes[1]) do
        local note = table.remove(self.notes, 1)
        table.insert(self.drawableNotes, note)
    end
    for _, note in ipairs(self.drawableNotes) do
        note:update(dt)
    end
    self:input()
    self:checkForMisses()
end

function maniaLane:isOnScreen(note)
    if DOWNSCROLL_ENABLED then
        return note:getNotePosition(self.parent:getPositionFromTime(note.startTime), true) > -500
    else
        return note:getNotePosition(self.parent:getPositionFromTime(note.startTime), true) < baseScreenRatio.y + 500
    end
end

function maniaLane:input()
    for i,Note in ipairs(self.drawableNotes) do
        for j,Judgement in ipairs(mania.judgements) do
            if Input:pressed(self.inputBind) then
                if math.abs(MusicTime - Note.startTime) <= Judgement.timing then
                    table.remove(self.drawableNotes, i)
                    mania.currentTEMPJudgement=   Judgement.name
                    break
                end
            end
        end
    end
end

function maniaLane:checkForMisses() -- imagine 
-- get the miss timing
    local timing
    for i,Judgement in ipairs(mania.judgements) do
        print(Judgement.name)
        if Judgement.name == "Miss" then timing = Judgement.timing end
    end

    for i,Note in ipairs(self.drawableNotes) do
        if MusicTime - Note.startTime > timing then 
            table.remove(self.drawableNotes,i)
            break
        end
    end
end

function maniaLane:checkForMisses()
    local timing
    local judgementName
    for _, Judgement in ipairs(mania.judgements) do
        if Judgement.name == "Miss" then
            timing = Judgement.timing
            judgementName = Judgement.name
            break
        end
    end

    if not timing then return end

    for i = #self.drawableNotes, 1, -1 do
        local Note = self.drawableNotes[i]
        if MusicTime - Note.startTime > timing then
            mania.currentTEMPJudgement=   judgementName

            table.remove(self.drawableNotes, i)
        end
    end
end

function maniaLane:draw()
    love.graphics.circle("line", self.x, self.y, maniaNoteSize)
    for i,Note in ipairs(self.drawableNotes) do
        Note:draw()
    end
end

return maniaLane