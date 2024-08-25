local Receptor = Class:extend()

function Receptor:new(lane)
    self.image = Skin.Receptors.Up[States.Game.PlayState.inputMode][Constants.Directions[States.Game.PlayState.inputMode][lane]]
    self.X = LanesPositions[States.Game.PlayState.inputMode][lane]
    self.Y = States.Game.PlayState.strumYPosition
    self.down = false
    self.lane = lane
end

function Receptor:update(dt)
    if self.down then
        self.image = Skin.Receptors.Down[States.Game.PlayState.inputMode][Constants.Directions[States.Game.PlayState.inputMode][self.lane]]
    else
        self.image = Skin.Receptors.Up[States.Game.PlayState.inputMode][Constants.Directions[States.Game.PlayState.inputMode][self.lane]]
        print(self.lane)
    end
end

function Receptor:draw()
    love.graphics.draw(self.image, self.X, self.Y, 0, Skin.Params["Receptor Size"]/self.image:getWidth(), Skin.Params["Receptor Size"]/self.image:getHeight(), self.image:getWidth()/2, self.image:getHeight()/2)
end

function Receptor:release()

end

return Receptor