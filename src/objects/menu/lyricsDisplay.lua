local lyricsDisplay = Class:extend("lyricsDisplay")

function lyricsDisplay:new(x, y, width, height, lyrics)
    if type(lyrics) ~= "table" then error("are you fucking stupid or something?") end

    self.x, self.y, self.width, self.height = x, y, width, height
    self.lyrics = lyrics
    self.currentLyric = 0
    self.lyricRectWidth = self.width
    self.lineSpacing = 50

    self:setUpLyrics()
end

function lyricsDisplay:setUpLyrics()
    local font = SkinHandler:getFont("Menu", 50)
    love.graphics.setFont(font)

    local currentY = self.y

    for _, Lyric in ipairs(self.lyrics) do
        local text = Lyric.text or ""
        local the, wrappedLines = font:getWrap(text, self.lyricRectWidth)
        local textHeight = #wrappedLines * font:getHeight()

        Lyric.rectangle = {x = self.x,y = currentY, width = self.lyricRectWidth, height = textHeight}

        currentY = currentY + textHeight + self.lineSpacing
    end
end

function lyricsDisplay:update(dt, musicTime)
    self.lastLyricHitByTime = self.lastLyricHitByTime or 0

    for i = self.lastLyricHitByTime + 1, #self.lyrics do
        local Lyric = self.lyrics[i]
        if musicTime > Lyric.time then
            Lyric.hit = true
            self:hitLyric(i)
            self.lastLyricHitByTime = i
        else
            break
        end
    end
end

function lyricsDisplay:clickLyric()
    local CX, CY = cursor:getPosition()
    if Input:pressed("menuClickLeft") then
        for i, Lyric in ipairs(self.lyrics) do
            local rect = Lyric.rectangle
            if CX >= rect.x and CX <= rect.x + rect.width and CY >= rect.y and CY <= rect.y + rect.height then
                self.currentLyric = i
                for j, l in ipairs(self.lyrics) do
                    if j >= i then
                        l.hit = false
                    end
                end

                self.lastLyricHitByTime = i - 1

                return {lyricClick = true, time = Lyric.time}
            end
        end
    end
end

function lyricsDisplay:hitLyric(lyricIndex)
    self.currentLyric = lyricIndex
    local clicked = self.lyrics[lyricIndex]

    local centerY = self.y + self.height / 2 - clicked.rectangle.height / 2
    local offset = centerY - clicked.rectangle.y

    local topY = math.huge
    local bottomY = -math.huge
    for _, Lyric in ipairs(self.lyrics) do
        local yAfter = Lyric.rectangle.y + offset
        if yAfter < topY then topY = yAfter end
        if yAfter + Lyric.rectangle.height > bottomY then bottomY = yAfter + Lyric.rectangle.height end
    end

    if topY > self.y then
        offset = offset - (topY - self.y)
    elseif bottomY < self.y + self.height then
        offset = offset + (self.y + self.height - bottomY)
    end

    for _, Lyric in ipairs(self.lyrics) do
        Timer.tween(0.1, Lyric.rectangle, { y = Lyric.rectangle.y + offset }, "in-out-quad")
    end
end


function lyricsDisplay:draw()
    -- background
    love.graphics.setColor(0.5, 0.5, 0.5, 0.75)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, 50, 50)

    -- define stencil mask
    local function maskShape()
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, 50, 50)
    end

    love.graphics.stencil(maskShape, "replace", 1)
    love.graphics.setStencilTest("greater", 0)

    -- draw lyrics inside mask only
    local font = SkinHandler:getFont("Menu", 50)
    love.graphics.setFont(font)

    for i, Lyric in ipairs(self.lyrics) do
        if self.currentLyric == i then
            love.graphics.setColor(1, 1, 1)
        else
            love.graphics.setColor(0, 0, 0, 0.5)
        end

        love.graphics.printf(
            Lyric.text,
            Lyric.rectangle.x + 30,
            Lyric.rectangle.y,
            Lyric.rectangle.width - 30,
            "left"
        )
    end

    -- reset
    love.graphics.setStencilTest()
    love.graphics.setColor(1, 1, 1)
end

return lyricsDisplay
