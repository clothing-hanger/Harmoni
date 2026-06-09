local modeSeperator = settingsbaseshitthingy:extend("modeSeperator")

function modeSeperator:new(name)
    self.name = name
    self.font = SkinHandler:getFont("Menu", 35)
end

function modeSeperator:draw(x, y)
    x = x or 0
    y = y or 0
    love.graphics.setFont(self.font)
    love.graphics.print(self.name, x, y)
    love.graphics.setLineWidth(5)
    love.graphics.line(x, y + self.font:getHeight() + 5, x + 700, y + self.font:getHeight())

    return 75
end

return modeSeperator