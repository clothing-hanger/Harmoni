local songSelect = State("songSelect")
local songList = {}
local difficultyList = {} -- hate having to have 2 but its better this way
local songButtons = {}
local difficultyButtons = {}
local songButtonWidth = 600 * 1.3    -- why???? why would we do this??
local songButtonHeight = 75 * 1.3    -- because its fucking FUNNY
local songButtonSpacing = 15
local selectedSong = 1
local hoveredSong = 0
local BGAlpha = {1}

local currentDisplayedBG
local previousBG

local BGDarkness = 0

local songButtonX = baseScreenRatio.x - songButtonWidth - songButtonSpacing

local difficultyButtonX = songButtonX

local switchingState

function songSelect:enter()
    self.debug = true

    self.currentSongInfo = {}
    -- selectedSong = 1
    switchingState = false
    self.colors = {
        light = {0, 0, 0, 0},
        dark = {0, 0, 0, 0.8}
    }

    self.songThread = self.songThread or love.thread.newThread [[
require("love.timer")
require("love.filesystem")

local chartParse = require("modules.chartParse")

local channel = love.thread.getChannel("thread.songLoader")
local outChannel = love.thread.getChannel("thread.songLoader.out")

-- we're just loading metadata here, so we use chartParse.harmcMeta
local function loadSongMetadata(path)
    local songInfo = chartParse.harmcMeta(path)
    return songInfo
end

local path, songInfo, folderPath, ok, err
local loaded = false
while true do
    loaded = false
    path = channel:demand()
    if not path then goto continue end

    if path == "exit" then
        break
    end

    if not love.filesystem.getInfo(path, "file") then 
        goto continue 
    else 
        --songInfo = loadSongMetadata(path) 
        ok, err = pcall(function() songInfo = loadSongMetadata(path) end)
        if not ok then
           printToConsole("ERROR: Failed to load song metadata from " .. path .. ": " .. err)
            goto continue
        end
    end

    -- get folder path
    -- e.g.  Music/33409 - 179/143301.qua.harmc/ -> Music/33409 - 179/
    if string.sub(path, -1) == "/" then
        path = string.sub(path, 1, -2)  -- remove trailing slash if it exists
    end
    -- if path starts with "Music/" then remove it
    path = string.gsub(path, "^Music/", "")  -- remove "Music/" from the start of the path
    folderPath = (path:match("(.+)/[^/]+$") or "") .. "/"  -- get everything before the last slash, or return empty string if no slashes found

    outChannel:push({
        path = path,
        folderPath = folderPath,
        songInfo = songInfo
    })
    
    loaded = true

    ::continue::
    --if not loaded then
        love.timer.sleep(0.03)
    --end
end
]]

    self.bannerThread = self.bannerThread or love.thread.newThread [[
require("love.timer")
require("love.image")

local channel = love.thread.getChannel("thread.bannerLoader")
local outChannel = love.thread.getChannel("thread.bannerLoader.out")

local function getAverageColor(imageData)
    local r, g, b = 0, 0, 0
    local width, height = imageData:getDimensions()
    local totalPixels = width * height

    for y = 0, height - 1 do
        for x = 0, width - 1 do
            local pr, pg, pb = imageData:getPixel(x, y)
            r = r + pr
            g = g + pg
            b = b + pb
        end
    end

    r = r / totalPixels
    g = g / totalPixels
    b = b / totalPixels

    return {r, g, b}
end

local path, image
local loaded = false
while true do
    loaded = false
    path = channel:demand()
    if not path then goto continue end

    if path == "exit" then
        break
    end

    if not love.filesystem.getInfo(path, "file") then 
        goto continue 
    else 
        image = love.image.newImageData(path) 
    end

    outChannel:push({
        path = path,
        image = image,
        averageColor = getAverageColor(image)
    })
    
    loaded = true

    ::continue::
    if not loaded then
        love.timer.sleep(0.1)
    end
end
]]

    self.bannerInputChannel = self.bannerInputChannel or love.thread.getChannel("thread.bannerLoader")
    self.bannerChannel = self.bannerChannel or love.thread.getChannel("thread.bannerLoader.out")

    self.songInputChannel = self.songInputChannel or love.thread.getChannel("thread.songLoader")
    self.songChannel = self.songChannel or love.thread.getChannel("thread.songLoader.out")

    self.bannerThread:start()
    self.songThread:start()

    if #songList == 0 then
        self:setupSongList()
    else
        self:loadBanners()
    end
    self:setUpThoseBubblesThatIHate(10)
    self:setUpThoseLinesThatIHate(11)
    self:setUpThoseWavesThatIHate(4)

    self.logoCircle = UISquigleCircle("line", 0,baseScreenRatio.y, 350, 5, 20, 5, {1,1,1,1})
    self.logoCircleFill = UISquigleCircle("fill", 0,baseScreenRatio.y, 350, 5, 20, 5, {0,0,0,0.5})
    self.logoH = UIlogoH(90,1300,0.17)

    self.coverBG = {alpha = 0}
