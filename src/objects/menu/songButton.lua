local menuSongButton = Class:extend("songButton")

--- @param instance table -- The instance of the menu
--- @param width number
--- @param height number
--- @param name string
--- @param artist string
--- @param charter string
--- @param bpm number
--- @param image string
--- @param isDifficultyButton boolean
--- Makes a new song button
function menuSongButton:new(instance, width, height, x, y, name, artist, charter, bpm, image, isDifficultyButton, gameMode, path, cornerRadius, color)
    self.isDifficultyButton = isDifficultyButton or false
    self.instance = instance
    self.width = width or 10
    self.height = height or 10
    self.x = x or 10
    self.y = y or 10

    self.mode = gameMode or "???" -- would be bad if this isnt valid but we will figure that out later

    self.name = name or "???"
    self.artist = artist or "???"
    self.charter = charter or "???"
    self.bpm = bpm or "???"
    self.image = image or nil
    self.imagePath = image or nil
    if not self.isDifficultyButton then 
        self.instance.bannerInputChannel:push(self.imagePath) 
    end
    self.path = path or "???" -- would be bad if this path doesnt exist so we need to add a check for this later
    self.color = color or {1,1,1}
    self.cornerRadius = cornerRadius or 7

    self.fontLarge = songButtonFontLarge
    self.fontSmall = songButtonFontSmall

    self.borderHoverAlpha = 0
end

function menuSongButton:onClick()
    if self.isDifficultyButton then
        -- open the selected song and difficulty
        return {loadSong = true, mode = self.mode, path = self.path}
    else -- must just be a song button
        return {loadSong = false, mode = self.mode, path = self.path, color = self.color} -- might not even use all these values 
    end
end

function menuSongButton:returnInfo()
    local info = {
        mode = self.mode,
        name = self.name,
        artist = self.artist,
        charter = self.charter,
        bpm = self.bpm,
        image = self.image,
        path = self.path,
        isDifficultyButton = self.isDifficultyButton,
        color = self.color
    }
    return info
end

function menuSongButton:update(dt)
    self.hovered = mouseOver(self)
end

local function remap(value, oldMin, oldMax, newMin, newMax)
    return (value - oldMin) / (oldMax - oldMin) * (newMax - newMin) + newMin
end

function menuSongButton:draw()
    -- if not on screen, dont draw
    if self.x + self.width < 0 or self.x > baseScreenRatio.x or
        self.y + self.height < 0 or self.y > baseScreenRatio.y then

        return
    end

    -- set up stencil 
    local function stencilShape()
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, self.cornerRadius, self.cornerRadius)
    end
    love.graphics.stencil(stencilShape, "replace", 1)
    love.graphics.setStencilTest("greater", 0)

    local imageScale
    if self.imageLoaded then
        imageScale = self.width/self.image:getWidth()
    end
    if self.imageLoaded then love.graphics.draw(self.image, self.x, self.y-(self.image:getHeight()*imageScale)/2, nil, imageScale, imageScale) end

    -- draw gradient and filler rectangle
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill",self.x, self.y, self.width/7, self.height)
    drawGradientRect(self.x+self.width/7, self.y, self.width, self.height, {self.color[1], self.color[2], self.color[3], 1}, {self.color[1], self.color[2], self.color[3], 0}, false)

    love.graphics.setColor(1,1,1)
    if self.hovered then
        local mouseX = toCanvasCoords(love.mouse.getPosition())
        local remappedX = remap(mouseX, self.x, self.x + self.width, 0, 1)

        -- draw a gradient at the remapped x position. CENTERED
        local gradientWidth = self.width
        local gradientX = self.x + (remappedX * self.width) - (gradientWidth / 2)
        drawMultiGradientRect(gradientX, self.y,
            gradientWidth, self.height,
            {{self.color[1] * 0.75, self.color[2] * 0.75, self.color[3] * 0.75, 0},
            {self.color[1] * 0.75, self.color[2] * 0.75, self.color[3] * 0.75, 1},
            {self.color[1] * 0.75, self.color[2] * 0.75, self.color[3] * 0.75, 0}}
        )

        self.borderHoverAlpha = math.min(self.borderHoverAlpha + 10 * love.timer.getDrawDelta(), 1)
    else
        self.borderHoverAlpha = math.max(self.borderHoverAlpha - 10 * love.timer.getDrawDelta(), 0)
    end

    love.graphics.setColor(1, 1, 1, self.borderHoverAlpha)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height, self.cornerRadius, self.cornerRadius)

    -- draw song info
    love.graphics.setFont(self.fontLarge)
    local textColor = getTextColor(self.color[1], self.color[2], self.color[3])
    love.graphics.setColor(textColor)
    love.graphics.print(self.name, self.x+3, self.y+3)
    love.graphics.setFont(self.fontSmall)
    love.graphics.print("By: " .. self.artist .. "Charted by: " .. self.charter .. "BPM: " .. self.bpm, self.x+3, self.y + self.height/2)

    love.graphics.setColor(textColor)
    love.graphics.setLineWidth(5)
    if self.isDifficultyButton then love.graphics.rectangle("line", self.x, self.y, self.width, self.height, self.cornerRadius, self.cornerRadius) end

    love.graphics.setColor(1,1,1)
    love.graphics.setStencilTest()
end

return menuSongButton