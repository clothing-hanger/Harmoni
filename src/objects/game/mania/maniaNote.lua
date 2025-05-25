local maniaNote = Class:extend("maniaNote")

function maniaNote:new(startTime, holdLength, lane)
    self.startTime = startTime
    self.holdLength = holdLength
    print(lane)
    self.lane = lane
    print(MusicTime)
    self.x, self.y = maniaLanePositions[self.lane], self.startTime + (MusicTime or 0)
end

function maniaNote:update(dt)

    self:updatePosition()
end

function maniaNote:updatePosition()
    self.y = (self.startTime - (MusicTime or 0))*maniaScrollSpeed
end

function maniaNote:draw()
    love.graphics.circle("line", self.x, self.y, maniaNoteSize)
end

return maniaNote