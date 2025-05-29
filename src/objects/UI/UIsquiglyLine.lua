local UISquiglyLine = Class:extend("UISquiglyLine")

function UISquiglyLine:new(x1,y1,x2,y2,frequency,amplitude,segments,speed)
    self.wave = {}
    self.x1, self.y1 = x1,y1
    self.x2, self.y2 = x2,y2
    self.frequency = frequency
    self.amplitude = amplitude
    self.speed = speed or false
    self.time = 0
    self.segments = segments
end

function UISquiglyLine:update(dt)
    self.time = self.time*dt

end

function UISquiglyLine:draw()
    local points = {}

    local dx = self.x2 - self.x1
    local dy = self.y2 - self.y1
    local length = math.sqrt(dx * dx + dy * dy)

    local dir_x = dx / length
    local dir_y = dy / length

    local perp_x = -dir_y
    local perp_y = dir_x

    for i = 0, self.segments do
        local t = i / self.segments
        local px = self.x1 + dx * t
        local py = self.y1 + dy * t

        -- Apply sine offset perpendicular to the main line
        local offset = math.sin(t * self.frequency * 2 * math.pi + self.time * self.speed) * self.amplitude
        local ox = perp_x * offset
        local oy = perp_y * offset

        table.insert(points, px + ox)
        table.insert(points, py + oy)


    end

        love.graphics.setColor(1, 1, 1)
        love.graphics.line(points)

        love.graphics.setColor(1, 0, 0)
        love.graphics.circle("fill", self.x1, self.y1, 5)
        love.graphics.circle("fill", self.x2, self.y2, 5)

end

return UISquiglyLine