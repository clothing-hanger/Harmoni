local throbber = Class:extend("throbber")

function throbber:new(x,y, radius,time, rotateSpeed)
    self.rotateSpeed = rotateSpeed or 5
    self.x,self.y = x,y
    self.time = time or 1
    self.radius = radius or 200
    self.arcLengthSmall = 10
    self.arcLengthLarge = 270
    self.segments = 20
    self.arcLength = self.arcLengthSmall
    self.rotation = 0

    self:throb()
end

function throbber:throb()  -- god why did they name these things "throbbers"
    Timer.tween(self.time, self, {arcLength = self.arcLengthLarge}, "in-out-quad", function()
        Timer.tween(self.time, self, {arcLength = self.arcLengthSmall}, "in-out-quad", function()
        self:throb() end) -- a function calling itself... surely this wont lead to any problems
    end)
end

function throbber:update(dt)
    self.rotation = self.rotation + self.rotateSpeed*dt
end

function throbber:draw()
    love.graphics.push()
    love.graphics.translate(self.x,self.y)
    love.graphics.rotate(self.rotation)
    love.graphics.setLineWidth(20)
    love.graphics.arc("line", "open", 0, 0, self.radius, 0, math.rad(self.arcLength), self.segments)
    love.graphics.pop()
end

return throbber