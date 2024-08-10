local Receptor = Class:extend()

Receptor.Directions = {
    "Left",
    "Down",
    "Up",
    "Right",
}

function Receptor:new(lane)

    

    --self.image = Skin.Receptors.Up[self.Directions[lane]]
    self.image = Skin.Receptors.Up[self.Directions[lane]]
    self.X = LanesPositions[lane]
    self.Y = 0
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