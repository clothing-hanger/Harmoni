local maniaLane = Class:extend("maniaLane")

function maniaLane:new(maniaLane,spacing,YOffset,hitObjects)
    self.maniaLane = maniaLane
    self.spacing = spacing
    self.yOffset = YOffset
    self.hitObjects = hitObjects
    self.inputBind = maniaInputs[self.maniaLane]
    self.notes = {}

    self:setUpHitObjects(self.hitObjects)
    print("hi",maniaLanePositions[self.maniaLane])
    self.x,self.y = maniaLanePositions[self.maniaLane], self.yOffset
end

function maniaLane:setUpHitObjects(hitObjects)
    for i, HitObject in ipairs(hitObjects) do
        if HitObject.type == "note" then
            table.insert(self.notes, maniaNote(HitObject.startTime, HitObject.length, self.maniaLane))
        end
    end
end

function maniaLane:update(dt)
    for i,Note in ipairs(self.notes) do
        Note:update(dt)
    end
    self:input()
    self:checkForMisses()
end

function maniaLane:input()
    for i,Note in ipairs(self.notes) do
        for j,Judgement in ipairs(mania.judgements) do
            if Input:pressed(self.inputBind) then
                if math.abs(MusicTime - Note.startTime) <= Judgement.timing then
                    table.remove(self.notes, i)
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

    for i,Note in ipairs(self.notes) do
        if MusicTime - Note.startTime > timing then 
            table.remove(self.notes,i)
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

    for i = #self.notes, 1, -1 do
        local Note = self.notes[i]
        if MusicTime - Note.startTime > timing then
            mania.currentTEMPJudgement=   judgementName

            table.remove(self.notes, i)
        end
    end
end

function maniaLane:draw()
    love.graphics.circle("line", self.x, self.y, maniaNoteSize)
    for i,Note in ipairs(self.notes) do
        Note:draw()
    end
end

return maniaLane