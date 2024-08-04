local Note = Class:extend()

function Note:new(lane, StartTime)
    self.X = Inits.GameWidth/2
    self.Y = 0
    self.StartTime = StartTime
end

function Note:update(dt)
    self.Y = self.StartTime - MusicTime
end
function Note:draw()
    love.graphics.circle("fill", self.X, self.Y, 25)
end

function Note:release()

end

return Note