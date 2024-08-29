local TitleScreen = State()

local selection
local logo

function TitleScreen:enter()
    SelectedSong = 1
    SelectedDifficulty = 1
    selection = 1
    TitleScreen:switchSong()
    
end

function TitleScreen:switchSong()   -- icky disgusting code copy but its fine i guess (this exact code is in 2 places in the game)
    TitleScreen:setupDifficultyList()

    print("Switch Song")
    local metaData = love.filesystem.load("Music/"..SongList[SelectedSong].."/meta.lua")()
    background = "Music/"..SongList[SelectedSong].."/"..metaData.difficulties[SelectedDifficulty].background
    for i, difficulty in ipairs(metaData.difficulties) do
        print(tostring(DifficultyList[SelectedDifficulty]))
        if tostring(DifficultyList[SelectedDifficulty]) == difficulty.fileName then
            print("diff")
            if love.filesystem.getInfo("Music/"..SongList[SelectedSong].."/"..metaData.difficulties[SelectedDifficulty].background) and
                love.filesystem.getInfo("Music/"..SongList[SelectedSong].."/"..metaData.difficulties[SelectedDifficulty].background).type == "file" then
                    
                background = love.graphics.newImage("Music/"..SongList[SelectedSong].."/"..metaData.difficulties[SelectedDifficulty].background)
            else
                background = nil
            end
            songName = metaData.songName
            difficultyName = "Music/"..SongList[SelectedSong].."/"..metaData.difficulties[SelectedDifficulty].diffName
            print(metaData.difficulties[SelectedDifficulty].background)
        end
    end
end

function TitleScreen:setupDifficultyList()  -- same comment here as in the function above :(
    DifficultyButtons = {}
    DifficultyList = {}
    local SongContents = love.filesystem.getDirectoryItems("Music/" .. SongList[SelectedSong])
    local metaData = love.filesystem.load("Music/"..SongList[SelectedSong].."/meta.lua")()
    for i = 1, #SongContents do
        if getFileExtension(tostring(SongContents[i])) == ".qua" then
            table.insert(DifficultyList, SongContents[i])
            for j, difficulty in ipairs(metaData.difficulties) do
                if tostring(DifficultyList[i]) == difficulty.fileName then
                    table.insert(DifficultyButtons, Objects.Menu.DifficultyButton(difficulty.diffName, "PLACEHOLDER", "PLACEHOLDER", i))
                end
            end
        end
    end
end

function TitleScreen:update()
    if Input:pressed("menuUp") then
        selection = minusEq(selection)
    elseif Input:pressed("menuDown") then
        selection = plusEq(selection)
    elseif Input:pressed("menuConfirm") then
        if selection == 1 then
            State.switch(States.Menu.TitleScreen)
        elseif selection == 2 then
            State.switch(States.Menu.SettingsMenu)
        end
    end
end

function TitleScreen:draw()
    love.graphics.print("Selection:  " .. selection)
    love.graphics.print("Really good title screen", Inits.GameWidth/2, 150)
    
end

return TitleScreen