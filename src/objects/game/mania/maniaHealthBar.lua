local maniaHealthBar = Class:extend("maniaHealthBar")

function maniaHealthBar:new(x,y,width,height,health,max)
    self.x,self.y = x or 0, y or 0
    self.width,self.height = width or 10, height or 30 
    self.health = health

    self.max = max or 0.95  -- i really like the health bar having this it looks nice
    self.printableHealth = self.health

    self.line = UIsquiglyLine(self.x, self.y, self.x, self.y-self.height,4,5,50,1,self.width)
end

local maxHealthLerpSpeed = 10
local printableHealthLerpSpeed = 10

function maniaHealthBar:update(dt)
    self.line:update(dt)

    if self.health > self.max then
        self.health = self.health + (self.max - self.health) * (1 - math.exp(-dt * maxHealthLerpSpeed))
    end

    self.printableHealth = self.printableHealth + (self.health - self.printableHealth) * (1 - math.exp(-dt * printableHealthLerpSpeed))
end

function maniaHealthBar:changeHealth(amount)
    self.health = self.health + amount
    if self.health > 1 then self.health = 1 elseif self.health < 0 then self.health = 0 end
end


function maniaHealthBar:draw()
    love.graphics.setColor(1,1,1,0.45)
    love.graphics.stencil(function()
    love.graphics.rectangle("fill", self.x-self.width,((self.y-self.height-10)), self.x+self.width,(self.y-(self.height*self.printableHealth))+10)
    end, "replace", 1)

    love.graphics.setStencilTest("notequal", 1)

    self.line:draw()
        love.graphics.setStencilTest()
    love.graphics.setColor(1,1,1,1)

    love.graphics.circle("fill", self.x, self.y, self.width)


end


return maniaHealthBar