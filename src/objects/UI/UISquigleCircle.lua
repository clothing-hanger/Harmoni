local UISquigleCircle = Class:extend("UISquigleCircle")

function UISquigleCircle:new(mode, x, y, radius, amplitude, frequency, lineThickness, color)
    self.mode = mode
    self.x = x
    self.y = y
    self.radius = radius
    self.amplitude = amplitude
    self.frequency = frequency
    self.lineThickness = lineThickness
    self.color = table.clone(color)

    self.rotation  = 0

    local points = {}
    self.points = points

    local p = 1
    for deg = 0, 359 do
        local angle = math.rad(deg)
        local r = radius + math.sin(angle * frequency) * amplitude

        points[p] = r * math.cos(angle)
        points[p + 1] = r * math.sin(angle)
        p = p + 2
    end
end

function UISquigleCircle:update(dt)
    --self.rotation = self.rotation + math.sin(love.timer.getTime())*0.01
end

function UISquigleCircle:draw()
    love.graphics.push()
    love.graphics.setColor(self.color)
    love.graphics.translate(self.x, self.y)
    love.graphics.rotate(math.rad(self.rotation))

    love.graphics.setLineWidth(self.lineThickness)
    love.graphics.polygon(self.mode, self.points)

    love.graphics.pop()
    love.graphics.setColor(1, 1, 1, 1)
end

return UISquigleCircle
