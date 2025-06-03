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

    self.rotateSpeed = 1000
    self.visible = true
    self.scale = 0.5
    self.tgtScale = 0.5

    self.image = love.graphics.newImage("images/UI/cursor.png")

    self.weight = 5
    self.weightAngle = 0

    self.debug = false
end

function cursor:update(dt)
    self.x, self.y = love.mouse.getPosition()

    if self.mouseDownX then
        local dx = self.x - self.mouseDownX
        local dy = self.y - self.mouseDownY
        local lengthSquared = dx * dx + dy * dy

        if not self.rotating and lengthSquared > 20 then
            self.rotating = true
        end

        if self.rotating then
            local angle = math.deg(math.atan2(-dx, dy)) + 24.3

            local delta = (angle - self.angle) % 360
            if delta < -180 then delta = delta + 360 end
            if delta > 180 then delta = delta - 360 end

            angle = self.angle + delta
            self.targetAngle = angle
        end
    end

    local delta = self.targetAngle - self.angle
    if math.abs(delta) > 0.01 then
        local t = math.min(dt * self.rotateSpeed / 150, 1)
        self.angle = self.angle + delta * t
    else
        self.angle = self.targetAngle
    end

    if self.tgtScale ~= self.scale then
        local scaleDelta = (self.tgtScale - self.scale) * dt * 25
        self.scale = self.scale + scaleDelta

        if math.abs(self.tgtScale - self.scale) < 0.01 then
            self.scale = self.tgtScale
        end
    end

    if self.mouseDownX then
        return
    end

    local weightDelta = (self.x - self.prevX) * 0.08
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

    self.prevX, self.prevY = self.x, self.y
end

function cursor:draw()
    if not self.visible then return end

    love.graphics.push()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(
        self.image,
        self.x, self.y,
        math.rad(self.angle + self.weightAngle),
        self.scale, self.scale
    )
    love.graphics.pop()

    if self.debug then
        local lastColor = {love.graphics.getColor()}
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
        love.graphics.setColor(lastColor)
    end
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
    self.tgtScale = 0.45
end

function cursor:scaleUp()
    self.tgtScale = 0.5
end

return cursor
