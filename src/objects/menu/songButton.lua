local menuSongButton = Class:extend("menuSongButton")

--- @param instance table -- The instance of the menu
--- @param width number
--- @param height number
--- @param x number
--- @param y number
--- @param name string
--- @param artist string
--- @param charter string
--- @param bpm number
--- @param image string or Image
--- @param isDifficultyButton boolean
--- @param gameMode string
--- @param path string
--- @param cornerRadius number
--- @param color table (r,g,b)
function menuSongButton:new(instance, width, height, x, y, name, artist, charter, bpm, image, isDifficultyButton, gameMode, path, cornerRadius, color)
    self.isDifficultyButton = isDifficultyButton or false
    self.instance = instance
    self.width = width or 10
    self.height = height or 10
    self.x = x or 10
    self.y = y or 10

    self.mode = gameMode or "???"

    self.name = name or "???"
    self.artist = artist or "???"
    self.charter = charter or "???"
    self.bpm = bpm or "???"

    self.imagePath = image
    self.image = ((type(image) == "string" and love.filesystem.getInfo(image, "file")) and love.graphics.newImage(image)) or image
    self.imageLoaded = type(self.image) ~= "string" and self.image ~= nil

    if not self.isDifficultyButton and self.imagePath then
        self.instance.bannerInputChannel:push(self.imagePath)
    end

    self.path = path or "???"
    self.color = color or {1, 1, 1}
    self.cornerRadius = cornerRadius or 7

    self.fontLarge = songButtonFontLarge
    self.fontSmall = songButtonFontSmall

    self.borderHoverAlpha = 0
    self.hovered = false
end

function menuSongButton:onClick()
    if self.isDifficultyButton then
        return {loadSong = true, mode = self.mode, path = self.path}
    else
        return {loadSong = false, mode = self.mode, path = self.path, color = self.color}
    end
end

function menuSongButton:returnInfo()
    return {
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
end

function menuSongButton:update(dt)
    self.hovered = mouseOver(self)
end

local function remap(value, oldMin, oldMax, newMin, newMax)
    return (value - oldMin) / (oldMax - oldMin) * (newMax - newMin) + newMin
end

function menuSongButton:draw()
    if self.x + self.width < 0 or self.x > baseScreenRatio.x or
       self.y + self.height < 0 or self.y > baseScreenRatio.y then
        return
    end

    local function stencilShape()
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, self.cornerRadius, self.cornerRadius)
    end
    love.graphics.stencil(stencilShape, "replace", 1)
    love.graphics.setStencilTest("greater", 0)

    if self.imageLoaded and not dontShowBG then
        local imageScale = self.width / self.image:getWidth()
        local imageDrawY = self.y - (self.image:getHeight() * imageScale) / 2
        love.graphics.draw(self.image, self.x, imageDrawY, 0, imageScale, imageScale)
    end

    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.x, self.y, self.width / 7, self.height)

    drawGradientRect(
        self.x + self.width / 7, self.y, self.width, self.height,
        {self.color[1], self.color[2], self.color[3], 1},
        {self.color[1], self.color[2], self.color[3], 0},
        false
    )

    if self.hovered then
        local mouseX = toCanvasCoords(love.mouse.getPosition())
        local remappedX = remap(mouseX, self.x, self.x + self.width, 0, 1)

        local gradientWidth = self.width
        local gradientX = self.x + (remappedX * self.width) - (gradientWidth / 2)
        drawMultiGradientRect(
            gradientX, self.y, gradientWidth, self.height,
            {
                {self.color[1] * 0.75, self.color[2] * 0.75, self.color[3] * 0.75, 0},
                {self.color[1] * 0.75, self.color[2] * 0.75, self.color[3] * 0.75, 1},
                {self.color[1] * 0.75, self.color[2] * 0.75, self.color[3] * 0.75, 0}
            }
        )
        self.borderHoverAlpha = math.min(self.borderHoverAlpha + 10 * love.timer.getDelta(), 1)
    else
        self.borderHoverAlpha = math.max(self.borderHoverAlpha - 10 * love.timer.getDelta(), 0)
    end

    love.graphics.setColor(1, 1, 1, self.borderHoverAlpha)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height, self.cornerRadius, self.cornerRadius)

    love.graphics.setFont(self.fontLarge)
    local textColor = getTextColor(self.color[1], self.color[2], self.color[3])
    love.graphics.setColor(textColor)
    love.graphics.print(self.name, self.x + 3, self.y + 3)

    love.graphics.setFont(self.fontSmall)
    love.graphics.print(string.format("By: %s  Charted by: %s  BPM: %s", self.artist, self.charter, self.bpm), self.x + 3, self.y + self.height / 2)

    if self.isDifficultyButton then
        love.graphics.setColor(textColor)
        love.graphics.setLineWidth(5)
        love.graphics.rectangle("line", self.x, self.y, self.width, self.height, self.cornerRadius, self.cornerRadius)
        love.graphics.setLineWidth(1)
    end

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setStencilTest()
end

return menuSongButton
