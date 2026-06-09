local dropdown = settingsbaseshitthingy:extend("dropdown")

function dropdown:new(name, current, options)
    self.name = name
    self.font = SkinHandler:getFont("Menu", 35)
    self.font2 = SkinHandler:getFont("Menu", 28)

    self.current = current
    self.options = options

    self.display = true
end

function dropdown:draw(x, y)
    x = x or 0
    y = y or 0

    love.graphics.setFont(self.font)
    love.graphics.print(self.name .. ": ", x, y)
    love.graphics.setFont(self.font2)
    local w = self.font:getWidth(self.name .. ":   " )
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("fill", x + w - 5, y - 5, 200, 50, 5, 5)
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("line", x + w - 5, y - 5, 200, 50, 5, 5)
    local function stencil()
        love.graphics.rectangle("fill", x + w - 5, y - 5, 200, 50, 5, 5)
    end
    love.graphics.stencil(stencil, "replace", 1)
    love.graphics.setStencilTest("greater", 0)
    love.graphics.print(self.current, x + w, y + 7)
    love.graphics.setStencilTest()

    if self.display then
        local ny = y+50
        for _, option in ipairs(self.options) do
            love.graphics.setColor(0,0,0)
            love.graphics.rectangle("fill", x + w - 5, ny - 5, 200, 50, 5, 5)
            love.graphics.setColor(1,1,1)
            love.graphics.rectangle("line", x + w - 5, ny - 5, 200, 50, 5, 5)

            local function stencil()
                love.graphics.rectangle("fill", x + w - 5, ny - 5, 200, 50, 5, 5)
            end

            love.graphics.stencil(stencil, "replace", 1)
            love.graphics.setStencilTest("greater", 0)
            love.graphics.print(option, x + w, ny + 7)
            love.graphics.setStencilTest()

            ny = ny + 50
        end
    end

    return 75
end

return dropdown