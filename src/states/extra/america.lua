local america = State("america")

america.finishedAnthem = false

local doEagle = false
local didSound = false
local timer = 1
local canStack = false
local eagles = {} -- { eagleX, eagleSpeed, eagleY, goingRight, frame, delay, timer }

local function remap(v, inMin, inMax, outMin, outMax)
    return outMin + (v - inMin) * (outMax - outMin) / (inMax - inMin)
end

function america:enter()
    love.audio.stop()
    self.music = love.audio.newSource("Skins/AMERICA/the star and spangled banner.wav", "stream")

    self.salutingGuy = love.graphics.newImage("Skins/AMERICA/salutingguy.png")
    self.americanFlag = love.graphics.newImage("Skins/AMERICA/american-flag-usa.gif")
    self.eagle = love.graphics.newImage("Skins/AMERICA/1edea8227788d2c7d29f6af3f24b8e07.gif")
    self.eagleSound = love.audio.newSource("Skins/AMERICA/eagle-rahhh.mp3", "static")

    self.music:play()

    self.font = SkinHandler:getFont("Menu", 35)
    canStack = love.math.random(1, 1) == 1
end

function america:update(dt)
    self.eagle:update(dt)
    if not self.music:isPlaying() then
        self.finishedAnthem = true
        love.event.quit()
    end

    local ableto = canStack == true
    if not ableto then
        ableto = not doEagle
    end

    timer = timer + dt
    if math.floor(timer) % 3 == 0 and ableto then
        timer = 1
        if love.math.random(1, (not canStack and 1) or 3) == 1 then
            doEagle = true
            local clone = self.eagleSound:clone()
            table.insert(eagles, { 0, 300 + love.math.random(0, 400), baseScreenRatio.y/2-225 + love.math.random(-200, 200), love.math.random(1, 2) == 1, 1, self.eagle.frames[1].delay, 0 })
            local pitch = remap(eagles[#eagles][2], 300, 700, 0.5, 1.5)
            clone:setPitch(pitch)
            clone:play()
            if eagles[#eagles][4] then
                eagles[#eagles][1] = 2560
                eagles[#eagles][2] = -eagles[#eagles][2]
            end
        end
    end

    for _, eagle in ipairs(eagles) do
        eagle[1] = eagle[1] + eagle[2] * dt
        eagle[7] = eagle[7] + dt
        if eagle[7] >= eagle[6] then
            eagle[5] = eagle[5] + 1
        end
        if not self.eagle.frames[eagle[5]] then eagle[5] = 1 end
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

    for _, eagle in ipairs(eagles) do
        self.eagle.frameIndex = eagle[5]
        love.graphics.draw(
            self.eagle,
            eagle[1], eagle[3],
            0, -2 * (eagle[4] and -1 or 1), 2
        )
    end

    local lastFont = love.graphics.getFont()
    love.graphics.setFont(self.font)
    love.graphics.setColor(0, 0, 0)
    local textX = 0
    local textY = baseScreenRatio.y - 80
    local text = "Please rise for our national anthem"
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