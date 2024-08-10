local SongSelect = State()
SongList = love.filesystem.getDirectoryItems("Music")
local MenuState

function SongSelect:enter()
    MenuState = "Song"
    SelectedSong = 1
    SelectedDifficulty = 1
    DifficultyList = {}
    SongButtons = {}
    DifficultyButtons = {}
    SongSelect:setupSongButtons()
end

function SongSelect:setupSongButtons()
    for i = 1,#SongList do
        print("Music/"..SongList[i].."/meta.lua")
        local metaData = love.filesystem.load("Music/"..SongList[i].."/meta.lua")()
        table.insert(SongButtons, Objects.Menu.SongButton(metaData.songName, "PLACEHOLDER", "PLACEHOLDER", i))
    end
end

function SongSelect:updateButtons()
    if MenuState == "Song" then
        for i, SongButton in ipairs(SongButtons) do
            SongButton:update()
            SongButton.y = (SongButton.height + 10) * i
        end
    elseif MenuState == "Difficulty" then
        for i, DifficultyButton in ipairs(DifficultyButtons) do
            DifficultyButton:update()
            DifficultyButton.y = (DifficultyButton.height + 10) * i
        end
    end
end

function SongSelect:update(dt)
    SongSelect:updateButtons()
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
            SongSelect:SwitchMenuState("Difficulty")
        elseif MenuState == "Difficulty" then
            SongString = "Music/" .. SongList[SelectedSong] .. "/" .. DifficultyList[SelectedDifficulty]
            print(SongString)
            State.switch(States.Game.PlayState)
        end
    elseif Input:pressed("menuBack") then
        SongSelect:SwitchMenuState("Song")
    end

end

function SongSelect:SwitchMenuState(state)
    if state == "Song" then
        MenuState = "Song"
    elseif state == "Difficulty" then
        MenuState = "Difficulty"
        SongSelect:setupDifficultyList()
        SelectedDifficulty = 1
    end
end

function SongSelect:setupDifficultyList()
    DifficultyButtons = {}
    DifficultyList = {}
    local SongContents = love.filesystem.getDirectoryItems("Music/" .. SongList[SelectedSong])
    local metaData = love.filesystem.load("Music/"..SongList[SelectedSong].."/meta.lua")()
    for i = 1, #SongContents do
        if getFileExtension(tostring(SongContents[i])) == ".qua" then
            table.insert(DifficultyList, SongContents[i])
            for i, difficulty in ipairs(metaData.difficulties) do
                if tostring(SongContents[i]) == difficulty.fileName then
                    table.insert(DifficultyButtons, Objects.Menu.DifficultyButton:new(difficulty.diffName))
                end
            end
        end
    end
end

function SongSelect:draw()
    if MenuState == "Song" then
        for i = 1, #SongList do
            if i == SelectedSong then love.graphics.setColor(0, 1, 1) else love.graphics.setColor(1, 1, 1) end
            love.graphics.print(SongList[i], 300, 100 + (15 * i))
        end
        for i, SongButton in ipairs(SongButtons) do
            SongButton:draw()
        end
    elseif MenuState == "Difficulty" then
        for i = 1, #DifficultyList do
            if i == SelectedDifficulty then love.graphics.setColor(0, 1, 1) else love.graphics.setColor(1, 1, 1) end
            love.graphics.print(DifficultyList[i], 300, 100 + (15 * i))
        end
        for i, DifficultyButton in ipairs(DifficultyButtons) do
            DifficultyButton:draw()
        end
    end




end

return SongSelect