local songSelect = State("songSelect")
local songList = {}
local songButtons = {}
local difficultyButtons = {}
local difficultyList = {}
local songButtonWidth = 600
local songButtonHeight = 75
local songButtonSpacing = 15
local selectedSong = 1
local hoveredSong = 1
local buttonAngle = 5

local songButtonScrollTarget = 0 -- ew
local songButtonX = 20

function songSelect:enter()
    self:setupSongList()
end

function songSelect:setupSongList()
    songList = SongListManager.getSongList(musicPath)
    for i = 1,#songList do
        local songInfo = false
        local difficultyList = SongListManager.getDifficultyList(musicPath .. songList[i])
        if not songList[i] or not difficultyList[1] or not love.filesystem.getInfo(musicPath .. songList[i] .. "/" .. difficultyList[1] .. "/", "file") then goto continue end
        songInfo = ChartParse.harmc(musicPath .. songList[i] .. "/" .. difficultyList[1] .. "/")
        if not songInfo.meta.backgroundFile then songInfo.meta.backgroundFile = "???" end

        if songInfo then table.insert(songButtons, menuSongButton(
                                                                    songButtonWidth,songButtonHeight,songButtonX,i*(songButtonHeight+songButtonSpacing),
                                                                    songInfo.meta.title,
                                                                    songInfo.meta.artist,
                                                                    songInfo.meta.charter,
                                                                    songInfo.meta.bpm,
                                                                    musicPath .. songList[i] .. "/" .. songInfo.meta.backgroundFile,
                                                                    false,
                                                                    songInfo.meta.gameMode,
                                                                    musicPath .. songList[i] .. "/"
                                                                    )) end
            ::continue::

                                                                    
    end
end

function songSelect:setupDifficultyList()
    difficultyList = SongListManager.getDifficultyList(musicPath .. songList[selectedSong] .. "/")
    songButtons = {}
    for i = 1,#difficultyList do
        local songInfo = false
        songInfo = ChartParse.harmc(musicPath .. songList[selectedSong] .. "/" .. difficultyList[i] .. "/")
        if songInfo then table.insert(songButtons, menuSongButton(2000,100,
                                                                        songInfo.meta.difficultyName,
                                                                        nil,
                                                                        songInfo.meta.charter,
                                                                        nil,
                                                                        nil,
                                                                        true,
                                                                        songInfo.meta.gameMode,
                                                                        musicPath .. songList[selectedSong] .. "/" .. difficultyList[i] .. "/"
                                                                        ))

        end
    end
end

function songSelect:loadSongButtonImages()
    self.framesPassed = (self.framesPassed or 0) + 1 -- has to be self and not local to the function so it doesnt reset every time the func is called (every frame)
    local framesBetweenLoads = 1

    if self.framesPassed > framesBetweenLoads then
        for i, SongButton in ipairs(songButtons) do

            if not (SongButton.imageLoaded or SongButton.failedToLoadImage or SongButton.attemptedToLoadImage) and SongButton.y > 0 and SongButton.y < love.graphics.getHeight() then
                SongButton:loadImage()
                self.framesPassed = 0
                break
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
                    self:setupDifficultyList()
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
            if SongButton.imageLoaded then love.graphics.draw(SongButton.image) end
                
        end 
    end   
    self:drawGradients()

    for i, SongButton in ipairs(songButtons) do
        SongButton:draw()
    end

    for i, DifficultyButton in ipairs(difficultyButtons) do
        DifficultyButton:draw()
    end

end


function songSelect:drawGradients()  -- the code here is so bad 😭😭😭😭
    local colors = {
        light = {0,0,0,0},
        dark = {0,0,0,0.95}
    }
    --left side
    love.graphics.push()
    love.graphics.rotate(math.rad(-buttonAngle))
    love.graphics.setColor(colors.dark[1], colors.dark[2], colors.dark[3], colors.dark[4])
    love.graphics.rectangle("fill",50,0,-1000,1280)
    drawGradientRect(50,-200,700,1080+400,{colors.dark[1], colors.dark[2], colors.dark[3], colors.dark[4]}, {colors.light[1], colors.light[2], colors.light[3], colors.light[4]})
    love.graphics.pop()

    --right side
    love.graphics.push()
    love.graphics.rotate(math.rad(-buttonAngle))
    love.graphics.setColor(colors.dark[1], colors.dark[2], colors.dark[3], colors.dark[4])
    love.graphics.rectangle("fill",1920+950,0,-1000,1280)
    drawGradientRect(1920-750,-200,700,1080+400,{colors.light[1], colors.light[2], colors.light[3], colors.light[4]}, {colors.dark[1], colors.dark[2], colors.dark[3], colors.dark[4]})
    love.graphics.pop()

end


return songSelect
