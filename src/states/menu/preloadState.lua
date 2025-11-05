local preloadState = State("preloadState")

local t = 0
local progress = 0
local step = 0
local totalSteps = 2
local installing = false

function preloadState:enter()
    self.BG = SkinHandler:getImage("Menu", "Background")
    self.wavesY = 0

    States.menu.titleScreen.setUpThoseLinesThatIHate(self, 10)
    States.menu.titleScreen.setUpThoseWavesThatIHate(self, 4)
    States.menu.titleScreen.setUpThoseBubblesThatIHate(self, 20)

    self.images = {
        ["H"] = {image = SkinHandler:getImage("Menu", "H"), sizeX  = 1, sizeY = 1, x = 0, y = 0},
        ["logo"] = {image = SkinHandler:getImage("Menu", "Main Logo"), sizeX  = 1, sizeY = 1, x = 0, y = 0},
    }

    CLibs:setupIfNeeded()
    self.throbbert = throbbert({{1,1,1,1}, {1,1,1,1}, {1,1,1,1}})
end

function preloadState:update(dt)
    t = t + dt

    if not installing then
        installing = true
        step = step + 1
    elseif installing and CLibs:isInstallationDone() then
        step = step + 1
        CLibs:after()
        Timer.after(1, function()
            States.menu.titleScreen.bubbles = self.bubbles
            States.menu.titleScreen.wavesY = self.wavesY
            States.menu.titleScreen.squiglyLines = self.squiglyLines
            States.menu.titleScreen.layerWaves = self.layerWaves
            States.menu.titleScreen.images = self.images
            State.switch(States.menu.titleScreen, false)
        end)
    end

    local targetProgress = step / totalSteps
    progress = progress + (targetProgress - progress) * math.min(dt * 10, 1)

    for i, squiglyLines in ipairs(self.squiglyLines) do
        squiglyLines:update(dt)
    end
    self.layerWaves:update(dt)

    States.menu.titleScreen.updateBubbles(self, dt)
    self.throbbert:update(dt)
end

function preloadState:draw()
    love.graphics.draw(self.BG)
    for i, Bubble in ipairs(self.bubbles) do
        Bubble:draw()
    end
    love.graphics.setColor(1,1,1,0.1)
    love.graphics.push()
        love.graphics.translate(0, self.wavesY)
        self.layerWaves:draw()
    love.graphics.pop()
    love.graphics.setColor(1,1,1,0.05)
    for i, squiglyLines in ipairs(self.squiglyLines) do
        squiglyLines:draw()
    end
    local w, h = baseScreenRatio.x, baseScreenRatio.y
    love.graphics.setColor(1,1,1,1)

    love.graphics.setFont(SkinHandler:getFontLegacy("Menu Extra Large"))

    local msg = "loading :3"
    love.graphics.printf(msg, 0, h*0.5, w, "center")

    local barW = w * 0.5
    local barX = w/2 - barW/2
    local barY = h*0.6
    local segments = 300
    local amp = 4
    local speed = 5
    local points = {}

    local lastLineWidth = love.graphics.getLineWidth()
    love.graphics.setLineWidth(30)
    love.graphics.setColor(1,1,1,0.10)
    local lastX, lastY
    for i = 0, segments do
        local x = barX + (i/segments)*barW
        local y = barY + math.sin((i/segments)*math.pi*2 + t*speed) * amp

        points[#points+1] = lastX
        points[#points+1] = lastY
        points[#points+1] = x
        points[#points+1] = y
        lastX, lastY = x, y
    end
    love.graphics.line(points)

    points = {}
    love.graphics.setColor(1,1,1,0.85)
    lastX, lastY = nil, nil
    for i = 0, segments * progress do
        local x = barX + (i/segments)*barW
        local y = barY + math.sin((i/segments)*math.pi*2 + t*speed) * amp

        points[#points+1] = lastX
        points[#points+1] = lastY
        points[#points+1] = x
        points[#points+1] = y
        lastX, lastY = x, y
    end
    love.graphics.line(points)

    local r = 6
    for i = 1, 6 do
        local angle = (i/6)*math.pi*2
        local pulse = math.sin(t*4 + i)*2
        local cx = w/2 + math.cos(angle)*(20 + pulse)
        local cy = h*0.7 + math.sin(angle)*(20 + pulse)
        love.graphics.setColor(1,1,1,0.2 + (pulse/4))
        love.graphics.circle("fill", cx, cy, r + pulse)
    end

    love.graphics.setColor(1,1,1,1)

    States.menu.titleScreen.drawLogo(self)
    self.throbbert:draw()
end

return preloadState
