local SongSelect = State()
SongList = love.filesystem.getDirectoryItems("Music")
local MenuState
local selectedSongHeight = Inits.GameHeight/2
local hovered

function SongSelect:enter()
    doScreenWipe("leftOut")
    MenuState = "Song"
    SelectedSong = (SelectedSong or 1)
    PlayingSong = SelectedSong
    SelectedDifficulty = 1
    DifficultyList = {}
    SongButtons = {}
    DifficultyButtons = {}
    SongSelect:setupSongButtons()
    SongSelect:switchSong()

    SongSelect:initObjects()
end

function SongSelect:initObjects()
    Objects.Menu.ModifiersMenu:new()
    Objects.Menu.ListMenu:new()

    for i = 1,10 do
        Objects.Menu.ListMenu:addItem({text = "PLACEHOLDER .. " .. i})     -- TEMPORARY LIST MENU TEST
    end
end

function SongSelect:updateObjects(dt)
    Objects.Menu.ModifiersMenu:update()
    Objects.Menu.ListMenu:update(dt)
end

function SongSelect:setupSongButtons()
    for i = 1,#SongList do
        local metaData = love.filesystem.load("Music/"..SongList[i].."/meta.lua")()
        table.insert(SongButtons, Objects.Menu.SongButton(metaData.songName, "PLACEHOLDER", "PLACEHOLDER", i))
    end
end


function SongSelect:updateButtons(dt)
    local speed = 15
    local offsetX = 45
    if MenuState == "Song" then
        for i, SongButton in ipairs(SongButtons) do
            local offsetFromSelected = math.abs(i - SelectedSong)
            local targetX = offsetFromSelected * offsetX
            local targetY = selectedSongHeight + (i - SelectedSong) * (SongButton.height + 10)
            SongButton:update()
            SongButton.y = SongButton.y + (targetY - SongButton.y) * speed * dt
            SongButton.x = SongButton.x + (targetX - SongButton.x + 1200) * speed * dt
        end
    elseif MenuState == "Difficulty" then
        for i, DifficultyButton in ipairs(DifficultyButtons) do
            local targetY = selectedSongHeight + (i - SelectedDifficulty) * (DifficultyButton.height + 10)
            DifficultyButton:update()
            DifficultyButton.y = DifficultyButton.y + (targetY - DifficultyButton.y) * speed * dt
        end
    end

    hovered = cursorX > Inits.GameWidth/2

    
    if DifficultyButtons[SelectedDifficulty] then
        DifficultyButtons[SelectedDifficulty].selected = true
    else
        if not SongButtons[SelectedSong].corrupt then notification("Selected Song is corrupt! (Case 1)") end
        SongButtons[SelectedSong].corrupt = true
    end
    

end

function SongSelect:wheelmoved(y)

    Objects.Menu.ListMenu:wheelmoved(y)

    if not hovered then return end
    if MenuState == "Song" then
        SelectedSong = SelectedSong - y
    elseif MenuState == "Difficulty" then
        SelectedDifficulty = SelectedDifficulty - y
    end
    if SelectedSong > #SongList then
        SelectedSong = 1
    elseif SelectedSong < 1 then
        SelectedSong = #SongList
    end                                          -- it has to be done this way instead of with a modulo because you can scroll either direction (i know its ugly)
    if SelectedDifficulty > #SongList then
        SelectedDifficulty = 1
    elseif SelectedDifficulty < 1 then
        SelectedDifficulty = #SongList
    end

end



