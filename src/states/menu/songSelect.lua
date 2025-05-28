local songSelect = State("songSelect")
local songList = {}
local songButtons = {}
local difficultyButtons = {}
function songSelect:enter()
    self:setupSongList()
end

function songSelect:setupSongList()
    songList = SongListManager.getSongList(musicPath)
    for i = 1,#songList do
        local difficultyList = SongListManager.getDifficultyList(musicPath .. songList[i])
        local songInfo = ChartParse.harmc(musicPath .. songList[i] .. difficultyList[1])
        if songInfo then table.insert(songButtons, menuSongButton(100,50,songInfo.title)) end
    end
end

function songSelect:update(dt)
    self:checkForSongButtonClicks()
end

function songSelect:checkForSongButtonClicks()
    local buttonInfo = false
    for i, SongButton in ipairs(songButtons) do
        if mouseOver(SongButton) then
            if Input:pressed("clickLeft") then
                buttonInfo = SongButton:onClick()
            end
        end
    end
    if buttonInfo then
        if buttonInfo.loadSong then State.switch(States.game.gameModeManager, buttonInfo.mode, buttonInfo.path)
    end
end

function songSelect:draw()
    for i, SongButton in ipairs(songButtons) do
        SongButton:draw()
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