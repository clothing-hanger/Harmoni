local Note = Class:extend()

function Note:new(lane, noteTime) --, length)


    self.lane = lane
    self.noteTime = noteTime
    --self.length = length
    print("New Note "..self.noteTime)

    return self

end

function Note:update(dt)
    
end

function Note:draw()
   -- love.graphics.translate(Inits.GameWidth/2, Inits.GameHeight/2)
  --  love.graphics.translate(-Inits.GameWidth/2, -Inits.GameHeight/2)
    love.graphics.draw(noteImages[self.lane], lanePositions[self.lane], self.noteTime-MusicTime)
end

function Note:release()

end

return Note