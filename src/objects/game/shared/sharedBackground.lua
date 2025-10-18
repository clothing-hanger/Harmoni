
local sharedBackground = Class:extend("sharedBackground")

local bumpTween

function sharedBackground:new(imagePath, dimness, size)
    if type(imagePath) == "string" then  -- what was this even for? im not gonna edit it cuz i dont know why its here
        if love.filesystem.getInfo(imagePath, "file") then self.image = love.graphics.newImage(imagePath) else
        self.image = SkinHandler:getImage("Menu", "Background") end
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

    self.activeTweens = {}
end

function sharedBackground:update(dt)
    for i = #self.activeTweens, 1, -1 do
        local tween = self.activeTweens[i]
        if tween.update(dt) then
            if tween.callback then tween.callback() end
            table.remove(self.activeTweens, i)
        end
    end
end

function sharedBackground:setSize(size)
    self.size = size or 1
end

function sharedBackground:changeDimness(targetDimness, time, callback)
    targetDimness = targetDimness or 1
    if not time then
        self.dimness = targetDimness
        if callback then callback() end
        return
    end

    local start = self.dimness
    local change = targetDimness - start
    local t = 0
    local easing = Ease.linear

    table.insert(self.activeTweens, {
        update = function(dt)
            t = t + dt
            local progress = math.min(t / time, 1)
            self.dimness = start + change * easing(progress)
            return progress >= 1
        end,
        callback = callback
    })
end

function sharedBackground:bump(intensity, speed, tweenType)
    intensity = intensity or 0
    speed = speed or 0.5
    tweenType = tweenType or "out-quad"

    self.size = self.size + intensity
    local start = self.size
    local target = self.originalSize
    local change = target - start
    local t = 0
    local easing = Ease[tweenType] or Ease.linear

    -- remove existing bump tween
    for i = #self.activeTweens, 1, -1 do
        if self.activeTweens[i].tag == "bump" then
            table.remove(self.activeTweens, i)
        end
    end

    table.insert(self.activeTweens, {
        tag = "bump",
        update = function(dt)
            t = t + dt
            local progress = math.min(t / speed, 1)
            self.size = start + change * easing(progress)
            return progress >= 1
        end
    })
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
    love.graphics.setColor(1, 1, 1)
end

return sharedBackground
