local Cursor = Class:extend()

function Cursor:new()
    self.x, self.y = 0, 0
    print(self.x)
end

function Cursor:update(dt)
    print(self.x)
   -- self.x, self.y = love.mouse.getPosition()
end

function Cursor:draw()
    love.graphics.setColor(1,1,1)
    --love.graphics.rectangle("fill", self.x, self.y, 10, 10)
end

function Cursor:release()

end

return Cursor