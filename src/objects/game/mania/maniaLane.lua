local maniaLane = Class:extend("maniaLane")

function maniaLane:new(maniaLane,spacing,YOffset,hitObjects)
    self.maniaLane = maniaLane
    self.spacing = spacing
    self.yOffset = YOffset
    self.hitObjects = hitObjects
    self.notes = {}

    self:setUpHitObjects(self.hitObjects)



    self.x,self.y = maniaLanePositions[self.maniaLane], self.yOffset
end

function maniaLane:setUpHitObjects(hitObjects)
    --print(#hitObjects)
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
end

function maniaLane:draw()
    love.graphics.circle("line", self.x, self.y, maniaNoteSize)
    for i,Note in ipairs(self.notes) do
        Note:draw()
    end
end

return maniaLane