local maniaNote = Class:extend("maniaNote")

function maniaNote:new(startTime, holdLength, lane)
    self.size = maniaNoteSize
    self.startTime = startTime
    self.holdLength = holdLength
    self.lane = lane

    self.x, self.y = maniaLanePositions[self.lane], self.startTime + (MusicTime or 0)

    self.visible = false
end

function maniaNote:update(dt)

    self:updatePosition()

    self.visible = self.y < baseScreenRatio.y + self.size and self.y > 0 - self.size
end

function maniaNote:updatePosition()
    self.y = (self.startTime - (MusicTime or 0))*maniaScrollSpeed
end

function maniaNote:hit()
    print("hit i guess idk")
end

function maniaNote:draw()
    if not self.visible then return end
    love.graphics.circle("line", self.x, self.y, self.size)
end

return maniaNote