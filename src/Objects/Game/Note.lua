local Note = Class:extend()



function Note:new(lane, StartTime)

    self.Directions = {
        "Left",
        "Down",
        "Up",
        "Right",
    }

    self.image = Skin.Notes[self.Directions[lane]]
    self.Lane = lane
    self.X = LanesPositions[lane]
    self.Y = 0
    self.StartTime = StartTime
    self.visible = true
    self.wasHit = false
end

function Note:update(dt)
    self.Y = -(MusicTime - self.StartTime)*ScrollSpeed
end

function Note:hit(noteTime)
    self.visible = false
    self.wasHit = true
end

function Note:draw()
    if not self.visible or not (self.Y < Inits.GameHeight) then return end
    love.graphics.draw(self.image, self.X, self.Y, 0, Skin.Params["Note Size"]/self.image:getWidth(), Skin.Params["Note Size"]/self.image:getHeight(), self.image:getWidth()/2, self.image:getHeight()/2)
end

function Note:release()

end

return Note