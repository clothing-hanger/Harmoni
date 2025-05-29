local songSelect = State("songSelect")
local songList = {}
local songButtons = {}
local difficultyButtons = {}
local difficultyList = {}
local songButtonWidth = 400
local songButtonHeight = 50
local songButtonSpacing = 10
local selectedSong = 1
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
        if songInfo then table.insert(songButtons, menuSongButton(1000,50,
                                                                        songInfo.meta.difficultyName,
                                                                        nil,
                                                                        songInfo.meta.charter,
                                                                        nil,
                                                                        nil,
                                                                        true,
                                                                        songInfo.meta.gameMode,
                                                                        musicPath .. songList[selectedSong] .. "/" .. difficultyList[i] .. "/"
                                                                        )) end
    end
end

function songSelect:loadSongButtonImages()
    self.framesPassed = (self.framesPassed or 0) + 1 -- has to be self and not local to the function so it doesnt reset every time the func is called (every frame)
    local framesBetweenLoads = 1

    if self.framesPassed >= framesBetweenLoads then
        for i, SongButton in ipairs(songButtons) do
            if not SongButton.imageLoaded and SongButton.y <= love.graphics.getHeight() then
                SongButton:loadImage()
                SongButton.imageLoaded = true
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
end

function songSelect:scroll(s)
    for i, SongButton in ipairs(songButtons) do
        SongButton.y = SongButton.y-s*100
    end
end

function songSelect:updateSongButtons(dt)
    for i, SongButton in ipairs(songButtons) do
        SongButton:update(dt)
        --SongButton.x, SongButton.y = 100, i*(songButtonHeight+songButtonSpacing)
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
    for i, SongButton in ipairs(songButtons) do
        SongButton:draw()
    end

    for i, DifficultyButton in ipairs(difficultyButtons) do
        DifficultyButton:draw()
    end

end

return songSelect
