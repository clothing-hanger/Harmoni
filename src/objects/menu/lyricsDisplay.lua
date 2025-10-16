local lyricsDisplay = Class:extend("lyricsDisplay")

function lyricsDisplay:new(x,y,width,height,lyrics)
    print(type(lyrics))
    if type(lyrics) == "table" then self.lyrics = lyrics else error("are you fucking stupid or something?") end
    self.x,self.y,self.width,self.height = x,y,width,height
    self.currentLyric = 0
    self.lyricRectWidth, self.LyricRectHeight = self.width, 50
    self.lyricRectSpacing = 150
    self:setUpLyrics()
end

function lyricsDisplay:setUpLyrics()
    for i, Lyric in ipairs(self.lyrics) do
        local y = (self.y + (self.LyricRectHeight+self.lyricRectSpacing))*i
        Lyric.rectangle = {x = self.x, y = y, width = self.lyricRectWidth, height = self.LyricRectHeight}
    end
end

function lyricsDisplay:update(dt, musicTime)
    for i, Lyric in ipairs(self.lyrics) do
        if musicTime > Lyric.time and not Lyric.hit then
            Lyric.hit = true
            self:hitLyric(i)  -- we use i instead of just incrementing the lyric because harmoni fucking sucks and we might get out of sync
        end
    end
end


function lyricsDisplay:hitLyric(lyricIndex)
    self.currentLyric = lyricIndex
    local targetY = self.y + self.height / 2 - self.LyricRectHeight / 2

    local currentLyric = self.lyrics[lyricIndex]
    local currentY = currentLyric.rectangle.y

    local thething = targetY - currentY

    for _, Lyric in ipairs(self.lyrics) do
        local originalY = Lyric.rectangle.y
        Timer.tween(0.1, Lyric.rectangle,  {y = originalY +thething}, "in-out-quad")

    end
end


function lyricsDisplay:draw()

    -- first we dra the background rectangle 
    love.graphics.setColor(0.5,0.5, 0.5,0.75)
    love.graphics.rectangle("fill",self.x, self.y, self.width, self.height, 50, 50)
   -- if not self.lyrics[1].rectangle then return end  -- in case the shit wasnt set up yet somehow idk
   local font = SkinHandler:getFont("Menu", 50)
   love.graphics.setFont(font)
    for i, Lyric in ipairs(self.lyrics) do
        if self.currentLyric == i then love.graphics.setColor(1,1,1) else love.graphics.setColor(0,0,0,0.5) end
       -- love.graphics.rectangle("fill", Lyric.rectangle.x, Lyric.rectangle.y, Lyric.rectangle.width, Lyric.rectangle.height)
        love.graphics.printf(Lyric.text, Lyric.rectangle.x+30, Lyric.rectangle.y, Lyric.rectangle.width-30, "left")
        love.graphics.setColor(1,1,1)
    end
end

return lyricsDisplay