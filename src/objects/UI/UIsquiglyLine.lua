local UISquiglyLine = Class:extend("UISquiglyLine")

local tpi = math.pi * 2

function UISquiglyLine:new(x1, y1, x2, y2, frequency, amplitude, segments, speed, lineWidth, color)
    self.x1, self.y1 = x1, y1
    self.x2, self.y2 = x2, y2

    self.frequency = frequency
    self.amplitude = amplitude
    self.segments  = segments
    self.speed = speed or 1
    self.time  = 0

    self.lineWidth = lineWidth or 1
    self.color = color or {1,1,1}

    self.height = 100
    self.x = self.x1
    self.y = self.y1 - self.height/2
    self.width = self.x2 - self.x1

    local dx = x2 - x1
    local dy = y2 - y1
    local length = math.sqrt(dx*dx + dy*dy)

    self.dir_x = dx / length
    self.dir_y = dy / length

    self.perp_x = -self.dir_y
    self.perp_y =  self.dir_x

    self.points = {}
    local count = (segments + 1) * 2
    for i = 1, count do
        self.points[i] = 0
    end
end

function UISquiglyLine:update(dt)
    self.time = self.time + dt
end

function UISquiglyLine:draw()
    local points = self.points
    local p = 1
    local seg = self.segments

    local x1 = self.x1
    local y1 = self.y1

    local dx = self.x2 - x1
    local dy = self.y2 - y1

    local perp_x = self.perp_x
    local perp_y = self.perp_y

    local freq = self.frequency
    local amp  = self.amplitude
    local t0   = self.time * self.speed

    for i = 0, seg do
        local t = i / seg
        local px = x1 + dx * t
        local py = y1 + dy * t

        local offset = math.sin(t * freq * tpi - t0) * amp

        points[p]     = px + perp_x * offset
        points[p + 1] = py + perp_y * offset

        p = p + 2
    end

    love.graphics.setColor(self.color)
    local last = love.graphics.getLineWidth()
    love.graphics.setLineWidth(self.lineWidth)

    love.graphics.line(points)

    love.graphics.setLineWidth(last)
end

return UISquiglyLine