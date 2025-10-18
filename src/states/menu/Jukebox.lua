local jukebox = State("jukebox")

function jukebox:enter(parent)
    self.parent = parent
    self.background = self.parent.BG

    self.songButtonX = 10
    self.songButtonWidth = 780
    self.songButtonHeight = 97
    self.songButtonSpacing = 10

    self.songButtons = {}



    self:setupSongList()

end

function jukebox:switchSong(songInfo)
    if self.audio and self.audio:isPlaying() then self.audio:stop() end
    self.audio = nil
    self.lyricsDisplay = nil
    self.currentSongInfo = songInfo
    self.audio = love.audio.newSource(self.currentSongInfo.path .. "/" .. self.currentSongInfo.audio, "stream")
    self.audio:play()

    -- check for lyrics in the current song 
    if love.filesystem.getInfo(self.currentSongInfo.path .. "/lyrics.lua", "file") then
            local lyrics = require(self.currentSongInfo.path .. ".lyrics")

            self.lyricsDisplay = lyricsDisplay(baseScreenRatio.x-800,0,800,baseScreenRatio.y,lyrics)
    end
end


function jukebox:setupSongList()
    self.songList = SongListManager.getSongList(musicPath)  -- why does this function even take an argument? useless ass "feature"
    for i, Song in ipairs(self.songList) do
        local x, y = self.songButtonX, (self.songButtonHeight + self.songButtonSpacing) * i
        local width, height = self.songButtonWidth, self.songButtonHeight
        local name, artist, audio
        local songInfo = nil
        local songContents = love.filesystem.getDirectoryItems(musicPath .. Song)
        for _, File in ipairs(songContents) do
            if getFileExtension(File) == "harmc" then
                local path = musicPath .. Song .. "/" .. File
                songInfo = ChartParse.harmcMeta(path)
                break
            end
        end
        if not songInfo then
            print("oopsies :3 no valid harmc file found for song- " .. Song)
            goto continue
        end
        name = songInfo.title or "???"
        artist = songInfo.artist or "???"
        audio = songInfo.audioFile or ""
        table.insert(self.songButtons,jukeboxSongButton(x, y, width, height, name, artist, audio, musicPath .. Song .. "/"))
        ::continue::
    end
end

function jukebox:update(dt)
   if self.lyricsDisplay then self.lyricsDisplay:update(dt, self.audio:tell("seconds")) end
    self:checkForSongButtonClicks()
    if Input:pressed("menuClickLeft") then
            if not self.lyricsDisplay then return end

        local lyricClickShit = self.lyricsDisplay:clickLyric()
        if lyricClickShit and lyricClickShit.lyricClick then  self.audio:seek(lyricClickShit.time) end
    end
end

function jukebox:checkForSongButtonClicks()
    local MX,MY = cursor:getPosition()

    for i,Button in ipairs(self.songButtons) do
        if Input:pressed("menuClickLeft") then
            if MX >= Button.x and MX <= Button.x+Button.width then
                if MY >= Button.y and MY <= Button.y+Button.height then
                    self:switchSong(Button:onClick())
                end
            end
        end
    end
end

function jukebox:draw()
    love.graphics.draw(self.background)
    if self.lyricsDisplay then self.lyricsDisplay:draw() end

    for i, Button in ipairs(self.songButtons) do
        Button:draw()
    end
end

return jukebox