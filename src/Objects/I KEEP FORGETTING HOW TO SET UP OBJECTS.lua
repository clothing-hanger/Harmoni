local Player = Class:extend()

function Player:new()
    self.x, self.y = 700, 250
end

function Player:update(dt)
    self.x = 640 + math.cos(love.timer.getTime()) * 100
    self.y = 360 + math.sin(love.timer.getTime()) * 100
end

function Player:draw()
    love.graphics.translate(Inits.WindowWidth/2, Inits.WindowHeight/2)
    love.graphics.translate(-Inits.WindowWidth/2, -Inits.WindowHeight/2)
    love.graphics.rectangle("fill", self.x, self.y, 25, 25)
end

function Player:release()

end

return Player