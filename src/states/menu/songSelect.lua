local songSelect = State("songSelect")
local songList = {}
local songButtons = {}
local difficultyButtons = {}
local difficultyList = {}
local songButtonSpacing = 60
local selectedSong = 1

function songSelect:enter()
    self:setupSongList()
end

function songSelect:setupSongList()
    songList = SongListManager.getSongList(musicPath)
    for i = 1,#songList do
        local songInfo = false
        local difficultyList = SongListManager.getDifficultyList(musicPath .. songList[i])
        songInfo = ChartParse.harmc(musicPath .. songList[i] .. "/" .. difficultyList[1] .. "/")


        if songInfo then table.insert(songButtons, menuSongButton(
                                                                    1000,50,
                                                                    songInfo.meta.title,
                                                                    songInfo.meta.artist,
                                                                    songInfo.meta.charter,
                                                                    songInfo.meta.bpm,
                                                                    songInfo.meta.image,
                                                                    false,
                                                                    songInfo.meta.gameMode,
                                                                    musicPath .. songList[i] .. "/"
                                                                    )) end
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

function songSelect:update(dt)
    self:checkForSongButtonClicks()
    self:updateSongButtons(dt)

end


function songSelect:updateSongButtons(dt)
    for i, SongButton in ipairs(songButtons) do
        SongButton:update(dt)
        SongButton.x, SongButton.y = 100, i*songButtonSpacing
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

--[[
        for j = 1,#difficultyList do
            local songInfo = ChartParse.harmc(musicPath .. songList[i] .. "/" .. difficultyList[j])
            table.insert(songButtons, menuSongButton(100,50,songInfo.meta.title, songInfo.meta.artist, songInfo.meta.charter, songInfo.meta.bpm, songInfo.meta.bannerFile, true))
           -- table.insert(songButtons, menuSongButton(songInfo.meta.title, songInfo.meta.artist, songInfo.meta.charter, songInfo.meta.bpm, musicPath .. songList[i] .. "/" .. difficultyList[j] .. "/cover.png", true))
        end
        --]]