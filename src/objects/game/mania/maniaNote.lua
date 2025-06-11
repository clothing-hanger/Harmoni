local maniaNote = Class:extend("maniaNote")

function maniaNote:new(startTime, holdLength, lane, parent)
    self.size = maniaNoteSize
    self.startTime = startTime
    self.holdLength = holdLength
    self.lane = lane
    self.parent = parent

    self.x, self.y = maniaLanePositions[self.lane], self.startTime + (MusicTime or 0)

    self.visible = false
end

function maniaNote:update(dt)
    self:updatePosition()

    if not DOWNSCROLL_ENABLED then
        self.visible = self.y < baseScreenRatio.y + self.size and self.y > 0 - self.size
    else
        self.visible = self.y > 0 - self.size and self.y < baseScreenRatio.y + self.size
    end
end

function maniaNote:updatePosition()
    if not DOWNSCROLL_ENABLED then
        self.y = self.parent.y - (MusicTime - self.startTime) * maniaScrollSpeed
    else
        self.y = self.parent.y + (MusicTime - self.startTime) * maniaScrollSpeed
    end
end

function maniaNote:hit()
    print("hit i guess idk")
end

function maniaNote:draw()
    if not self.visible then return end
    love.graphics.circle("fill", self.x, self.y, self.size)
end

return maniaNote