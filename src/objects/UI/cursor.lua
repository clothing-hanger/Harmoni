local cursor = Class:extend("cursor")

function cursor:new()
    self.x,self.y = love.mouse.getPosition()
    self.prevX,self.prevY = self.x,self.y
    self.angle = 0
    self.rotationSpeed = 5
    self.targetAngle = 0
    self.size = 0.5
    OSCursorVisible = false
    self.color = 1
    self.lerpSpeed = 20
    self.image = love.graphics.newImage("images/UI/cursor.png")  -- remember to make this skinnable eventually or something idkl
end
function cursor:update(dt)
    self.prevX, self.prevY = self.x, self.y
    self.x, self.y = love.mouse.getPosition()

    local dx = self.x - self.prevX
    local dy = self.y - self.prevY

    local distSq = dx * dx + dy * dy

    if distSq > 1 then
        self.targetAngle = math.atan2(dy, dx)
    end

    self.angle = lerpAngle(self.angle, self.targetAngle, math.min(1, dt * self.rotationSpeed))


    local targetSize = Input:down("menuClickLeft") and 0.65 or 0.5

    self.size = lerp(self.size, targetSize,self.lerpSpeed*dt)

    local targetColor = Input:down("menuClickLeft") and 1 or 0
    self.color = lerp(self.color, targetColor,self.lerpSpeed*2*dt)
end


function cursor:draw()
    love.graphics.push()
   -- love.graphics.rotate(self.angle)
    love.graphics.setColor(self.color,self.color,self.color)


    love.graphics.draw(self.image, self.x, self.y, self.angle, self.size, self.size, self.image:getWidth(), self.image:getHeight()/2)
    love.graphics.setColor(1,1,1)
    love.graphics.pop()
end


return cursor

