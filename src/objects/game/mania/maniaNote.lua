local maniaNote = Class:extend("maniaNote")

function maniaNote:new(startTime, holdLength, lane, parent)
    self.size = maniaNoteSize
    self.startTime = startTime
    self.holdLength = holdLength
    self.lane = lane
    self.parent = parent

    self.x, self.y = maniaLanePositions[self.lane], self.startTime + (MusicTime or 0)

    self.visible = true
end

function maniaNote:update(dt)
    self:updatePosition()
end

function maniaNote:updatePosition()
    self.y = self:getNotePosition(self.startTime, true)
end

function maniaNote:getNotePosition(time, moveWithScroll) -- moveWithScroll is unused until hold notes are implemented
    if not DOWNSCROLL_ENABLED then
        return self.parent.y - (MusicTime - time) * maniaScrollSpeed
    else
        return self.parent.y + (MusicTime - time) * maniaScrollSpeed
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