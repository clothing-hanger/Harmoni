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

    for i, Lyric in ipairs(self.lyrics) do
        local text = Lyric.text or ""
        local the, wrappedLines = font:getWrap(text, self.lyricRectWidth)
        local textHeight = #wrappedLines * font:getHeight()

        Lyric.rectangle = {x = self.x,y = currentY, width = self.lyricRectWidth, height = textHeight}

            currentY = currentY + textHeight + self.lineSpacing
    end
end

function lyricsDisplay:update(dt, musicTime)
    for i, Lyric in ipairs(self.lyrics) do
        local CX,CY = cursor:getPosition()

        if type(Lyric.time) == "number" and musicTime > Lyric.time and not Lyric.hit then
            Lyric.hit = true
            self:hitLyric(i)
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
                for j, fuckingLyric in ipairs(self.lyrics) do
                    if j >= self.currentLyric then
                        fuckingLyric.hit = false  -- prob a better way to do this but 2 nested fors of the same table is fine probably
                    end
                end
                return {lyricClick = true, time = Lyric.time}
            end
        end
    end
end


function lyricsDisplay:hitLyric(lyricIndex)
    self.currentLyric = lyricIndex

    local currentLyric = self.lyrics[lyricIndex]
    local targetY = self.y + self.height / 2 - currentLyric.rectangle.height / 2
    local offset = targetY - currentLyric.rectangle.y

    for i, Lyric in ipairs(self.lyrics) do
        Timer.tween(0.1, Lyric.rectangle, { y = Lyric.rectangle.y + offset }, "in-out-quad")
    end
end

function lyricsDisplay:draw()

    love.graphics.setColor(0.5, 0.5, 0.5, 0.75)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, 50, 50)

    local font = SkinHandler:getFont("Menu", 50)
    love.graphics.setFont(font)

    for i, Lyric in ipairs(self.lyrics) do

        if self.currentLyric == i then
            love.graphics.setColor(1, 1, 1)
        else
            love.graphics.setColor(0, 0, 0, 0.5)
        end

        love.graphics.printf(Lyric.text,Lyric.rectangle.x + 30,Lyric.rectangle.y,Lyric.rectangle.width - 30, "left")
        love.graphics.setColor(1, 1, 1)

    end
end

return lyricsDisplay
