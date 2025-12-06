local america = State("america")

america.finishedAnthem = false

function america:enter()
    love.audio.stop()
    self.music = love.audio.newSource("Skins/AMERICA/the star and spangled banner.wav", "stream")

    self.salutingGuy = love.graphics.newImage("Skins/AMERICA/salutingguy.png")
    self.americanFlag = love.graphics.newImage("Skins/AMERICA/americaflag.png")

    self.music:play()

    self.font = SkinHandler:getFont("Menu", 35)
end

function america:update(dt)
    if not self.music:isPlaying() then
        self.finishedAnthem = true
        love.event.quit()
    end
end

function america:draw()
    love.graphics.setColor(1, 1, 1)

    love.graphics.draw(
        self.americanFlag,
        baseScreenRatio.x / 2, baseScreenRatio.y / 2,
        0, (baseScreenRatio.x / self.americanFlag:getWidth()), (baseScreenRatio.y / self.americanFlag:getHeight()),
        self.americanFlag:getWidth() / 2, self.americanFlag:getHeight() / 2
    )

    love.graphics.draw(
        self.salutingGuy,
        0, baseScreenRatio.y - self.salutingGuy:getHeight()*2,
        0, 2, 2
    )

    local lastFont = love.graphics.getFont()
    love.graphics.setFont(self.font)
    love.graphics.setColor(0, 0, 0)
    local textX = 0
    local textY = baseScreenRatio.y - 80
    local text = "Please rise for the national anthem"
    for x = -2, 2 do
        for y = -2, 2 do
            love.graphics.printf(
                text,
                textX + x, textY + y,
                baseScreenRatio.x,
                "center"
            )
        end
    end
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(
        text,
        textX, textY,
        baseScreenRatio.x,
        "center"
    )
    love.graphics.setFont(lastFont)
end

return america