end

function songSelect:setUpThoseLinesThatIHate(numberOfLines)
    self.squiglyLines = {}
    for i = 1,numberOfLines do
        local y = ((baseScreenRatio.y+400)/numberOfLines)*(i-2)
        local x1,x2 = -50, baseScreenRatio.x+50
        table.insert(self.squiglyLines, UIsquiglyLine(x1,y+300,x2,y-300,10,30,1000,1,70,{1,1,1,0.15}))
    end
end


function songSelect:setUpThoseBubblesThatIHate(numberOfBubbles)
    self.bubbles = {}

    local colors = SkinHandler:getRandomColors()

    for i = 1,20 do
        ::start::
        local x,y = love.math.random(0, baseScreenRatio.x), love.math.random(baseScreenRatio.y, 0)

        if x > 0 and y < baseScreenRatio.y then -- its on the screen, we gotta start over 
         --   goto start
        end

        local color = colors[love.math.random(1,#colors)]
        table.insert(self.bubbles, UISquigleCircle("fill", x, y, 100, 5, 5, 3, color))
    end

end


function songSelect:setUpThoseWavesThatIHate(numberOfWaves)
    local colors = {
        {1,1,1,0.5},
        {0,1,1,0.5},
        {1,0,1,0.5},
        {0,0,1,0.5}
    }
    self.layerWaves = UILayerWave(0,baseScreenRatio.y-100,baseScreenRatio.x,500,numberOfWaves,300, 30, 50, colors)
end

function songSelect:setupSongList()
    songList = SongListManager.getSongList(musicPath)

    self.menuState = "song"

    for i, song in ipairs(songList) do
        if not song then
            table.remove(songList, i)
            goto continue
        end

        local diffList = SongListManager.getDifficultyList(musicPath .. song)
        if not diffList[1] then
            table.remove(songList, i)
            goto continue
        end

        if not love.filesystem.getInfo(musicPath .. song .. "/" .. diffList[1], "file") then
            table.remove(songList, i)
            goto continue
        end

        self.songInputChannel:push(musicPath .. song .. "/" .. diffList[1] .. "/")

        ::continue::
    end
end


function songSelect:loadBanners()
    for _, button in ipairs(songButtons) do
        if button.imagePath and not button.imageLoaded then
            if love.filesystem.getInfo(button.imagePath, "file") then
                self.bannerInputChannel:push(button.imagePath)
            else
                button.imageLoaded = false
                button.color = {1, 1, 1}
            end
        end
    end
end

function songSelect:clearBanners()
    for _, SongButton in ipairs(songButtons) do
        if SongButton.image == currentDisplayedBG then
            goto continue
        end
        SongButton.image = nil
        SongButton.imageLoaded = false
        SongButton.color = {1, 1, 1}

        ::continue::
    end

    collectgarbage("step")
end

function songSelect:setupDifficultyList(path,color)
    difficultyList = SongListManager.getDifficultyList(path)
    difficultyButtons = {}

    local difficultyListBoxHeight = #difficultyList*(songButtonHeight+songButtonSpacing)

    local baseX = -10
    local baseY = 0

    local slope = 0

    for i = 1, #difficultyList do
        local songInfo = nil
        songInfo = ChartParse.harmcMeta(path .. "/" .. difficultyList[i] .. "/")

        if songInfo then
            local y = i * (songButtonHeight + songButtonSpacing)
            local x = difficultyButtonX + baseX + slope * (y - baseY)

            table.insert(difficultyButtons,
                menuSongButton(
                    self,
                    songButtonWidth,
                    songButtonHeight,
                    x,
                    y,
                    songInfo.difficultyName,
                    nil,
                    songInfo.charter,
                    nil,
                    nil,
                    true,
                    songInfo.gameMode,
                    path .. "/" .. difficultyList[i],
                    7,
                    color
                )
            )
        end
    end

    function songSelect:difficultyListDraw()
        for _, DifficultyButton in ipairs(difficultyButtons) do
            DifficultyButton:draw()
        end
    end
end

function songSelect:loadSongs()
    if self.songChannel:peek() then
        local data = self.songChannel:pop()
        if data then
            -- add to songButtons
            local songInfo = data.songInfo
            if songInfo then
                table.insert(songButtons, menuSongButton(
                    self,
                    songButtonWidth,songButtonHeight,songButtonX,(#songButtons+1)*(songButtonHeight+songButtonSpacing),
                    songInfo.title,
                    songInfo.artist,
                    songInfo.charter,
                    songInfo.bpm,
                    musicPath .. data.folderPath .. (songInfo.backgroundFile or ""),
                    false,
                    songInfo.gameMode,
                    musicPath .. data.folderPath
                ))
            end
        end
    end
end

function songSelect:loadSongButtonImages()
    if self.bannerChannel:peek() then
        local data = self.bannerChannel:pop()
        if data then
            for i, SongButton in ipairs(songButtons) do
                if SongButton.imagePath == data.path and love.filesystem.getInfo(data.path, "file") then
                    SongButton.imageData = data.image
                    SongButton.image = love.graphics.newImage(data.image)
                    SongButton.imageLoaded = true
                    SongButton.color = data.averageColor
                    break
                end
            end
        end
    end
end

function songSelect:update(dt)
    if Input:pressed("menuBack") then
        if self.menuState == "difficulty" then self.menuState = "song"; return end
        if switchingState then return end

        State.transition("waveDissolve", States.menu.titleScreen, function()
            self:clearBanners()
        end)
        return
    end
    for i, squiglyLine in ipairs(self.squiglyLines) do
        squiglyLine:update(dt)
    end

    self.layerWaves:update(dt)
    self:updateBGImage()
    self:checkForSongButtonClicks()
    self:checkForDifficultyButtonClicks()
    self:updateSongButtons(dt)
    self:updateDifficultyButtons(dt)
    self:loadSongs()
    self:loadSongButtonImages()
    self.ignoreInterpolation = false

    local BGDimTarget = (self.menuState == "song" and 0) or 0.7
    BGDarkness = BGDarkness + (BGDimTarget - BGDarkness) * 10 * dt

    self.logoCircle:update(dt)
    self.logoCircleFill:update(dt)

    self.logoCircle.rotation = self.logoCircle.rotation +5*dt
    self.logoCircleFill.rotation = self.logoCircle.rotation +5*dt

    for i, Bubble in ipairs(self.bubbles) do
        Bubble:update(dt)
        Bubble.x, Bubble.y = Bubble.x + math.sin(love.timer.getTime() * 0.5 + i) * 30 * dt, Bubble.y - 50 * dt
        Bubble.y = Bubble.y + math.cos(love.timer.getTime() * 0.5 + i) * 30 * dt
        if Bubble.x > baseScreenRatio.x + 100 then Bubble.x = -100
        elseif Bubble.x < -100 then Bubble.x = baseScreenRatio.x + 100
        end
        if Bubble.y < -100 then Bubble.y = baseScreenRatio.y + 100 end
    end

    local totalSongListHeight = #songButtons * (songButtonHeight + songButtonSpacing)
    local minHoveredSong = -totalSongListHeight + songButtonHeight + songButtonSpacing * 2
    local maxHoveredSong = songButtonSpacing * 2
    hoveredSong = math.max(math.min(hoveredSong, maxHoveredSong), minHoveredSong)
end

function songSelect:mousemoved()
    local _, _, _, dy = cursor:getPosition()
    if cursor:isMouseDown() then
        hoveredSong = hoveredSong + dy
        self.ignoreInterpolation = true
    end
end

function songSelect:scroll(s)
    hoveredSong = hoveredSong + (songButtonHeight + songButtonSpacing) * s
end

function songSelect:updateSongButtons(dt)
    local speed = 10

    for i, SongButton in ipairs(songButtons) do
        local targetY = (i * (songButtonHeight + songButtonSpacing)) + hoveredSong
        local targetX = (self.menuState == "song" and songButtonX) or baseScreenRatio.x + songButtonSpacing
        if i == selectedSong and self.menuState ~= "difficulty" then targetX = targetX - 50 end
        if self.ignoreInterpolation then
            SongButton.y = targetY
        else
            SongButton.y = SongButton.y + (targetY - SongButton.y) * speed * dt
        end
        SongButton.x = SongButton.x + (targetX - SongButton.x) * speed * dt

        SongButton:update(dt)
    end
end

local BGFade
function songSelect:updateBGImage()
    local function fadeBG()
        BGAlpha = {0}
        if BGFade then Timer.cancel(BGFade) end
        BGFade = Timer.tween(0.25, BGAlpha, {1})
    end

    for i, SongButton in ipairs(songButtons) do
        if i == selectedSong then
            if SongButton.imageLoaded then
                if currentDisplayedBG ~= SongButton.image then -- its not the right image so we change it
                    previousBG = currentDisplayedBG
                    currentDisplayedBG = SongButton.image
                    -- hell, just select the current song
                    selectedSong = i     -- for what tho
                    self.currentSongInfo = SongButton:returnInfo()
                    fadeBG()
                end
            end
        end
    end
end

function songSelect:updateDifficultyButtons(dt)
    local speed = 10
    for _, DifficultyButton in ipairs(difficultyButtons) do
        local targetX = (self.menuState == "difficulty" and songButtonX) or (baseScreenRatio.x + songButtonSpacing)
        DifficultyButton.x = DifficultyButton.x + (targetX - DifficultyButton.x) * speed * dt
    end
end


function songSelect:checkForSongButtonClicks()
    local buttonInfo = false
    if self.menuState == "difficulty" then return end
    for i, SongButton in ipairs(songButtons) do
        if mouseOver(SongButton) then
            if Input:pressed("menuClickLeft") then
                self.currentSongInfo = SongButton:returnInfo()
                if selectedSong ~= i then selectedSong = i return end
                buttonInfo = SongButton:onClick()
                printToConsole("Setting up difficulty list: ", buttonInfo.mode, buttonInfo.path)
                self.menuState = "difficulty"
                self.uglyDiffButtonIssueFix = true    -- this is gross
                self:setupDifficultyList(buttonInfo.path,buttonInfo.color)
            end
        end
    end
end

function songSelect:checkForDifficultyButtonClicks() 
    local buttonInfo = false
    if self.uglyDiffButtonIssueFix then self.uglyDiffButtonIssueFix = false; return end  -- fucking disgusting fix 
    for _, SongButton in ipairs(difficultyButtons) do
        if mouseOver(SongButton) then
            if Input:pressed("menuClickLeft") then
                --selectedSong = i
                buttonInfo = SongButton:onClick()
                if switchingState then return end
                self:switchToPlaystate(buttonInfo)

            end
            -- why go through the rest? we already have a match so just break
            break
        end
    end
end

function songSelect:switchToPlaystate(buttonInfo)
    Timer.tween(0.4,self.logoH, {x = baseScreenRatio.x/2, y = baseScreenRatio.y/2}, "out-quad")

    Timer.tween(0.4,self.coverBG, {alpha = 1}, "out-quad", function() 
    State.switch(States.menu.gameTransition, buttonInfo.mode, buttonInfo.path, currentDisplayedBG, self.logoH, BGDarkness)

    end)

    switchingState = true
end


function songSelect:draw(dt)
    -- draw background from selected song button
    if not dontShowBG then
        if previousBG then love.graphics.draw(previousBG,0,0, nil, baseScreenRatio.x/previousBG:getWidth(), baseScreenRatio.y/previousBG:getHeight()) end 
        love.graphics.setColor(1,1,1,BGAlpha[1])
        if currentDisplayedBG then love.graphics.draw(currentDisplayedBG,0,0, nil, baseScreenRatio.x/currentDisplayedBG:getWidth(), baseScreenRatio.y/currentDisplayedBG:getHeight()) end
    end

    love.graphics.setColor(0,0,0,BGDarkness or 0)

    if not switchingState then love.graphics.rectangle("fill", 0,0,baseScreenRatio.x,baseScreenRatio.y) end
        love.graphics.setColor(11,1,1)
    for _, Bubble in ipairs(self.bubbles) do
        Bubble:draw()
    end

    love.graphics.setColor(1,1,1,0.05)
    for _, squiglyLine in ipairs(self.squiglyLines) do
        squiglyLine:draw(dt)
    end

    love.graphics.setColor(1,1,1)
    love.graphics.setLineWidth(5)
    love.graphics.line(songButtonX-songButtonSpacing, songButtonSpacing*2, songButtonX-songButtonSpacing, baseScreenRatio.y-songButtonSpacing*2)

    for _, SongButton in ipairs(songButtons) do
        SongButton:draw()
    end

    if songSelect.difficultyListDraw then songSelect:difficultyListDraw() end
    self:drawSongInfo(20,20,15)

    self:drawCircleWithContents()

    -- this is a sorta ugly hack but it works 
    if switchingState then
        love.graphics.setColor(1,1,1,self.coverBG.alpha)
        if currentDisplayedBG then love.graphics.draw(currentDisplayedBG,0,0, nil, baseScreenRatio.x/currentDisplayedBG:getWidth(), baseScreenRatio.y/currentDisplayedBG:getHeight()) end
        love.graphics.setColor(0,0,0,BGDarkness or 0)
        love.graphics.rectangle("fill", 0,0,baseScreenRatio.x,baseScreenRatio.y)
        love.graphics.setColor(1,1,1)
    end
    self.logoH:draw()
end

function songSelect:drawSongInfo(x, y, spacing)
    love.graphics.setFont(SkinHandler:getFontLegacy("Menu Extra Extra Large"))
    love.graphics.printf(self.currentSongInfo.name or (LocaleHandler:getText("GeneralErrors", "No Song Name")), x, y, 2000, "left")
    y = y + SkinHandler:getFontLegacy("Menu Extra Extra Large"):getHeight() + spacing

    love.graphics.setFont(SkinHandler:getFontLegacy("Menu Large"))
    love.graphics.printf(LocaleHandler:getText("Menu","Song By").. (self.currentSongInfo.artist or (LocaleHandler:getText("GeneralErrors", "No Artist Name"))), x, y, 1000, "left")
    y = y + SkinHandler:getFontLegacy("Menu Large"):getHeight() + spacing

    love.graphics.printf(LocaleHandler:getText("Menu","Charted By").. (self.currentSongInfo.charter or LocaleHandler:getText("GeneralErrors", "No Charter Name")), x,y, 1000, "left")
    y = y + SkinHandler:getFontLegacy("Menu Large"):getHeight() + spacing

    love.graphics.setFont(SkinHandler:getFontLegacy("Menu Small"))
    love.graphics.printf(LocaleHandler:getText("Menu", "Length") .. LocaleHandler:getText("Misc", "Placeholder"), x, y, 1000, "left")
    y = y + SkinHandler:getFontLegacy("Menu Small"):getHeight() + spacing

    love.graphics.printf(LocaleHandler:getText("Menu","BPM") .. (self.currentSongInfo.bpm or LocaleHandler:getText("GeneralErrors", "unknown")), x, y, 1000, "left")
    y = y + SkinHandler:getFontLegacy("Menu Small"):getHeight() + spacing

    love.graphics.printf(LocaleHandler:getText("Menu","LN%") .. LocaleHandler:getText("Misc", "Placeholder"), x, y, 1000, "left")
end


function songSelect:drawCircleWithContents()
    self.logoCircleFill:draw()
    self.logoCircle:draw()
    local logoHsx, logoHsy = 0.17,0.17
    local logoHoffset = 80
    local timeOffset = 150

    local timeStr = CHETime.session.."\n"..CHETime.real

    --love.graphics.draw(self.logoH, self.logoCircle.x+100, self.logoCircle.y-logoHoffset-70, 0, logoHsx, logoHsy, self.logoH:getWidth()/2, self.logoH:getHeight()/2)
    love.graphics.setFont(SkinHandler:getFontLegacy("Menu Large"))
    love.graphics.setColor(1,1,1)
    love.graphics.printf(timeStr, self.logoCircle.x+200, self.logoCircle.y-100, 150, "left")
end

function songSelect:exit()
    self:clearBanners()
end

return songSelect