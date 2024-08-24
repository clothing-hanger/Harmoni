local Receptor = Class:extend()

function Receptor:new(lane)
    --self.image = Skin.Receptors.Up[self.Directions[lane]]
    self.image = Skin.Receptors.Up["4K"][Constants.Directions["4K"][lane]]
    self.X = LanesPositions["4K"][lane]
    self.Y = States.Game.PlayState.strumYPosition
end

function Receptor:update(dt)
end

function Receptor:draw()
    --love.graphics.circle("line", self.X, self.Y, 25)
    love.graphics.draw(self.image, self.X, self.Y, 0, Skin.Params["Receptor Size"]/self.image:getWidth(), Skin.Params["Receptor Size"]/self.image:getHeight(), self.image:getWidth()/2, self.image:getHeight()/2)
end

function Receptor:release()

end

return Receptor