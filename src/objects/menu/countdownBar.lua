local countdownBar = Class:extend("countdownBar")

function countdownBar:new(x,y,width,height,time)
    self.x, self.y = x,y 
    self.width, self.height = width,height 
    self.time = time
    self.timeLeft = self.time
    self.paused = false
    self.complete = false
end

function countdownBar:update(dt)
    if not self.paused then self:countdown(dt) end
    if self.timeLeft == 0 then self.complete = true end
end

function countdownBar:countdown(dt)
    self.timeLeft = math.max(self.timeLeft - dt, 0)
end

function countdownBar:draw()
    -- first we will draw the right side 
    local width = (self.width/2)*(self.timeLeft/self.time) -- divide by 2 cuz the bar extends outward from center 
    love.graphics.rectangle("fill", self.x, self.y, width, self.height)

    -- first we will draw the left side 
    width = -((self.width/2)*(self.timeLeft/self.time) )-- divide by 2 cuz the bar extends outward from center 
    love.graphics.rectangle("fill", self.x, self.y, width, self.height)
end

return countdownBar