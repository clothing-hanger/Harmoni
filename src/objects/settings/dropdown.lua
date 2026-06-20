local dropdown = settingsbaseshitthingy:extend("dropdown")

function dropdown:new(name, current, options)
    self.name = name
    self.font = SkinHandler:getFont("Menu", 35)
    self.font2 = SkinHandler:getFont("Menu", 28)

    self.current = current
    self.options = options

    self.display = false

    self.x = 0
    self.y = 0
end

function dropdown:mousepressed(x, y, button)
    local w = self.font:getWidth(self.name .. ":   ")

    local boxX = self.x + w - 5
    local boxY = self.y - 5

    if x >= boxX and x <= boxX + 200 and y >= boxY and y <= boxY + 50 then
        self.display = not self.display
        return true
    end

    if not self.display then
        return false
    end

    local optionY = boxY + 50

    local canKillItself = false
    for _, option in ipairs(self.options) do
        if x >= boxX and x <= boxX + 200 and y >= optionY and y <= optionY + 50 then

            self.current = option
            self.display = false

            local split = stringSplit(self.reference, ".")
            Settings:setValue(split[1], split[2], split[3], option)
            canKillItself = true
        end

        optionY = optionY + 50
    end

    self.display = false

    return false
end

function dropdown:mousereleased(x, y, button)
end

function dropdown:draw(width, height, x, y)
    x = x or 0
    y = y or 0

    self.x = x + 15
    self.y = y + 15

    love.graphics.setFont(self.font)
    love.graphics.print(self.name .. ": ", self.x, self.y)

    love.graphics.setFont(self.font2)

    local w = self.font:getWidth(self.name .. ":   ")

    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", self.x + w - 5, self.y - 5, 200, 50, 5, 5)

    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", self.x + w - 5, self.y - 5, 200, 50, 5, 5)

    local function stencil()
        love.graphics.rectangle("fill", self.x + w - 5, self.y - 5, 200, 50, 5, 5)
    end

    love.graphics.stencil(stencil, "replace", 1)
    love.graphics.setStencilTest("greater", 0)
    love.graphics.print(tostring(self.current), self.x + w, self.y + 7)
    love.graphics.setStencilTest()

    if self.display then
        local ny = self.y + 50

        for _, option in ipairs(self.options) do
            love.graphics.setColor(0, 0, 0)
            love.graphics.rectangle("fill", self.x + w - 5, ny - 5, 200, 50, 5, 5)

            love.graphics.setColor(1, 1, 1)
            love.graphics.rectangle("line", self.x + w - 5, ny - 5, 200, 50, 5, 5)

            local function optionStencil()
                love.graphics.rectangle("fill", self.x + w - 5, ny - 5, 200, 50, 5, 5)
            end

            love.graphics.stencil(optionStencil, "replace", 1)
            love.graphics.setStencilTest("greater", 0)
            love.graphics.print(option, self.x + w, ny + 7)
            love.graphics.setStencilTest()

            ny = ny + 50
        end
    end

    return height
end

return dropdown
