local sharedBackground = Class:extend("sharedBackground")

local bumpTween
function sharedBackground:new(imagePath, dimness, size)
    self.image = (type(imagePath) == "string" and love.graphics.newImage(imagePath)) or imagePath
    if self.image then
        self.baseSizeX, self.baseSizeY = baseScreenRatio.x/self.image:getWidth(), baseScreenRatio.y/self.image:getHeight()
    else
        self.baseSizeX, self.baseSizeY = baseScreenRatio.x, baseScreenRatio.y
    end
    self.size = size or 1
    self.originalSize = self.size
    self.dimness = dimness or 0
    self.rotation = 0 -- might be useful later idk
    self.x, self.y = baseScreenRatio.x / 2, baseScreenRatio.y / 2
end

function sharedBackground:update(dt)
end

function sharedBackground:setSize(size)
    self.size = size or 1
end

function sharedBackground:changeDimness(dimness, time, func)
    local doCallback = function() -- will i ever use this feature?   no.   is it useful?   probably not.   do i wanna add it anyway?   yeah lol 
        if func then func() end
    end
    if time then -- we must be trying to tween the dimness
        Timer.tween(time, self, {dimness = dimness}, "linear", function() doCallback() end)
        return
    end
    self.dimness = dimness or 1
end

function sharedBackground:bump(intensity, speed, tweenType)
    self.size = self.size + intensity
    speed = speed or 0.5
    tweenType = tweenType or "out-quad"
    if bumpTween then
        Timer.cancel(bumpTween)
    end
    bumpTween = Timer.tween(self, {size = self.originalSize}, speed, tweenType)
end

function sharedBackground:draw()
    love.graphics.setColor(1,1,1,1)
    if not dontShowBG and self.image then
        love.graphics.draw(self.image, self.x, self.y, self.rotation, self.baseSizeX * self.size, self.baseSizeY * self.size, self.image:getWidth()/2, self.image:getHeight()/2)
    else
        love.graphics.push()
        love.graphics.translate(self.baseSizeX/2, self.baseSizeY/2)
        love.graphics.rotate(self.rotation)
        love.graphics.scale(self.size, self.size)
        love.graphics.rectangle("fill", self.x, self.y, self.baseSizeX, self.baseSizeY, 0, 0)
        love.graphics.pop()
    end
    love.graphics.setColor(0,0,0,self.dimness)
    love.graphics.rectangle("fill", 0, 0, baseScreenRatio.x, baseScreenRatio.y)
    love.graphics.setColor(1,1,1,1)
end

return sharedBackground