function SongSelect:update(dt)
    SongSelect:updateButtons(dt)
    SongSelect:updateObjects(dt)

    if Input:pressed("menuDown") then
        if MenuState == "Song" then SelectedSong = (SelectedSong % #SongList) + 1
        elseif MenuState == "Difficulty" then
        SelectedDifficulty = (SelectedDifficulty % #DifficultyList) + 1 end
        SongSelect:switchSong()
    elseif Input:pressed("menuUp") then
        if MenuState == "Song" then SelectedSong = (SelectedSong - 2) % #SongList + 1
        elseif MenuState == "Difficulty" then
        SelectedDifficulty = (SelectedDifficulty - 2) % #DifficultyList + 1 end
        SongSelect:switchSong()

    elseif Input:pressed("menuConfirm") then
        if MenuState == "Song" then
            if PlayingSong ~= SelectedSong then
                PlayingSong = SelectedSong
                SongSelect:switchSong()

            elseif PlayingSong == SelectedSong then
                SongSelect:SwitchMenuState("Difficulty")
            end
        elseif MenuState == "Difficulty" then
            MusicTime = -100000
            SongSelect:switchToPlayState()
        end
    elseif Input:pressed("menuBack") then
        if MenuState == "Difficulty" then
            SongSelect:SwitchMenuState("Song")
        elseif MenuState == "Song" then
            State.switch(States.Menu.TitleScreen)
        end
    end
end

function SongSelect:switchSong()
    if Song then Song:stop(); Song:release() end
    SongSelect:setupDifficultyList()

    print("Switch Song")
    
    local metaData = love.filesystem.load("Music/"..SongList[SelectedSong].."/meta.lua")()
    background = "Music/"..SongList[SelectedSong].."/"..metaData.difficulties[SelectedDifficulty].background
    for i, difficulty in ipairs(metaData.difficulties) do
        print(tostring(DifficultyList[SelectedDifficulty]))
        if tostring(DifficultyList[SelectedDifficulty]) == difficulty.fileName then
            if love.filesystem.getInfo("Music/"..SongList[SelectedSong].."/"..metaData.difficulties[SelectedDifficulty].background) and
                love.filesystem.getInfo("Music/"..SongList[SelectedSong].."/"..metaData.difficulties[SelectedDifficulty].background).type == "file" then
                    
                background = love.graphics.newImage("Music/"..SongList[SelectedSong].."/"..metaData.difficulties[SelectedDifficulty].background)
            else
                background = nil
            end
            if love.filesystem.getInfo("Music/"..SongList[SelectedSong].."/"..metaData.difficulties[SelectedDifficulty].audio) and
                love.filesystem.getInfo("Music/"..SongList[SelectedSong].."/"..metaData.difficulties[SelectedDifficulty].audio).type == "file" then
                    
                Song = love.audio.newSource("Music/"..SongList[SelectedSong].."/"..metaData.difficulties[SelectedDifficulty].audio, "stream")
            else
                Song = nil
            end
            songName = metaData.songName
            difficultyName = "Music/"..SongList[SelectedSong].."/"..metaData.difficulties[SelectedDifficulty].diffName
            print(metaData.difficulties[SelectedDifficulty].background)
        end
    end

    --[[ quaverParse("Music/"..SongList[SelectedSong].."/"..DifficultyList[SelectedDifficulty], "no lanes") ]]

    if Song then Song:play() end
end


function SongSelect:switchToPlayState()
    Objects.Menu.ModifiersMenu:configureMods()
    SongString = "Music/" .. SongList[SelectedSong] .. "/" .. DifficultyList[SelectedDifficulty]
    print(SongString)
    doScreenWipe("rightIn", function()
        State.switch(States.Game.PlayState)
    end)end

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
            for j, difficulty in ipairs(metaData.difficulties) do
                if tostring(DifficultyList[i]) == difficulty.fileName then
                    table.insert(DifficultyButtons, Objects.Menu.DifficultyButton(difficulty.diffName, "PLACEHOLDER", "PLACEHOLDER", i))
                end
            end
        end
    end
end

function SongSelect:draw()
    if background then love.graphics.draw(background,0,0,0,Inits.GameWidth/background:getWidth()) end
    if MenuState == "Song" then
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
    love.graphics.setColor(0,0,0,0.7)
    love.graphics.rectangle("fill", 0, 0, 900, 220)
    love.graphics.setColor(1,1,1)
    love.graphics.setFont(Skin.Fonts["Menu Large"])
    love.graphics.printf(songName, 30, 30, 800, "left")

    Objects.Menu.ModifiersMenu:draw()
    --Objects.Menu.ListMenu:draw()
end

function SongSelect:debug()
    stateDebugString = "SelectedSong: " .. SelectedSong .. "\n" ..
    "SelectedDifficulty: " .. SelectedDifficulty .. "\n"
end

return SongSelect