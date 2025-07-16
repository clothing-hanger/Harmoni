local sharedBackground = Class:extend("sharedBackground")

local bumpTween

function sharedBackground:new(imagePath, dimness, size)
    -- Load image if a string path is provided, else assume image object
    if type(imagePath) == "string" then
        self.image = love.graphics.newImage(imagePath)
    else
        self.image = imagePath
    end

    if self.image then
        self.baseSizeX = baseScreenRatio.x / self.image:getWidth()
        self.baseSizeY = baseScreenRatio.y / self.image:getHeight()
    else
        self.baseSizeX = baseScreenRatio.x
        self.baseSizeY = baseScreenRatio.y
    end

    self.size = size or 1
    self.originalSize = self.size
    self.dimness = dimness or 0
    self.rotation = 0
    self.x = baseScreenRatio.x / 2
    self.y = baseScreenRatio.y / 2
end

function sharedBackground:update(dt)
end

function sharedBackground:setSize(size)
    self.size = size or 1
end

function sharedBackground:changeDimness(targetDimness, time, callback)
    if time then
        Timer.tween(time, self, {dimness = targetDimness or 1}, "linear", callback)
    else
        self.dimness = targetDimness or 1
        if callback then callback() end
    end
end

function sharedBackground:bump(intensity, speed, tweenType)
    self.size = self.size + (intensity or 0)
    speed = speed or 0.5
    tweenType = tweenType or "out-quad"

    if bumpTween then
        Timer.cancel(bumpTween)
    end

    bumpTween = Timer.tween(self, {size = self.originalSize}, speed, tweenType)
end

function sharedBackground:draw()
    love.graphics.setColor(1, 1, 1, 1)

    if not dontShowBG and self.image then
        love.graphics.draw(
            self.image,
            self.x, self.y,
            self.rotation,
            self.baseSizeX * self.size,
            self.baseSizeY * self.size,
            self.image:getWidth() / 2,
            self.image:getHeight() / 2
        )
    else
        love.graphics.push()
        love.graphics.translate(self.x, self.y)
        love.graphics.rotate(self.rotation)
        love.graphics.scale(self.size, self.size)
        love.graphics.rectangle("fill", -self.baseSizeX / 2, -self.baseSizeY / 2, self.baseSizeX, self.baseSizeY)
        love.graphics.pop()
    end

    -- Draw dimness overlay
    love.graphics.setColor(0, 0, 0, self.dimness)
    love.graphics.rectangle("fill", 0, 0, baseScreenRatio.x, baseScreenRatio.y)
    love.graphics.setColor(1, 1, 1, 1)
end

return sharedBackground
