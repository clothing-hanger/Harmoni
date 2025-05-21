local maniaLane = Class:extend("maniaLane")

function maniaLane:new(maniaLane,spacing,YOffset)
    self.maniaLane = maniaLane
    self.spacing = spacing
    self.YOffset = YOffset

    self.x,self.y = maniaLanePositions[self.maniaLane], self.YOffset
end

function maniaLane:update(dt)
end

function maniaLane:draw()
    love.graphics.circle("line", self.x, self.y, maniaNoteSize)
end

return maniaLane