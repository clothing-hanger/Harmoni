local slider = settingsbaseshitthingy:extend("slider")

local function remap(value, oldMin, oldMax, newMin, newMax)
    return (value - oldMin) / (oldMax - oldMin) * (newMax - newMin) + newMin
end

local function clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

local function distance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
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
    self.val = clamp(remap(mouseX, self.x, self.x+self.lineWidth, self.min, self.max), self.min, self.max)
end

function slider:mousepressed(x, y, button)
    if button ~= 1 then return end

    local circleX = remap(self.val, self.min, self.max, self.x, self.x + self.lineWidth)
    local lineY = self.y + self.font:getHeight() + 20

    if distance(x, y, circleX, lineY) <= 15 then
        self.dragging = true
    end
end

function slider:mousemoved(x, y)
    if self.dragging then
        self:updateValue(x)

        local split = stringSplit(self.reference, ".")
        Settings:setValue(split[1], split[2], split[3], self.val)
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
