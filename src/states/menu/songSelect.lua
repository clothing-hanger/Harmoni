local songSelect = State("songSelect")
local songList = {}
local difficultyList = {} -- hate having to have 2 but its better this way
local songButtons = {}
local difficultyButtons = {}
local difficultyList = {}
local songButtonWidth = 600
local songButtonHeight = 75
local songButtonSpacing = 15
local selectedSong = 1
local hoveredSong = 1
local buttonAngle = 5


local songButtonX = 20

local difficultyButtonX = songButtonX + songButtonWidth + 30

function songSelect:enter()
    self.colors = {
        light = {0, 0, 0, 0},
        dark = {0, 0, 0, 0.8}
    }

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
while true do
    path = channel:demand()
    if not path then goto continue end

    if path == "exit" then
        break
    end

    image = love.image.newImageData(path)

    outChannel:push({
        path = path,
        image = image,
        averageColor = getAverageColor(image)
    })
    
    print("Loaded image: " .. path)

    ::continue::
    love.timer.sleep(0.1)
end
]]
    self.bannerInputChannel = love.thread.getChannel("thread.bannerLoader")
    self.bannerChannel = love.thread.getChannel("thread.bannerLoader.out")

    self.bannerThread:start()

    self:setupSongList()
end

function songSelect:setupSongList()
    songList = SongListManager.getSongList(musicPath)
    for i = 1,#songList do
        local songInfo = false
        if not songList[i] then table.remove(songList, i); goto continue end
        local difficultyList = SongListManager.getDifficultyList(musicPath .. songList[i])
        if not difficultyList[1] then table.remove(songList, i); goto continue end
        if not love.filesystem.getInfo(musicPath .. "/" .. songList[i] .. "/" .. difficultyList[1], "file") then table.remove(songList, i); goto continue end
        songInfo = ChartParse.harmc(musicPath .. songList[i] .. "/" .. difficultyList[1] .. "/")
        if not songInfo.meta.backgroundFile then songInfo.meta.backgroundFile = "???" end

        if songInfo then
            table.insert(songButtons, menuSongButton(
                self,
                songButtonWidth,songButtonHeight,songButtonX,i*(songButtonHeight+songButtonSpacing),
                songInfo.meta.title,
                songInfo.meta.artist,
                songInfo.meta.charter,
                songInfo.meta.bpm,
                musicPath .. songList[i] .. "/" .. songInfo.meta.backgroundFile,
                false,
                songInfo.meta.gameMode,
                musicPath .. songList[i] .. "/"
            ))
        end
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
        songInfo = ChartParse.harmc(path .. "/" .. difficultyList[i] .. "/")

        if songInfo then
            local y = i * (songButtonHeight + songButtonSpacing)
            local x = difficultyButtonX + baseX + slope * (y - baseY)
            print(songInfo.image)
            table.insert(difficultyButtons,
                menuSongButton(
                    songButtonWidth,
                    songButtonHeight,
                    x,
                    y,
                    songInfo.meta.difficultyName,
                    nil,
                    songInfo.meta.charter,
                    nil,
                    nil,
                    true,
                    songInfo.meta.gameMode,
                    path .. "/" .. difficultyList[i] .. "/",
                    7,
                    color
                )
            )
        end
    end

    function songSelect:difficultyListDraw()
       -- love.graphics.rectangle("fill", difficultyButtonX, songButtonHeight, songButtonWidth, difficultyListBoxHeight)
        for i, DifficultyButton in ipairs(difficultyButtons) do
            DifficultyButton:draw()
        end
    end
end

function songSelect:loadSongButtonImages()
    if self.bannerChannel:peek() then
        local data = self.bannerChannel:pop()
        if data then
            for i, SongButton in ipairs(songButtons) do
                if SongButton.imagePath == data.path then
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
    self:checkForSongButtonClicks()
    self:updateSongButtons(dt)
    self:loadSongButtonImages()
    self:handleInputs()
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
    hoveredSong = hoveredSong + s
end



function songSelect:updateSongButtons(dt)
    local speed = 10
    local slope = math.rad(buttonAngle)
    local baseX = -10
    local baseY = 0

    for i, SongButton in ipairs(songButtons) do
        local targetY = (i + hoveredSong) * (songButtonHeight + songButtonSpacing)
        SongButton.y = SongButton.y or targetY
        SongButton.y = SongButton.y + (targetY - SongButton.y) * speed * dt
        SongButton.x = baseX + slope * (SongButton.y - baseY)

        SongButton:update(dt)
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

function songSelect:draw()
    -- draw background from selected song button
    for i, SongButton in ipairs(songButtons) do
        if i == selectedSong then
            local image = false
            local imageWidth, imageHeight
            if SongButton.imageLoaded then image = SongButton.image end
            if image then 
                imageWidth = baseScreenRatio.x/image:getWidth()
                imageHeight = baseScreenRatio.y/image:getHeight()
                love.graphics.draw(image,0,0, nil, imageWidth, imageHeight)     
            end   
        end 
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



return songSelect
