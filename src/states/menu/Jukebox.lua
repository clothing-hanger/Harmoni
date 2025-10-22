---@diagnostic disable: inject-field
local jukebox = State("jukebox")

local function distance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

function jukebox:enter(parent)
    self.parent = parent
    self.background = self.parent.BG

    self.songButtonX = 10
    self.songButtonWidth = 475
    self.songButtonHeight = 75
    self.songButtonSpacing = 10
    self.songButtons = {}
    self.scrubber = nil
    self.frametimer = 0

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
    if type ~= "lua" and type ~= "" then
        local lyrics = CaptionParser.parse(love.filesystem.read(path .. type), type)
        self.lyricsDisplay = lyricsDisplay(baseScreenRatio.x-570,30,540,baseScreenRatio.y-200,lyrics)
    elseif type == "lua" then
        local lyrics = CaptionParser.parse(path .. type, type)
        self.lyricsDisplay = lyricsDisplay(baseScreenRatio.x-570,30,540,baseScreenRatio.y-200,lyrics)
    end

    -- genuinely the easiest way that I thought of
    self.scrubBack = UIsquiglyLine(
        0, baseScreenRatio.y - 50,
        baseScreenRatio.x, baseScreenRatio.y - 50,
        30, 5, 1000, -5, 5
    )
    self.scrubber = UITimeRemaing(
        0, self.audio:getDuration(),
        0, baseScreenRatio.y - 50,
        baseScreenRatio.x,
        self,
        5, -5, 5, 30
    )
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
    if self.scrubberHeld then
        self.frametimer = self.frametimer + 1
    else
        self.frametimer = 0
    end
    local audioTime = 0
    if self.audio and self.audio:isPlaying() then
        audioTime = self.audio:tell("seconds")
    end

    if self.lyricsDisplay then
        self.lyricsDisplay:update(dt, audioTime)
    end

    if self.video and not self.scrubberHeld then
        self.songBG:update(dt)
    end
    if self.audio and self.scrubber then
        self.scrubBack:update(dt)
        self.scrubber:update(dt, self.audio:tell()/self.audio:getDuration())
    end

    local dontContinue = self:checkForSongButtonClicks()
    if dontContinue then return end
    dontContinue = self:checkForLyricClick()
    if dontContinue then return end
    dontContinue = self:checkForScrubberHead()
    if dontContinue then return end
    dontContinue = self:checkForScrubberHeadRelease()
    if dontContinue then return end
    dontContinue = self:checkForScrubber()
    if dontContinue then return end
end

function jukebox:checkForSongButtonClicks()
    local MX,MY = cursor:getPosition()
    local ok = false

    for _, Button in ipairs(self.songButtons) do
        if Input:pressed("menuClickLeft") then
            if MX >= Button.x and MX <= Button.x+Button.width then
                if MY >= Button.y and MY <= Button.y+Button.height then
                    self:switchSong(Button:onClick())
                    ok = true
                end
            end
        end
    end

    return ok
end

function jukebox:checkForScrubberHead()
    if not self.scrubber or not self.audio then return false end

    local mx, my = cursor:getPosition()
    local headX, headY, headRadius = self.scrubber:getHeadData()

    if Input:pressed("menuClickLeft") then
        if distance(mx, my, headX, headY) <= headRadius then
            self.scrubberHeld = true
        end
    end

    if self.scrubberHeld and Input:down("menuClickLeft") then
        local percent = math.max(0, math.min(1, mx / baseScreenRatio.x))
        local seekTime = percent * self.audio:getDuration()
        self.audio:seek(seekTime)
        return true
    end

    return false
end

function jukebox:checkForScrubberHeadRelease()
    if not self.scrubberHeld then return false end

    if not Input:down("menuClickLeft") then
        local mx = cursor:getX()
        local percent = math.max(0, math.min(1, mx / baseScreenRatio.x))
        local seekTime = percent * self.audio:getDuration()
        self.audio:seek(seekTime)
        if self.video then
            self.songBG:seek(seekTime)
            self.songBG.forcedUpdate = true
        end
        self.scrubberHeld = false
        return true
    end

    return false
end


