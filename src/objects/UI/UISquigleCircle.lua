local UISquigleCircle = Class:extend("UISquigleCircle")

function UISquigleCircle:new(mode, x, y, radius, amplitude, frequency, lineThickness, color)
    self.debug = false
    self.mode, self.x, self.y, self.radius, self.amplitude, self.frequency, self.lineThickness =
        mode, x, y, radius, amplitude, frequency, lineThickness
    self.color = {unpack(color)}

    self.rotation = 0
    self.points = {}

    for i = 0, 365, 1 do
        local angle = math.rad(i)
        local r = self.radius + math.sin(angle * self.frequency) * self.amplitude
        local px = r * math.cos(angle)
        local py = r * math.sin(angle)
        table.insert(self.points, px)
        table.insert(self.points, py)
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
    love.graphics.setColor(1,1,1,1)

end

return UISquigleCircle
