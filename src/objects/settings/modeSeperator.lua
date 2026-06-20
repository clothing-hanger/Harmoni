local modeSeperator = settingsbaseshitthingy:extend("modeSeperator")

function modeSeperator:new(name)
    self.name = name
    self.font = SkinHandler:getFont("Menu", 35)
end

function modeSeperator:draw(width, height, x, y)
    if self.name == "" or self.name == " " then
        return 0
    end

    x = x or 0
    y = y or 0
    love.graphics.setFont(self.font)
    love.graphics.print(self.name, x, y)
    love.graphics.setLineWidth(5)
    love.graphics.line(x, y + self.font:getHeight() + 5, x + width, y + self.font:getHeight())
    love.graphics.setLineWidth(1)
    return 75
end

return modeSeperator
