local slider = settingsbaseshitthingy:extend("slider")

local function remap(value, oldMin, oldMax, newMin, newMax)
    return (value - oldMin) / (oldMax - oldMin) * (newMax - newMin) + newMin
end

local function clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

function slider:new(name, val, min, max)
    self.name = name
    self.val = val
    self.min = min
    self.max = max

    self.dragging = false

    self.font = SkinHandler:getFont("Menu", 28)

    self.x = 0
    self.y = 0
    self.lineWidth = 1000
end

function slider:updateValue(mouseX)

end

function slider:mousepressed(x, y, button)
end

function slider:mousemoved(x, y)
    if self.dragging then
        self:updateValue(x)
    end
end

function slider:mousereleased(x, y, button)
    if button == 1 then
        self.dragging = false
    end
end

function slider:draw(x, y)
    x = x or 0
    y = y or 0

    self.x = x
    self.y = y

    love.graphics.setFont(self.font)

    local lineY = y + self.font:getHeight() + 20

    love.graphics.print(self.name, x, y)

    local valueText = string.format("%.2f", self.val)
    love.graphics.print(valueText, x + self.lineWidth + 30, y)

    love.graphics.line(x, lineY, x + self.lineWidth, lineY)

    local circleX = remap(self.val, self.min, self.max, x, x + self.lineWidth)

    love.graphics.circle("fill", circleX, lineY, 15)

    love.graphics.setColor(0, 0, 0)
    love.graphics.circle("line", circleX, lineY, 15)
    love.graphics.setColor(1, 1, 1)

    return 100
end

return slider