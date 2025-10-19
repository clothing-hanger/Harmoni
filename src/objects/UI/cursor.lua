local cursor = Class:extend("MenuCursor")

local function lerp(a, b, t)
    return a + (b - a) * t
end

function cursor:new()
    self.x, self.y = love.mouse.getPosition()
    self.prevX, self.prevY = self.x, self.y
    self.mouseDownX, self.mouseDownY = nil, nil
    self.rotating = false

    self.angle = 0
    self.targetAngle = 0
    self.angularVelocity = 0
    self.angularAcceleration = 0

    self.rotateSpeed = 15
    self.damping = 6
    self.followSpeed = 10

    self.visible = true
    self.scale = 0.35
    self.tgtScale = 0.35

    self.mouseDownFloatSpeed = 5

    self.image = love.graphics.newImage("images/UI/cursor.png")

    self.weight = 100
    self.weightAngle = 0

    self.fadeOutWhenIdle = false
    self.fadeOutTime = 0.5
    self.fadeOutTimer = 0
    self.fadeOutAlpha = 1
    self.didMove = false

    self.debug = false
end

function cursor:update(dt)
    self.x, self.y = love.mouse.getPosition()
    if self.x ~= self.prevX or self.y ~= self.prevY then
        self.didMove = true
        self.fadeOutTimer = 0
        self.fadingBackIn = true
    else
        self.didMove = false
    end

    if self.fadeOutWhenIdle and self.angle == 0 and self.angularVelocity == 0 then
        if not self.didMove and not self.fadingBackIn then
            self.fadeOutTimer = self.fadeOutTimer + dt
            if self.fadeOutTimer >= self.fadeOutTime then
                self.fadeOutAlpha = math.max(0, 1 - (self.fadeOutTimer - self.fadeOutTime) / self.fadeOutTime)
            end
        elseif self.fadingBackIn then
            self.fadeOutAlpha = self.fadeOutAlpha + dt * 5
            if self.fadeOutAlpha >= 1 then
                self.fadeOutAlpha = 1
                self.fadingBackIn = false
            end
        end
    end

    self.didMove = false

    if self.mouseDownX then
        local dx = self.x - self.mouseDownX
        local dy = self.y - self.mouseDownY
        local lengthSquared = dx * dx + dy * dy

        if not self.rotating and lengthSquared > 20 then
            self.rotating = true
        end

        if self.rotating then
            local angle = math.deg(math.atan2(-dx, dy)) + 24.3
            local diff = (angle - self.angle + 180) % 360 - 180
            self.targetAngle = self.angle + diff

            local t = math.min(dt * self.followSpeed, 1)
            self.angle = self.angle + diff * t

            self.angularVelocity = 0
            self.angularAcceleration = 0
        else
            self.angularVelocity = 0
            self.angularAcceleration = 0
        end

        self.mouseDownX = lerp(self.mouseDownX, self.x, dt * self.mouseDownFloatSpeed)
        self.mouseDownY = lerp(self.mouseDownY, self.y, dt * self.mouseDownFloatSpeed)
    else
        local diff = (0 - self.angle)

        self.angularAcceleration = self.rotateSpeed * diff

        self.angularVelocity = self.angularVelocity + self.angularAcceleration * dt
        self.angularVelocity = self.angularVelocity * (1 - self.damping * dt)

        self.angle = self.angle + self.angularVelocity * dt

        if math.abs(diff) < 0.5 and math.abs(self.angularVelocity) < 0.5 then
            self.angle = 0
            self.angularVelocity = 0
            self.angularAcceleration = 0
        end
    end

    if self.tgtScale ~= self.scale then
        local scaleDelta = (self.tgtScale - self.scale) * dt * 25
        self.scale = self.scale + scaleDelta

        if math.abs(self.tgtScale - self.scale) < 0.01 then
            self.scale = self.tgtScale
        end
    end

    local weightDelta = (self.x - self.prevX) * 0.08
    self.prevX, self.prevY = self.x, self.y
    if self.mouseDownX then
        return
    end

    self.weightAngle = self.weightAngle + weightDelta

    if self.weightAngle > 360 then
        self.weightAngle = self.weightAngle - 360
    elseif self.weightAngle < 0 then
        self.weightAngle = self.weightAngle + 360
    end

    if self.weightAngle > 180 then
        self.weightAngle = self.weightAngle - 360
    elseif self.weightAngle < -180 then
        self.weightAngle = self.weightAngle + 360
    end

    if math.abs(self.weightAngle) < 0.01 then
        self.weightAngle = 0
    else
        self.weightAngle = lerp(self.weightAngle, 0, dt * 10)
        if math.abs(self.weightAngle) < 0.01 then
            self.weightAngle = 0
        end
        if self.weightAngle > 180 then
            self.weightAngle = self.weightAngle - 360
        elseif self.weightAngle < -180 then
            self.weightAngle = self.weightAngle + 360
        end
    end
end

function cursor:getPosition()
    local cx, cy = toCanvasCoords(self.x, self.y)
    return cx, cy, (self.dx or 0), (self.dy or 0)
end

function cursor:isMouseDown()
    return self.mouseDownX ~= nil
end

function cursor:getYDirection()
    if not self:isMouseDown() then
        return 0
    end

    local dy = self.y - self.mouseDownY
    if dy > 0 then
        return 1
    elseif dy < 0 then
        return -1
    else
        return 0
    end
end

function cursor:draw()
    if not self.visible then return end
    local lastColor = {love.graphics.getColor()}

    love.graphics.push()
    love.graphics.setColor(1, 1, 1, self.fadeOutAlpha)
    love.graphics.draw(
        self.image,
        self.x, self.y,
        math.rad(self.angle + self.weightAngle),
        self.scale, self.scale
    )
    love.graphics.pop()

    if self.debug then
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.circle("line", self.x, self.y, 5)
        love.graphics.print(string.format("Angle: %.2f, WeightAngle: %.2f", self.angle, self.weightAngle), self.x + 10, self.y - 10)
        love.graphics.print(string.format("Scale: %.2f", self.scale), self.x + 10, self.y + 10)

        if self.mouseDownX then
            love.graphics.print(string.format("Mouse Down: (%.2f, %.2f)", self.mouseDownX, self.mouseDownY), self.x + 10, self.y + 30)
            love.graphics.setColor(0, 1, 0, 1)
            love.graphics.line(self.mouseDownX, self.mouseDownY, self.x, self.y)
            love.graphics.circle("line", self.mouseDownX, self.mouseDownY, 5)
        end
    end

    love.graphics.setColor(lastColor)
end

function cursor:mousepressed(x, y, button)
    if button == 1 then
        self.mouseDownX, self.mouseDownY = x, y

        self:scaleDown()
    end
end

function cursor:mousereleased(x, y, button)
    if button == 1 then
        self.mouseDownX, self.mouseDownY = nil, nil
        self.rotating = false

        self.targetAngle = 0

        self:scaleUp()
    end
end

function cursor:scaleDown()
    self.tgtScale = 0.3
end

function cursor:scaleUp()
    self.tgtScale = 0.35
end

return cursor
