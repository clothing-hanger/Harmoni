local UISquiglyLine = Class:extend("UISquiglyLine")

function UISquiglyLine:new(x1,y1,x2,y2,frequency,amplitude,segments,speed,lineWidth,color)    -- i will not lie GPT saved me with this one this shit did NOT work before i asked GPT 
    self.wave = {}                                                            --   usually it would just break things lol but no with this it actually made it work, it was just a straight line when i made it 😭
    self.x1, self.y1 = x1,y1
    self.x2, self.y2 = x2,y2
    self.frequency = frequency
    self.amplitude = amplitude
    self.speed = speed or 1
    self.time = 0
    self.segments = segments
    self.lineWidth = lineWidth or 1
    self.color = color or {1,1,1}
end

function UISquiglyLine:update(dt)
    self.time = self.time + dt

end

function UISquiglyLine:draw()
    local lastLineWidth = love.graphics.getLineWidth()
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

        local offset = math.sin(t * self.frequency * 2 * math.pi - self.time * self.speed) * self.amplitude
        local ox = perp_x * offset
        local oy = perp_y * offset

        table.insert(points, px + ox)
        table.insert(points, py + oy)
    end

    love.graphics.setLineWidth(self.lineWidth)
    love.graphics.line(points)

    love.graphics.circle("fill", self.x1, self.y1, 5)
    love.graphics.circle("fill", self.x2, self.y2, 5)

    love.graphics.setLineWidth(lastLineWidth)
end

return UISquiglyLine