---@diagnostic disable: inject-field
local jukebox = State("jukebox")

function jukebox:enter(parent)
    self.parent = parent
    self.background = self.parent.BG

    self.songButtonX = 10
    self.songButtonWidth = 475
    self.songButtonHeight = 75
    self.songButtonSpacing = 10
    self.songButtons = {}

    self:setupSongList()
end

local validTypes = {
    "srt",
    "vtt",
    "sbv",
    "stl",
    "ass",
    "lua"
}

function jukebox:switchSong(songInfo)
    if self.audio and self.audio:isPlaying() then self.audio:stop() end
    self.audio = nil
    self.lyricsDisplay = nil
    self.currentSongInfo = songInfo
    self.audio = love.audio.newSource(self.currentSongInfo.path .. "/" .. self.currentSongInfo.audio, "stream")
    self.audio:play()

    if getFileExtension(self.currentSongInfo.bg) ~= "mp4" then
        print(self.currentSongInfo.path .. "/" ..self.currentSongInfo.bg)
        self.video = false
        self.songBG = love.graphics.newImage(self.currentSongInfo.path .. "/" ..self.currentSongInfo.bg)
    else
        self.songBG = video(self.currentSongInfo.path .. "/" .. self.currentSongInfo.bg, 520, 30, 1, 1)
        self.songBG:play()
        self.video = true

        local targetSizeX = 1430
        local targetSizeY = 804

        self.songBG.scaleX = targetSizeX / self.songBG.image:getWidth()
        self.songBG.scaleY = targetSizeY / self.songBG.image:getHeight()
        self.songBG.x = 520 + (targetSizeX / 2)
        self.songBG.y = 30 + (targetSizeY / 2)
    end

    local type = ""
    local path = self.currentSongInfo.path .. "/lyrics."
    for _, t in ipairs(validTypes) do
        if love.filesystem.getInfo(path .. t, "file") then
            type = t
            break
        end
    end
    if type ~= "lua" then
        local lyrics = CaptionParser.parse(love.filesystem.read(path .. type), type)
        self.lyricsDisplay = lyricsDisplay(baseScreenRatio.x-570,30,540,baseScreenRatio.y-200,lyrics)
    else
        local lyrics = CaptionParser.parse(path .. type, type)
        self.lyricsDisplay = lyricsDisplay(baseScreenRatio.x-570,30,540,baseScreenRatio.y-200,lyrics)
    end
end

function jukebox:setupSongList()
    self.songList = SongListManager.getSongList(musicPath)  -- why does this function even take an argument? useless ass "feature"
    for i, Song in ipairs(self.songList) do                 -- it doesn't NEED the argument, its an optional param
        local x, y = self.songButtonX, (self.songButtonHeight + self.songButtonSpacing) * i
        local width, height = self.songButtonWidth, self.songButtonHeight
        local name, artist, audio
        local songInfo = nil
        local bg
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
        if songInfo.backgroundVideo then bg = songInfo.backgroundVideo else bg = songInfo.backgroundFile end
        table.insert(self.songButtons, jukeboxSongButton(x, y, width, height, name, artist, audio, musicPath .. Song .. "/", bg))
        ::continue::
    end
end

function jukebox:update(dt)
    local audioTime = 0
    if self.audio and self.audio:isPlaying() then
        audioTime = self.audio:tell("seconds")
    end

    if self.lyricsDisplay then
        self.lyricsDisplay:update(dt, audioTime)
    end

    self:checkForSongButtonClicks()

    if Input:pressed("menuClickLeft") then
        if self.lyricsDisplay then
            local lyricClick = self.lyricsDisplay:clickLyric()
            if lyricClick and lyricClick.lyricClick then
                self.audio:seek(lyricClick.time)
                if self.video then
                    self.songBG:seek(lyricClick.time)
                    self.songBG.forcedUpdate = true
                end
            end
        end
    end

    if self.video then
        self.songBG:update(dt)
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

    for _, Button in ipairs(self.songButtons) do
        Button:draw()
    end

    --lyrics skeleton
    if not self.lyricsDisplay then love.graphics.rectangle("fill",baseScreenRatio.x-570,30,540,baseScreenRatio.y-200) end

    --songBG skeleton
    love.graphics.rectangle("fill", 520, 30, 1430, 804)

    --song info skeleton 
    --love.graphics.rectangle("fill", 520, 1070, 1430, 200)

    --scrubber and button skeleton
    love.graphics.rectangle("fill", 0, 1305, baseScreenRatio.x, 200)

    self:drawBG()
end


function jukebox:drawBG()
    if self.video then
        self.songBG:draw()
    elseif self.songBG then
        love.graphics.draw(self.songBG,520, 30,nil,1430 / self.songBG:getWidth(),804 / self.songBG:getHeight())
    end
end

return jukebox