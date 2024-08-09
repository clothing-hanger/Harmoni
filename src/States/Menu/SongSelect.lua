local SongSelect = State()
SongList = love.filesystem.getDirectoryItems("Music")
local MenuState

function SongSelect:enter()
    MenuState = "Song"
    SelectedSong = 1
    SelectedDifficulty = 1
    DifficultyList = {}
    SongButtons = {}
    SongSelect:setupSongButtons()
end

function SongSelect:setupSongButtons()
    for i = 1,#SongList do
        print("Music/"..SongList[i].."/meta.lua")
        local metaData = love.filesystem.load("Music/"..SongList[i].."/meta.lua")()
        table.insert(SongButtons, Objects.Menu.SongButton(metaData.songName))
    end
end

function SongSelect:updateSongButtons()
    for i, SongButton in ipairs(SongButtons) do
        SongButton:update()
        SongButton.y = (SongButton.height + 10) * i
    end
end

function SongSelect:update(dt)
    SongSelect:updateSongButtons()
    if Input:pressed("menuDown") then
        if MenuState == "Song" then SelectedSong = (SelectedSong % #SongList) + 1
        elseif MenuState == "Difficulty" then
        SelectedDifficulty = (SelectedDifficulty % #DifficultyList) + 1 end
    elseif Input:pressed("menuUp") then
        if MenuState == "Song" then SelectedSong = (SelectedSong - 2) % #SongList + 1
        elseif MenuState == "Difficulty" then
        SelectedDifficulty = (SelectedDifficulty - 2) % #DifficultyList + 1 end
    elseif Input:pressed("menuConfirm") then
        if MenuState == "Song" then
            MenuState = "Difficulty"
            SongSelect:setupDifficultyList()
            SelectedDifficulty = 1
        elseif MenuState == "Difficulty" then
            SongString = "Music/" .. SongList[SelectedSong] .. "/" .. DifficultyList[SelectedDifficulty]
            print(SongString)
            State.switch(States.Game.PlayState)
        end
    end

end

function SongSelect:setupDifficultyList()
    DifficultyList = {}
    local SongContents = love.filesystem.getDirectoryItems("Music/" .. SongList[SelectedSong])
    for i = 1, #SongContents do
        if getFileExtension(tostring(SongContents[i])) == ".qua" then
            table.insert(DifficultyList, SongContents[i])
        end
    end
end

function SongSelect:draw()
    if MenuState == "Song" then
        for i = 1, #SongList do
            if i == SelectedSong then love.graphics.setColor(0, 1, 1) else love.graphics.setColor(1, 1, 1) end
            love.graphics.print(SongList[i], 300, 100 + (15 * i))
        end
    elseif MenuState == "Difficulty" then
        for i = 1, #DifficultyList do
            if i == SelectedDifficulty then love.graphics.setColor(0, 1, 1) else love.graphics.setColor(1, 1, 1) end
            love.graphics.print(DifficultyList[i], 300, 100 + (15 * i))
        end
    end


    for i, SongButton in ipairs(SongButtons) do
        SongButton:draw()
    end
end

return SongSelect