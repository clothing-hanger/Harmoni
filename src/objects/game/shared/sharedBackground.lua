local sharedBackground = Class:extend("sharedBackground")

local bumpTween
function sharedBackground:new(imagePath, dimness, size)
    self.image = love.graphics.newImage(imagePath)
    self.baseSizeX, self.baseSizeY = baseScreenRatio.x/self.image:getWidth(), baseScreenRatio.y/self.image:getHeight()
    self.size = size or 1
    self.originalSize = self.size
    self.dimness = dimness or 1
    self.rotation = 0 -- might be useful later idk
end

function sharedBackground:update(dt)
end

function sharedBackground:setSize(size)
    self.size = size or 1
end

function sharedBackground:changeDimness(dimness)
    self.dimness = dimness or 1
end

function sharedBackground:bump(intensity, speed, tweenType)
    self.size = self.size + intensity
    local speed = speed or 0.5
    local tweenType = tweenType or "out-quad"
    if bumpTween then
        Timer.cancel(bumpTween)
    end
    bumpTween = Timer.tween(self, {size = self.originalSize}, speed, tweenType)
end 


function sharedBackground:draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.image, 0, 0, self.rotation, self.baseSizeX * self.size, self.baseSizeY * self.size, self.image:getWidth()/2, self.image:getHeight()/2)
    love.graphics.setColor(0,0,0,self.dimness)
    love.graphics.rectangle("fill", 0, 0, baseScreenRatio.x, baseScreenRatio.y)
end

return sharedBackground