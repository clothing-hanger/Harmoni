local newAlert = Class:extend("newAlert")    -- why was i even thinking about adding this? never fucking mind lmfao these are annoying to see 

function newAlert:new(x,y)
    self.x, self.y = x or 0,y or 0
    self.radius = 15
    self.pulseRadiusExpand = 25
    self.pulseRadius = self.radius
    self.pulseAlpha = 1
    self.pulseTimer = 1
    self.color = {0,1,1}
    self:pulse()
end

function newAlert:pulse()
    self.pulseRadius = self.radius
    self.pulseAlpha = 1
    if self.pulseTween then Timer.cancel(self.pulseTween) end
    self.pulseTween = Timer.tween(self.pulseTimer, self, {pulseRadius = self.pulseRadius+self.pulseRadiusExpand, pulseAlpha = 0}, "out-quad", function() self:pulse() end)
end

function newAlert:update(dt)
end

function newAlert:draw()
    love.graphics.setColor(self.color)
    love.graphics.circle("fill", self.x, self.y, self.radius)
    love.graphics.setColor(self.color[1],self.color[2],self.color[3],self.pulseAlpha)
    love.graphics.circle("fill", self.x, self.y, self.pulseRadius)
    love.graphics.setColor(1,1,1,1)
end

return newAlert