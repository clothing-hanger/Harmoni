---@class Ball
local Ball = Class:extend()

---Constructor for the Ball class
---@param x number The x position of the ball
---@param y number The y position of the ball
---@param radius number The radius of the ball
---@param segments number The number of slices (segments) to simulate 3D
---@param rotationSpeed number The speed of rotation in radians per second
function Ball:new(x, y, radius, segments, rotationSpeed)
    self.x = x or love.graphics.getWidth() / 2
    self.y = y or love.graphics.getHeight() / 2
    self.radius = radius or 100
    self.segments = segments or 20
    self.rotationSpeed = rotationSpeed or 2 * math.pi / 5
    self.currentRotation = 0
end

---Update method to update the rotation of the ball
---@param dt number Delta time
function Ball:update(dt)
    self.currentRotation = self.currentRotation + self.rotationSpeed * dt
end

---Draw method to render the 3D spinning ball
function Ball:draw()
    love.graphics.setColor(1, 1, 1)

    -- Draw slices of the ball to simulate 3D
    for i = -self.segments, self.segments do
        local angle = i * math.pi / self.segments

        -- Calculate the radius of each slice
        local sliceRadius = self.radius * math.cos(angle)
        
        -- Calculate the vertical position offset
        local verticalOffset = self.radius * math.sin(angle)

        -- Calculate the alpha based on the angle (to simulate lighting effect)
        local alpha = 0.8 + 0.2 * math.cos(angle + self.currentRotation)

        -- Calculate the X position of the slice based on rotation
        local xOffset = sliceRadius * math.sin(self.currentRotation)

        -- Set the color with the calculated alpha
        love.graphics.setColor(1, 1, 1, alpha)

        -- Draw the slice as an ellipse
        love.graphics.ellipse("fill", self.x + xOffset, self.y + verticalOffset, sliceRadius, sliceRadius / 3)
    end

    -- Reset color
    love.graphics.setColor(1, 1, 1, 1)
end

return Ball