function jukebox:checkForScrubber()
    if not self.scrubber or not self.audio then return false end

    local mx, my = cursor:getPosition()
    local scrubberY = self.scrubber.y
    local clickRadius = 50

    if Input:pressed("menuClickLeft") and not self.scrubberHeld then
        if math.abs(my - scrubberY) <= clickRadius then
            local percent = math.max(0, math.min(1, mx / baseScreenRatio.x))
            local seekTime = percent * self.audio:getDuration()
            self.audio:seek(seekTime)

            if self.video then
                self.songBG:seek(seekTime)
                self.songBG.forcedUpdate = true
            end

            self.scrubber.percent = percent
            return true
        end
    end

    return false
end

function jukebox:checkForLyricClick()
    local ok = false
    -- check if we're in the lyric box
    local mx, my = cursor:getPosition()
    if mx < baseScreenRatio.x - 570 or mx > baseScreenRatio.x - 30
        and my < 30 or my > baseScreenRatio.y - 170 then
        return false
    end
    if Input:pressed("menuClickLeft") then
        if self.lyricsDisplay then
            local lyricClick = self.lyricsDisplay:clickLyric()
            if lyricClick and lyricClick.lyricClick then
                self.audio:seek(lyricClick.time)
                if self.video then
                    self.songBG:seek(lyricClick.time)
                    self.songBG.forcedUpdate = true
                    ok = true
                end
            end
        end
    end

    return ok
end

function jukebox:draw()
    love.graphics.draw(self.background)
    if self.lyricsDisplay then self.lyricsDisplay:draw() end

    for _, Button in ipairs(self.songButtons) do
        Button:draw()
    end

    --lyrics skeleton
    if not self.lyricsDisplay then love.graphics.rectangle("fill",baseScreenRatio.x-570,30,540,baseScreenRatio.y-200) end

    --songBG skeleton        -- we have all these skeletons because its halloween so we gotta be spooky
    if not self.video and not self.songBG then
        love.graphics.rectangle("fill", 520, 30, 1430, 804)
    else
        self:drawBG()
    end

    --song info skeleton 
    love.graphics.rectangle("fill", 520, 1070, 1430, 200)

    --scrubber and button skeleton
    if not self.scrubber then
        love.graphics.rectangle("fill", 0, 1305, baseScreenRatio.x, 200)
    else
        self:drawScrubber()
    end
end

function jukebox:drawScrubber()
    love.graphics.setColor(.25, .25, .25, 0.4)
    self.scrubBack:draw()
    love.graphics.setColor(1, 1, 1, 1)
    self.scrubber:draw()

    if self.scrubberHeld and self.audio then
        local mx, _ = cursor:getPosition()
        local _, headY, headRadius = self.scrubber:getHeadData()
        local currentTime = self.audio:tell()
        local totalTime = self.audio:getDuration()
        local timeString = string.format("%02d:%02d / %02d:%02d",
            math.floor(currentTime / 60), math.floor(currentTime % 60),
            math.floor(totalTime / 60), math.floor(totalTime % 60)
        )
        local padding = 10
        local font = love.graphics.getFont()
        local textWidth = font:getWidth(timeString)
        local textHeight = font:getHeight()

        local boxX = math.min(
            math.max(mx - (textWidth / 2) - padding, 0),
            baseScreenRatio.x - textWidth - (2 * padding)
        )
        local boxY = headY - headRadius - textHeight - (2 * padding) - 5

        love.graphics.setColor(0, 0, 0, 0.75)
        love.graphics.rectangle("fill", boxX, boxY, textWidth + (2 * padding), textHeight + (2 * padding), 10, 10)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print(timeString, boxX + padding, boxY + padding)
    end
end

function jukebox:drawBG()
    local x, y, width, height = 520, 30, 1430, 804
    -- stencil 
    -- define stencil mask
    local function maskShape()
        love.graphics.rectangle("fill", x, y, width, height, 50, 50)
    end

    love.graphics.stencil(maskShape, "replace", 1)
    love.graphics.setStencilTest("greater", 0)

    if self.video then
        self.songBG:draw()
    elseif self.songBG then
        love.graphics.draw(self.songBG,x, y,nil,width / self.songBG:getWidth(),height / self.songBG:getHeight())
    end
    love.graphics.setStencilTest()
end

return jukebox