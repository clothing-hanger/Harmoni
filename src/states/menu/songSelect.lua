local songSelect = State("songSelect")
local songList = {}
local difficultyList = {} -- hate having to have 2 but its better this way
local songButtons = {}
local difficultyButtons = {}
local difficultyList = {}
local songButtonWidth = 600 * 1.3
local songButtonHeight = 75 * 1.3
local songButtonSpacing = 15
local selectedSong = 1
local hoveredSong = 0
local buttonAngle = 5
local BGAlpha = {1}
local currentDisplayedBG
local previousBG

local songButtonX = 20

local difficultyButtonX = songButtonX + songButtonWidth + 30

function songSelect:enter()
    self.colors = {
        light = {0, 0, 0, 0},
        dark = {0, 0, 0, 0.8}
    }

    self.songThread = love.thread.newThread [[
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
            print("ERROR: Failed to load song metadata from " .. path .. ": " .. err)
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

    self.bannerThread = love.thread.newThread [[
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

    self.bannerInputChannel = love.thread.getChannel("thread.bannerLoader")
    self.bannerChannel = love.thread.getChannel("thread.bannerLoader.out")

    self.songInputChannel = love.thread.getChannel("thread.songLoader")
    self.songChannel = love.thread.getChannel("thread.songLoader.out")

    self.bannerThread:start()
    self.songThread:start()

    self:setupSongList()




    self:setUpThoseLinesThatIHate(8)
end

function songSelect:setUpThoseLinesThatIHate(numberOfLines)
    self.squiglyLines = {}
    for i = 1,numberOfLines do
        local y = (baseScreenRatio.y/numberOfLines)*(i-1)
        local x1,x2 = 0, baseScreenRatio.x
        table.insert(self.squiglyLines, UIsquiglyLine(x1,y+300,x2,y-300,10,30,1000,1,70,{1,1,1,0.15}))
    end
end


function songSelect:setupSongList()
    songList = SongListManager.getSongList(musicPath)

    for i = 1, #songList do
        if not songList[i] then
            table.remove(songList, i)
            goto continue
        end
        local diffList = SongListManager.getDifficultyList(musicPath .. songList[i])
        if not diffList[1] then
            if not diffList[1] then table.remove(songList, i) end
            goto continue
        end
        if not love.filesystem.getInfo(musicPath .. "/" .. songList[i] .. "/" .. diffList[1], "file") then
            table.remove(songList, i)
            goto continue
        end
        self.songInputChannel:push(musicPath .. songList[i] .. "/" .. diffList[1] .. "/")

        ::continue::
    end
end

function songSelect:setupDifficultyList(path,color)
    difficultyList = SongListManager.getDifficultyList(path)
    difficultyButtons = {}

    local difficultyListBoxHeight = #difficultyList*(songButtonHeight+songButtonSpacing)

    -- Slope values to match song buttons
    local slope = math.rad(buttonAngle)
    local baseX = -10
    local baseY = 0

    for i = 1, #difficultyList do
        local songInfo = false
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
        for i, DifficultyButton in ipairs(difficultyButtons) do
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
    for i, squiglyLine in ipairs(self.squiglyLines) do
            squiglyLine:update(dt)
    end
    self:updateBGImage()
    self:checkForSongButtonClicks()
    self:checkForDifficultyButtonClicks()
    self:updateSongButtons(dt)
    self:loadSongs()
    self:loadSongButtonImages()
    self:handleInputs()
    self.ignoreInterpolation = false
end

function songSelect:mousemoved()
    local mx, my, dx, dy = cursor:getPosition()
    if cursor:isMouseDown() then
        hoveredSong = hoveredSong + dy
        self.ignoreInterpolation = true
    end
end

function songSelect:handleInputs()
    if Input:pressed("menuUp") then
        selectedSong = selectedSong - 1
    elseif Input:pressed("menuDown") then
        selectedSong = selectedSong + 1
    elseif Input:pressed("menuConfirm") then
    end
end

function songSelect:scroll(s)
    hoveredSong = hoveredSong + (songButtonHeight + songButtonSpacing) * s
end

function songSelect:updateSongButtons(dt)
    local speed = 10
    local slope = math.rad(buttonAngle)
    local baseX = -10
    local baseY = 0

    for i, SongButton in ipairs(songButtons) do
        local targetY = (i * (songButtonHeight + songButtonSpacing)) + hoveredSong
        if self.ignoreInterpolation then
            SongButton.y = targetY
        else
            SongButton.y = SongButton.y + (targetY - SongButton.y) * speed * dt
        end
        SongButton.x = baseX + slope * (SongButton.y - baseY)

        SongButton:update(dt)
    end
end

function songSelect:updateBGImage()

    
    local function fadeBG()
        BGAlpha = {0}
        if BGFade then Timer.cancel(BGFade) end 
        local BGFade = Timer.tween(0.4, BGAlpha, {1})
    end

    for i, SongButton in ipairs(songButtons) do
        if i == selectedSong then
            if SongButton.imageLoaded then
                if currentDisplayedBG ~= SongButton.image then -- its not the right image so we change it
                    previousBG = currentDisplayedBG
                    currentDisplayedBG = SongButton.image
                    fadeBG()
                end
            end
        end
    end

end

function songSelect:checkForSongButtonClicks()
    local buttonInfo = false
    for i, SongButton in ipairs(songButtons) do
        if mouseOver(SongButton) then
            if Input:pressed("menuClickLeft") then
                selectedSong = i
                buttonInfo = SongButton:onClick()
                if buttonInfo.loadSong then
                    print("Switching to gameModeManager: ", buttonInfo.mode, buttonInfo.path)
                    State.switch(States.game.gameModeManager, buttonInfo.mode, buttonInfo.path)
                else
                    print("Setting up difficulty list: ", buttonInfo.mode, buttonInfo.path)
                    self:setupDifficultyList(buttonInfo.path,buttonInfo.color)
                end
            end
        end
    end
    if buttonInfo then
        if buttonInfo.loadSong then State.switch(States.game.gameModeManager, buttonInfo.mode, buttonInfo.path) end
    end
end
function songSelect:checkForDifficultyButtonClicks()   -- disgusting copied code 🤢🤢🤢🤢🤢
    local buttonInfo = false
    for i, SongButton in ipairs(difficultyButtons) do
        if mouseOver(SongButton) then
            if Input:pressed("menuClickLeft") then
                selectedSong = i
                buttonInfo = SongButton:onClick()
                if buttonInfo.loadSong then
                    print("Switching to gameModeManager: ", buttonInfo.mode, buttonInfo.path)
                    State.switch(States.game.gameModeManager, buttonInfo.mode, buttonInfo.path)
                else
                    print("Setting up difficulty list: ", buttonInfo.mode, buttonInfo.path)
                    self:setupDifficultyList(buttonInfo.path,buttonInfo.color)
                end
            end

            -- why go through the rest? we already have a match so just break
            break
        end
    end
    if buttonInfo then
        if buttonInfo.loadSong then State.switch(States.game.gameModeManager, buttonInfo.mode, buttonInfo.path) end
    end
end

function songSelect:draw()
    -- draw background from selected song button
    if previousBG then love.graphics.draw(previousBG,0,0, nil, baseScreenRatio.x/previousBG:getWidth(), baseScreenRatio.y/previousBG:getHeight()) end 
    love.graphics.setColor(1,1,1,BGAlpha[1])
    if currentDisplayedBG then love.graphics.draw(currentDisplayedBG,0,0, nil, baseScreenRatio.x/currentDisplayedBG:getWidth(), baseScreenRatio.y/currentDisplayedBG:getHeight()) end
    love.graphics.setColor(1,1,1,0.1)
    for i, squiglyLine in ipairs(self.squiglyLines) do
            squiglyLine:draw(dt)
    end
    self:drawGradients()

    for i, SongButton in ipairs(songButtons) do
        SongButton:draw()
    end

    if songSelect.difficultyListDraw then songSelect:difficultyListDraw() end
    songSelect:drawSongInfo()
    songSelect:drawSongInfo()

end


function songSelect:drawGradients()  -- the code here is so bad 😭😭😭😭
    local sw, sh = baseScreenRatio.x, baseScreenRatio.y+500
    local gradientWidth = 5

    love.graphics.push()
        love.graphics.rotate(math.rad(-buttonAngle))

        -- left side
        local leftRectEdge = songButtonWidth

        love.graphics.setColor(self.colors.dark)
        love.graphics.rectangle("fill", -500,0,leftRectEdge+500,sh)

        drawGradientRect(leftRectEdge, 0, gradientWidth, sh, self.colors.dark, self.colors.light)
    love.graphics.pop()
end


function songSelect:drawSongInfo()
    --get song info 
    local box = {}
    box.height,box.width = 250,700
    local x, y = baseScreenRatio.x - box.width, baseScreenRatio.y - box.height

    local songInfo = {}
    for i, SongButton in ipairs(songButtons) do
        if i == selectedSong then
            songInfo = SongButton:returnInfo()
        end
    end
    if not songInfo or not songInfo.name then
        love.graphics.setColor(1,1,1)
        love.graphics.setFont(songSelectSongInfoFontLarge)
        love.graphics.print("No song selected", x+10, y+10)
        return
    end
    local color = {songInfo.color[1]-0.1,songInfo.color[2]-0.1,songInfo.color[3]-0.1,0.75}
    local textColor = getTextColor(color[1], color[2], color[3])

    love.graphics.setColor(color or {1,1,1})
    love.graphics.rectangle("fill", x, y, box.width+10, box.height+10, 7,7)  -- add 10 to width and height to move rounded corners off screen
    love.graphics.setFont(songSelectSongInfoFontLarge)
    love.graphics.setColor(textColor)
    love.graphics.print(songInfo.name, x+10,y+10)
    love.graphics.setFont(songSelectSongInfoFontSmall)
    love.graphics.printf("By: " .. songInfo.artist .. "\n" ..
                        "Charted by: " .. songInfo.charter .. "\n" ..
                        "BPM: " .. songInfo.bpm .. "\n" ..
                        "Gamemode: " .. songInfo.mode .. "\n" ..
                        "Note Count: " .. "PLACEHOLDER" .. "\n" ..
                        "Long Note Percent: " .. "PLACEHOLDER" .. "\n",
                        x+10,y+45,box.width,"left")

    love.graphics.setColor(1,1,1)
end

function songSelect:leave()
    self.bannerThread:wait()
    self.bannerThread:release()
    self.bannerInputChannel:clear()
    self.bannerChannel:clear()

    self.songThread:wait()
    self.songThread:release()
    self.songInputChannel:clear()
    self.songChannel:clear()
    songButtons = {}
    difficultyButtons = {}
    songList = {}
    difficultyList = {}
end

return songSelect
