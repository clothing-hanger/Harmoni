local Note = Class:extend()


Note.Directions = {
    "Left",
    "Down",
    "Up",
    "Right",
}

function Note:new(lane, StartTime, EndTime)
    self.image = Skin.Notes[States.Game.PlayState.inputMode][Constants.Directions[States.Game.PlayState.inputMode][lane]]
    self.Lane = lane
    self.X = LanesPositions[States.Game.PlayState.inputMode][lane]
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
    self.moveWithScroll = true
    self.isHeld = false
    self.holdWasFinished = true -- just because its easier ig

    if self.EndTime > self.StartTime then
        self.isHeld = true
        self.holdWasFinished = false

        self.children = {}
        self.children[1] = {
            image = Skin.HoldNotes[States.Game.PlayState.inputMode][Constants.Directions[States.Game.PlayState.inputMode][lane]],
            height = 175,
            y = 0,
        }
        self.children[2] = {
            image = Skin.HoldEndNotes[States.Game.PlayState.inputMode][Constants.Directions[States.Game.PlayState.inputMode][lane]],
            height = 175,
            y = 0,
        }
    end
end

function Note:getNotePosition(time)
    if not self.moveWithScroll then
        return States.Game.PlayState.strumYPosition
    end
    if Settings.scrollDirection == "Down" then
        return States.Game.PlayState.strumYPosition + (States.Game.PlayState.CurrentTime - time) * convertScrollSpeed(Settings.scrollSpeed)
    else
        return States.Game.PlayState.strumYPosition - (States.Game.PlayState.CurrentTime - time) * convertScrollSpeed(Settings.scrollSpeed)
    end
end

function Note:update(dt)
    if Mods.wave then
        self.StartTime = self.StartTime - waveTime
    end

    if Mods.ramp then self.StartTime = self.StartTime + rampTime end

    self.Y = self:getNotePosition(self.InitialStartTime)

    if self.isHeld then
        local endY = self:getNotePosition(self.InitialEndtime)

        self.children[1].y = self.Y
        self.children[2].y = endY

        local pixelDiff = endY - self.Y

        self.children[1].height = pixelDiff - 200
        self.children[2].y = self.children[2].y - 200

        
        --[[ if (self.Y < Inits.GameHeight) or (self.Y < 0 - Skin.Params["Note Size"]) then
            print(pixelDiff)
        end ]]
    end

    if Mods.fadeOut and Settings.scrollDirection == "Up" then
        if self.Y < Inits.GameHeight/2 then
            self.alpha = self.alpha-10*dt
        end
    end

    if Mods.fadeIn and Settings.scrollDirection == "Up" then
        if self.Y < Inits.GameHeight/2+200 then
            self.alpha = self.alpha+5*dt
        end
    end
end

function Note:hit(noteTime, wasMiss)
    self.visible = wasMiss
    self.wasHit = true
    self.tooLate = wasMiss
end

function Note:draw()
    love.graphics.setColor(1,1,1,self.alpha)
    if self.tooLate then love.graphics.setColor(0.5,0.5,0.5,1) end
    --[[
    if self.isHeld and not self.holdWasFinished then
        if (self.Y <= Inits.GameHeight+Skin.Params["Note Size"]) or (self.Y <= 0 - Skin.Params["Note Size"]) then
            for i, child in ipairs(self.children) do
                love.graphics.draw(child.image, self.X, child.y, 0, Skin.Params["Hold" .. (i == 2 and "End" or "") .. " Size"]/child.image:getWidth(), (i == 2 and Skin.Params["Hold Size"] or child.height)/child.image:getHeight(), child.image:getWidth()/2)
            end
        end
    end
    --]]
    if not self.visible or not (self.Y <= Inits.GameHeight+Skin.Params["Note Size"]) or (self.Y <= 0 - Skin.Params["Note Size"]) then love.graphics.setColor(1,1,1); return end
    love.graphics.draw(self.image, self.X, self.Y, 0, Skin.Params["Note Size"]/self.image:getWidth(), Skin.Params["Note Size"]/(self.image:getHeight()), self.image:getWidth()/2, self.image:getHeight()/2)
    love.graphics.setColor(1,1,1)
end

function Note:release()

end

return Note