local buttonSlideOut = Class:extend("buttonSlideOut")

function buttonSlideOut:new(x, y, width, height, text, func, cornerRadius, color1, color2)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.text = text
    self.func = func or function() end
    self.hovered = false

    self.color1 = color1 or {1,1,1}
    self.color2 = color2 or {1,1,1}

    self.cornerRadius = cornerRadius or 7
    self.debug = false

    self.slideInitialWidth = self.width * 0.05
    self.slideWidth = self.slideInitialWidth

    self.activeTweens = {}

    self.tweenDuration = 0.3
    self.tweenEasingType = "out-quad"
    self.easeFunc = Ease[self.tweenEasingType] or Ease.linear

    self.scale = 1
    self.scaleTweens = {}
    self.pressDuration = 0.15
    self.pressEasing = Ease["out-quad"]

    self.isPressed = false
    self.wasPressedInside = false

end

function buttonSlideOut:update(dt)
    self.hovered = mouseOver(self)

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
        self.slideWidth = tween.startWidth + (tween.targetWidth - tween.startWidth) * self.easeFunc(t)
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

end

function buttonSlideOut:startTween(targetWidth)
    self.activeTweens = {}

    table.insert(self.activeTweens, {
        startWidth = self.slideWidth,
        targetWidth = targetWidth,
        duration = self.tweenDuration,
        time = 0
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
end

function buttonSlideOut:draw()
    if self.debug then
        love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
        love.graphics.print(tostring(self.hovered), self.x + 5, self.y + 5)
    end

    local cx, cy = self.x + self.width / 2, self.y + self.height / 2
    love.graphics.push()
    love.graphics.translate(cx, cy)
    love.graphics.scale(self.scale)
    love.graphics.translate(-cx, -cy)

    local function stencilShape()
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, self.cornerRadius, self.cornerRadius)
    end
    love.graphics.stencil(stencilShape, "replace", 1)
    love.graphics.setStencilTest("greater", 0)

    if math.abs(self.slideWidth - self.slideInitialWidth) < 2 then
        love.graphics.setColor(self.color1)
        love.graphics.rectangle("fill", self.x, self.y, self.slideWidth, self.height, self.cornerRadius, self.cornerRadius)
    else
        drawGradientRect(
            self.x, self.y, self.slideWidth, self.height,
            {self.color1[1], self.color1[2], self.color1[3], 1},
            {self.color2[1], self.color2[2], self.color2[3], 1},
            false)
    end

    local textColorPercent = self.slideWidth / self.width
    local textColor = {
        self.color1[1] + (0 - self.color1[1]) * textColorPercent,
        self.color1[2] + (0 - self.color1[2]) * textColorPercent,
        self.color1[3] + (0 - self.color1[3]) * textColorPercent
    }
    love.graphics.setColor(textColor)
    love.graphics.setFont(SkinHandler:getFont("Menu Extra Large"))

    local textX = self.x + self.slideInitialWidth * 2
    local textY = self.y + self.height / 2 - love.graphics.getFont():getHeight() / 2
    love.graphics.printf(self.text, textX, textY, self.width, "left")

    love.graphics.setStencilTest()
    love.graphics.pop()
end


return buttonSlideOut
