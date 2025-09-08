local UISquigleCircle = Class:extend("UISquigleCircle")

function UISquigleCircle:new(mode, x, y, radius, amplitude, frequency, lineThickness, color)

    debug = false
    self.mode, self.x, self.y, self.radius, self.amplitude, self.frequency, self.lineThickness, self.color = mode, x, y, radius, amplitude, frequency, lineThickness, color
    self.points = {}
    self.rotation = 0
    local segments = 200  -- this should probably be an argument tbh 

    for i = 1, segments do
        local angle = (i / segments) * (2 * math.pi)
        local r =self.radius + math.sin(angle *   self.frequency + math.pi/ 2) * self.amplitude
        local pointX, pointY = math.cos(angle)*r, math.sin(angle)*r


        table.insert(self.points, pointX)
        table.insert(self.points, pointY)
    end

    table.insert(self.points, self.points[1])    -- adding these points did not fix the thing they were supposed to but im leaving yhem anyway 
table.insert(self.points, self.points[2]) 
end

function UISquigleCircle:update(dt)
    self.rotation = self.rotation+ math.sin(love.timer.getTime())*0.01
end

function UISquigleCircle:draw()
    love.graphics.push()
    

    love.graphics.setLineWidth(self.lineThickness or 1)
    -- Translate to the scaled position (self.x * 2, self.y * 2)
    love.graphics.translate(self.x * 2, self.y * 2)
    love.graphics.rotate(math.rad(self.rotation))
    love.graphics.setColor(self.color)
    love.graphics.polygon(self.mode or "line", self.points)
    if self.debug then 
        love.graphics.setColor(1,0,0)
        love.graphics.circle("line",0,0,self.radius)

        love.graphics.setColor(1,1,1)
    end
    love.graphics.setColor(1,1,1)
    love.graphics.pop()
end

return UISquigleCircle