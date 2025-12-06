local buttonSlideOut = Class:extend("buttonSlideOut")

function buttonSlideOut:new(x, y, width, height, text, func, cornerRadius, color1, color2, image, animate)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.text = text
    self.func = func or function() end
    self.hovered = false

    self.animate = animate
    self.image = image

    self.color1 = color1 or {1,1,1}
    self.color2 = color2 or {1,1,1}

    self.colorIconOffset = 1.5

    self.iconColor = {self.color2[1]/self.colorIconOffset, self.color2[2]/self.colorIconOffset, self.color2[3]/self.colorIconOffset}

    self.cornerRadius = cornerRadius or 7
    self.debug = false
    self.radius = height

    self.slideInitialWidth = self.radius
    self.slideWidth = self.radius

    self.activeTweens = {}

    self.tweenDuration = 1.5
    self.tweenEasingType = "out-elastic"
    self.outElasticFunc = Ease["out-elastic"] or Ease.linear
    self.linearFunc = Ease["linear"]

    self.scale = 1
    self.scaleTweens = {}
    self.pressDuration = 0.15
    self.pressEasing = Ease["out-expo"]

    self.isPressed = false
    self.wasPressedInside = false

    self.imageX,self.imageY = self.x+self.radius/2, self.y+self.radius/2
end

