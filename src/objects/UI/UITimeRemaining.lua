local UITimeRemaining = Class:extend("UITimeRemaining")

function UITimeRemaining:new(startTime, endTime, x,y,widht,parent,lineWidth,speed,amplitude,frequency)
    self.parent = parent or error("Time remaining bar created with no parent   (argument 6)")
    self.startTime = startTime or 0 -- why am i even adding this as an argument
    self.endTime = endTime or error("Time remaining bar created with no endTime  (argument 2)")
    self.x, self.y = x or 0, y or 0
    self.width = widht or 50
    self.lineWidth = lineWidth or 1
    self.speed = speed or 5
    self.amplitude = amplitude or 10
    self.frequency = frequency or 10

    self.startPos, self.endPos = {self.x,self.y}, {self.x+self.width,self.y}
    self.lengthInSeconds = self.endTime
    self.percent = 0

    self.timer = 0

    self.squiglyLine = UIsquiglyLine(self.x, self.y, self.width+self.x, self.y, self.frequency, self.amplitude, 1000, self.speed, self.lineWidth)

    self.gradient = createMultiGradientRectMesh(self.x,self.y-200, self.width, 300, {{1,1,1}, {61/255,0,100/255}})
end

function UITimeRemaining:update(dt, progress)
    self.percent = progress
    self.timer = (self.timer + dt) -- get the time in seconds

    self.squiglyLine:update(dt)
end

function UITimeRemaining:getHeadData() -- x, y, radius
    return self.width*self.percent, self.y, 15
end

function UITimeRemaining:draw()
    love.graphics.setColor(1,1,1)

    love.graphics.stencil(function()
        self.squiglyLine:draw()
    end, "replace", 1)
    love.graphics.setStencilTest("equal", 1)

    love.graphics.setScissor((self.width*self.percent)-self.width,self.y-100,self.width,200)
    love.graphics.draw(self.gradient)

    love.graphics.setScissor()


    love.graphics.setStencilTest()

    -- draw the capsule thingy 
    love.graphics.setColor(0,0,0)
    love.graphics.circle("fill", self.width*self.percent, self.y, 15)
    love.graphics.setColor(1,1,1)
end

return UITimeRemaining