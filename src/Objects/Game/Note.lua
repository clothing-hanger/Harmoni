local Note = Class:extend()


Note.Directions = {
    "Left",
    "Down",
    "Up",
    "Right",
}

function Note:new(lane, StartTime, EndTime)
    self.image = Skin.Notes[self.Directions[lane]]
    self.Lane = lane
    self.X = LanesPositions[lane]
    self.Y = Inits.GameHeight*2
    self.StartTime = StartTime
    self.EndTime = EndTime or 0 -- if 0, not a hold
    self.visible = true
    self.wasHit = false
    self.tooLate = false
    if Mods.fadeIn then
        self.alpha = 0
    end

    self.InitialStartTime = 0
    self.InitialEndtime = 0
end

function Note:getNotePosition(time)
    if Settings.scrollDirection == "Down" then
        return (States.Game.PlayState.CurrentTime - time) * convertScrollSpeed(Settings.scrollSpeed)
    else
        return -(States.Game.PlayState.CurrentTime - time) * convertScrollSpeed(Settings.scrollSpeed)
    end
end

function Note:update(dt)

    if Mods.wave then
        self.StartTime = self.StartTime - waveTime
    end

    if Mods.ramp then self.StartTime = self.StartTime + rampTime end

    --[[ self.Y = Inits.GameHeight-200+(MusicTime - self.StartTime)*Settings.scrollSpeed ]]
    self.Y = self:getNotePosition(self.InitialStartTime)

    if Mods.fadeOut then
        if Settings.scrollDirection == "Up" then  -- fix downscroll
            if self.Y < Inits.GameHeight/2 then
                self.alpha = self.alpha-10*dt
            end
        else
            if self.Y > Inits.GameHeight/2 then
                self.alpha = self.alpha-10*dt
            end
        end
    end

    if Mods.fadeIn then
        if Settings.scrollDirection == "Up" then  -- fix downscroll
            if self.Y < Inits.GameHeight/2+200 then
                self.alpha = self.alpha+5*dt
            end
        else
            if self.Y > Inits.GameHeight/2-200 then
                self.alpha = self.alpha+5*dt
            end
        end
    end
end

function Note:hit(noteTime, wasMiss)
    self.visible = wasMiss
    self.wasHit = true
    self.tooLate = wasMiss 
end

function Note:draw()
    if Settings.scrollDirection == "Up" then
        if not self.visible or self.Y > Inits.GameHeight or self.Y < 0 then
            return
        end
    else
        if not self.visible or self.Y < -Inits.GameHeight or self.Y > Inits.GameHeight*2 then
            return
        end
    end
    
    love.graphics.setColor(1,1,1,self.alpha)
    if self.tooLate then love.graphics.setColor(0.5,0.5,0.5,1) end
    love.graphics.draw(self.image, self.X, self.Y, 0, Skin.Params["Note Size"]/self.image:getWidth(), Skin.Params["Note Size"]/self.image:getHeight(), self.image:getWidth()/2, self.image:getHeight()/2)
    love.graphics.setColor(1,1,1)
end

function Note:release()

end

return Note