function buttonSlideOut:update(dt)
    if self.slideWidth < self.slideInitialWidth then self.slideWidth = self.slideInitialWidth end

    self.hovered = mouseOver(self)

    self.colorIconOffsetTarget = self.hovered and 0 or 0.65
    self.colorIconOffset = self.colorIconOffset + (self.colorIconOffsetTarget - self.colorIconOffset) * 10 * dt
    self.iconColor = {self.color2[1]*self.colorIconOffset, self.color2[2]*self.colorIconOffset, self.color2[3]*self.colorIconOffset}

    local targetWidth = self.hovered and self.width or self.slideInitialWidth

    if love.mouse.isDown(1) then
        if self.hovered and not self.isPressed then
            self.isPressed = true
            self.wasPressedInside = true
            self:startPressTween()
        end
    else
        if self.isPressed then
            if self.wasPressedInside and self.hovered then
                self:onClick()
            end
            self.isPressed = false
            self.wasPressedInside = false
        end
    end

    if (#self.activeTweens == 0 or self.activeTweens[1].targetWidth ~= targetWidth) then
        self:startTween(targetWidth)
    end

    for i = #self.activeTweens, 1, -1 do
        local tween = self.activeTweens[i]
        tween.time = tween.time + dt
        local t = math.min(tween.time / tween.duration, 1)
        self.slideWidth = tween.startWidth + (tween.targetWidth - tween.startWidth) * Ease[tween.type](t)
        if t >= 1 then
            table.remove(self.activeTweens, i)
        end
    end

    for i = #self.scaleTweens, 1, -1 do
        local tween = self.scaleTweens[i]
        tween.time = tween.time + dt

        local t = math.max(0, tween.time - (tween.delay or 0)) / tween.duration
        if t < 0 or t > 1 then
            if t >= 1 then
                self.scale = tween.to
                table.remove(self.scaleTweens, i)
            end
        else
            self.scale = tween.from + (tween.to - tween.from) * tween.easing(t)
        end
    end

    if self.thingies then
        for _, Thingy in ipairs(self.thingies) do
          --  love.graphics.draw(self.image, Thingy.x+self.x, Thingy.y+self.y)
          Thingy.y = Thingy.y-Thingy.speed*dt
        end
    end

    if self.iconYmove then self.imageY = self.imageY - 1000*dt end
end


function buttonSlideOut:animateFill(thingies)
    self.thingies = {}
    for i = 1,thingies do
        table.insert(self.thingies,{x = love.math.random(1,self.width), y = love.math.random(self.height,500), speed = love.math.random(1000,1200)})
    end

    self.iconYmove = true -- horrid but i do not care
end

function buttonSlideOut:startTween(targetWidth)
    self.activeTweens = {}
    local type,time
    if targetWidth == self.slideInitialWidth then type = "out-elastic";time = 0 else type = "out-elastic"; time = 0 end

    table.insert(self.activeTweens, {
        startWidth = self.slideWidth,
        targetWidth = targetWidth,
        duration = self.tweenDuration,
        time = time,
        type = type
    })
end

function buttonSlideOut:startPressTween()
    self.scaleTweens = {}

    table.insert(self.scaleTweens, {
        from = self.scale,
        to = 0.9,
        duration = self.pressDuration * 0.5,
        time = 0,
        easing = self.pressEasing
    })

    table.insert(self.scaleTweens, {
        from = 0.9,
        to = 1,
        duration = self.pressDuration * 0.5,
        time = 0,
        easing = self.pressEasing,
        delay = self.pressDuration * 0.5
    })
end

function buttonSlideOut:onClick()
    self.func()
    self:startPressTween()
    if self.animate == "fill" then self:animateFill(10) end
end

local function remap(value, oldMin, oldMax, newMin, newMax)
    return (value - oldMin) / (oldMax - oldMin) * (newMax - newMin) + newMin
end

function buttonSlideOut:draw()
    if self.debug then
        love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
        love.graphics.print(tostring(self.hovered), self.x + 5, self.y + 5)
    end

    local cx, cy = self.x + self.width / 2, self.y + self.height / 2
    love.graphics.push()
    love.graphics.translate(cx, cy)
  --  love.graphics.scale(self.scale)
    love.graphics.translate(-cx, -cy)

    local function stencilShape()
        love.graphics.rectangle("fill", self.x, self.y, self.slideWidth, self.height, self.radius/2, self.radius/2)
    end
    love.graphics.stencil(stencilShape, "replace", 1)
    love.graphics.setStencilTest("greater", 0)

    love.graphics.setColor(self.color1)
    drawMultiGradientRect(
        self.x, self.y, self.slideWidth, self.height,
        {
            {self.color1[1], self.color1[2], self.color1[3], 1},
            {self.color2[1], self.color2[2], self.color2[3], 1},
        }
    )
    
    if self.hovered then
        local mouseX = toCanvasCoords(love.mouse.getPosition())
        local remappedX = remap(mouseX, self.x, self.x + self.slideWidth, 0, 1)

        local gradientWidth = self.slideWidth
        local gradientX = self.x + (remappedX * self.slideWidth) - (gradientWidth / 2)
        drawMultiGradientRect(
            gradientX, self.y, gradientWidth, self.height,
            {
                {self.color1[1], self.color1[2], self.color1[3], 0},
                {self.color2[1] * 0.75, self.color2[2] * 0.75, self.color2[3] * 0.75, 0.5},
                {self.color1[1], self.color1[2], self.color1[3], 0}
            }
        )
    end

    love.graphics.setColor(self.iconColor)
    if self.image then love.graphics.draw(self.image, self.imageX, self.imageY, nil, self.radius/self.image:getWidth()*0.8, self.radius/self.image:getHeight()*0.8, self.image:getWidth()/2, self.image:getHeight()/2) end
    if self.thingies then
        for i, Thingy in ipairs(self.thingies) do
          --  love.graphics.draw(self.image, Thingy.x+self.x, Thingy.y+self.y)
            love.graphics.draw(self.image, Thingy.x+self.x+self.radius/2, Thingy.y+self.y+self.radius/2, nil, self.radius/self.image:getWidth()*0.8, self.radius/self.image:getHeight()*0.8, self.image:getWidth()/2, self.image:getHeight()/2) 
        end
    end
    local textColorPercent = self.slideWidth / self.width
    local textColor = {
        self.color1[1] + (0 - self.color1[1]) * textColorPercent,
        self.color1[2] + (0 - self.color1[2]) * textColorPercent,
        self.color1[3] + (0 - self.color1[3]) * textColorPercent
    }

    love.graphics.setColor(textColor)
    love.graphics.setFont(SkinHandler:getFont("Menu", 50))

    local textX = self.x + self.slideInitialWidth
    local textY = self.y + self.height / 2 - love.graphics.getFont():getHeight() / 2
    love.graphics.printf(self.text, textX, textY, self.width, "left")
    love.graphics.pop()
    love.graphics.setStencilTest()
end

return buttonSlideOut
