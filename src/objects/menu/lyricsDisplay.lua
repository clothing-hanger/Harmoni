local lyricsDisplay = Class:extend("lyricsDisplay")

function lyricsDisplay:new(x, y, width, height, lyrics)
    if type(lyrics) ~= "table" then error("are you fucking stupid or something?") end

    self.x, self.y, self.width, self.height = x, y, width, height
    self.lyrics = lyrics
    self.currentLyric = 0
    self.lyricRectWidth = self.width
    self.lineSpacing = 50
    self.timers = {}

    self:setUpLyrics()
end

function lyricsDisplay:setUpLyrics()
    local font = SkinHandler:getFont("Menu", 50)
    love.graphics.setFont(font)

    local currentY = self.y
    local lineHeight = font:getHeight()
    local wrapLimit = self.lyricRectWidth - 30

    for _, Lyric in ipairs(self.lyrics) do
        local text = Lyric.text or ""
        local _, wrappedLines = font:getWrap(text, wrapLimit)

        local textHeight = #wrappedLines * lineHeight

        Lyric.rectangle = {
            x = self.x,
            y = currentY,
            width = self.lyricRectWidth,
            height = textHeight
        }

        currentY = currentY + textHeight + self.lineSpacing
    end
end

function lyricsDisplay:update(dt, musicTime)
    self.lastLyricHitByTime = self.lastLyricHitByTime or 0
    self.lastMusicTime = self.lastMusicTime or 0

    if musicTime < self.lastMusicTime then
        for i, Lyric in ipairs(self.lyrics) do
            if Lyric.time > musicTime then
                Lyric.hit = false
            else
                Lyric.hit = true
                self.lastLyricHitByTime = i
            end
        end

        local latest = 0
        for i, Lyric in ipairs(self.lyrics) do
            if musicTime >= Lyric.time then
                latest = i
            else
                break
            end
        end

        if latest > 0 then
            self:hitLyric(latest)
        end

        self.lastMusicTime = musicTime
        return
    end

    for i = self.lastLyricHitByTime + 1, #self.lyrics do
        local Lyric = self.lyrics[i]
        if musicTime >= Lyric.time then
            Lyric.hit = true
            self:hitLyric(i)
            self.lastLyricHitByTime = i
        else
            break
        end
    end

    self.lastMusicTime = musicTime
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

    for i, Lyric in ipairs(self.lyrics) do
        if self.timers[i] then
            Timer.cancel(self.timers[i])
        end
        self.timers[i] = Timer.tween(0.1, Lyric.rectangle, { y = Lyric.rectangle.y + offset }, "in-out-quad")
    end
end

local function drawRichText(text, x, y, wrap)
    text = tostring(text or "")

    if not text:find("<") then
        love.graphics.printf(text, x, y, wrap, "left")
        return
    end

    local baseFont = SkinHandler:getFont("Menu", 50) or love.graphics.getFont()

    local prevFont = love.graphics.getFont()
    local prevR, prevG, prevB, prevA = love.graphics.getColor()

    local lineHeight = baseFont:getHeight()
    local curY = y
    local activeColor = nil

    for line in text:gmatch("([^\n]*)\n?") do
        font = baseFont
        love.graphics.setFont(font)

        if line == "" and not text:find("^%s*$") then
            curY = curY + lineHeight
        else
            if not line:find("<") then
                love.graphics.setFont(baseFont)
                love.graphics.setColor(prevR, prevG, prevB, prevA)
                love.graphics.printf(line, x, curY, wrap, "left")
            else
                local cursorX = x
                local s = line
                while #s > 0 do
                    local pre, tag, post = s:match("^(.-)(<[^>]+>)(.*)")
                    if not tag then
                        if s ~= "" then
                            love.graphics.setFont(font)
                            love.graphics.printf(s, cursorX, curY, wrap, "left")
                            cursorX = cursorX + font:getWidth(s)
                        end
                        break
                    end

                    if pre ~= "" then
                        love.graphics.setFont(font)
                        love.graphics.printf(pre, cursorX, curY, wrap, "left")
                        cursorX = cursorX + font:getWidth(pre)
                    end

                    if tag == "<i>" then
                    elseif tag == "</i>" then
                    elseif tag:match("^<c=#%x%x%x%x%x%x>$") then
                        local hex = tag:match("^<c=(#%x+)>$")
                        if hex then
                            activeColor = hex
                            local r = tonumber(hex:sub(2,3),16)/255
                            local g = tonumber(hex:sub(4,5),16)/255
                            local b = tonumber(hex:sub(6,7),16)/255
                            if prevR ~= 1 then
                                -- darken
                                r = r * 0.6
                                g = g * 0.6
                                b = b * 0.6
                            end
                            love.graphics.setColor(r, g, b, 1)
                        end
                    elseif tag == "</c>" then
                        activeColor = nil
                        love.graphics.setColor(prevR, prevG, prevB, prevA)
                    elseif tag == "<b>" then
                    elseif tag == "</b>" then
                    elseif tag == "<u>" then
                        local underlineY = curY + lineHeight - 5
                        love.graphics.line(cursorX, underlineY, cursorX + font:getWidth(post), underlineY)
                    elseif tag == "</u>" then
                    elseif tag == "<s>" then
                        local strikeY = curY + lineHeight / 2
                        love.graphics.line(cursorX, strikeY, cursorX + font:getWidth(post), strikeY)
                    elseif tag == "</s>" then
                    end

                    s = post
                end
            end

            curY = curY + lineHeight
        end
    end

    love.graphics.setFont(prevFont)
    love.graphics.setColor(prevR, prevG, prevB, prevA)
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

        drawRichText(
            Lyric.text,
            Lyric.rectangle.x + 30,
            Lyric.rectangle.y,
            Lyric.rectangle.width - 30
        )
    end

    -- reset
    love.graphics.setStencilTest()
    love.graphics.setColor(1, 1, 1)
end

return lyricsDisplay
