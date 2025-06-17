local sharedBackground = Class:extend("sharedBackground")

function sharedBackground:new(image, brightness, size)
    self.image = image
    self.baseSizeX, self.baseSizeY = baseScreenRatio.x/self.image:getWidth(), baseScreenRatio.y/self.image:getHeight()
    self.size = size or 1
    self.brightness = brightness or 1
end

function sharedBackground:update(dt)
end

function sharedBackground:setSize(size)
    self.size = size or 1
end

function sharedBackground:changeBrightness(brightness)
    self.brightness = brightness or 1
end

function sharedBackground:bump(intensity, speed, tweenType)
    

end

function sharedBackground:draw()
end

return sharedBackground