local SongSelect = State()
SongList = love.filesystem.getDirectoryItems("Music")
local MenuState
local selectedSongHeight = Inits.GameHeight/2
local hovered
local songListX = Inits.GameWidth/2
local tabs
local scoreMenuX = Inits.GameWidth-470
local scoreMenuY = 210
local scoreMenuWidth = 470
local scoreMenuHeight = 730
local curTab
local tabOffset = {0}

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
    curTab = "Modifiers" -- always start in mods menu because preview is slow
    SongSelect:initObjects()


    tabs = {
        {text = "Modifiers", x = 500, y = 0, width = 120, height = 25},     -- this is fucking awful
        {text = "Preview Chart", x = 625, y = 0, width = 120, height = 25},
    }


end

function SongSelect:initObjects()
    Objects.Menu.ModifiersMenu:new()
    Objects.Menu.ListMenu:new(scoreMenuX, scoreMenuY, scoreMenuWidth, scoreMenuHeight)

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
        table.insert(SongButtons, Objects.Menu.SongButton(metaData.songName, "PLACEHOLDER", "PLACEHOLDER", i, Inits.GameWidth/2, 0, 200, 40))
    end
end


function SongSelect:updateButtons(dt)
    local speed = 15
    local offsetX = 45
    local selectedSongButtonWidth, selectedSongButtonHeight = 500, 100
    local nonSelectedSongButtonWidth, nonSelectedSongButtonHeight = 350, 50
    if MenuState == "Song" then
        for i, SongButton in ipairs(SongButtons) do
            local offsetFromSelected = math.abs(i - SelectedSong)
            local targetX = (SelectedSong == i and songListX - (selectedSongButtonWidth - nonSelectedSongButtonWidth)) or songListX
            local targetY = selectedSongHeight + (i - SelectedSong) * (SongButton.height + 10)
            local targetWidth = (SelectedSong == i and selectedSongButtonWidth) or nonSelectedSongButtonWidth
            local targetHeight = (SelectedSong == i and selectedSongButtonHeight) or nonSelectedSongButtonHeight
            if i > SelectedSong then
                targetY = targetY + (selectedSongButtonHeight/2)  -- move the rest of the list down below the selected song button
            end
            SongButton:update()
            SongButton.y = SongButton.y + (targetY - SongButton.y) * speed * dt
            SongButton.x = SongButton.x + (targetX - SongButton.x) * speed * dt

            SongButton.width = SongButton.width + (targetWidth - SongButton.width) * speed * dt  
            SongButton.height = SongButton.height + (targetHeight - SongButton.height) * speed * dt 
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
        if not SongButtons[SelectedSong].corrupt then 
            notification("Selected Song is corrupt! (Case 1)")
            SongButtons[SelectedSong].corrupt = true
        end
    end
end


function SongSelect:updateTabs()
    for i, Tab in ipairs(tabs) do
        if (cursorX > tabs[i].x and cursorX < tabs[i].x + tabs[i].width) and (cursorY > tabs[i].y and cursorY < tabs[i].y + tabs[i].height) then
            if Input:pressed("menuClickLeft") then
                print(tabs[i].text)
                SongSelect:switchTab(Tab.text)
            end
        end
    end
end



function SongSelect:switchTab(tab)
    local tweenAmount = -(Objects.Menu.ModifiersMenu.width+10)
    print("tabOffset before switch" .. tabOffset[1])
    
    if tab == curTab then return end  -- dont do anything if tab clicked is already curTab
    local validTab = false
    for i, Tab in ipairs(tabs) do
        if tab == Tab.text then validTab = true end    -- check to make sure tab is valid
    end
    if not tab then error("No tab") end
    if not validTab then error("Invalid tab") end

    doingTabSwitch = true
    Timer.tween(0.1, tabOffset, {tweenAmount}, "out-quad", function() 
        curTab = tab
        Timer.tween(0.08, tabOffset, {0}, "out-quad", function()
             doingTabSwitch = false 
             print("tabOffset after switch" .. tabOffset[1])

            end)
    end)

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
    SongSelect:updateTabs(dt)

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
    if Song then 
        Song:stop() 
        Song = nil
    end
    SongSelect:setupDifficultyList()

    print("Switch Song")
    
    local metaData = love.filesystem.load("Music/"..SongList[SelectedSong].."/meta.lua")()
    if not SongList[SelectedSong] then
        notification("Selected Song does not exist!", "error")
        return
    end
    if not metaData.difficulties[SelectedDifficulty] then
        notification("Selected Difficulty does not exist!", "error")
        return
    end
    if love.filesystem.getInfo("Music/"..SongList[SelectedSong].."/"..metaData.difficulties[SelectedDifficulty].background, "file") then
        background = "Music/"..SongList[SelectedSong].."/"..metaData.difficulties[SelectedDifficulty].background
    else
        notification("Background File not loaded!", "error")
    end
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
    musicTime = -2000
    Objects.Menu.ModifiersMenu:configureMods()
    SongString = "Music/" .. SongList[SelectedSong] .. "/" .. DifficultyList[SelectedDifficulty]
    doScreenWipe("rightIn", function()
        State.switch(States.Game.PlayState)
    end)
end

---@param state string The state name to switch to
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

    -- tabs

    for i, Tab in ipairs(tabs) do
        love.graphics.rectangle("line", tabs[i].x, tabs[i].y, tabs[i].width, tabs[i].height)
        love.graphics.print(tabs[i].text, tabs[i].x, tabs[i].y)
    end


    -- top right song info box
    local topRightInfoBoxWidth = 470
    local topRightInfoBoxHeight = 200
    love.graphics.rectangle("fill", Inits.GameWidth-topRightInfoBoxWidth, 0, topRightInfoBoxWidth, topRightInfoBoxHeight)

    --score menu thingy idfk
    Objects.Menu.ListMenu:draw()


    love.graphics.translate(tabOffset[1], 0 )
    -- modifiers menu
    if curTab == "Modifiers" then 
        Objects.Menu.ModifiersMenu:draw() 
    end

    -- song preview
    if curTab == "Preview Chart" then
        love.graphics.rectangle("fill", 0, 0, 500, 1000)
    end
    -- gugo help :(
end

function SongSelect:debug()
    stateDebugString = "SelectedSong: " .. SelectedSong .. "\n" ..
    "SelectedDifficulty: " .. SelectedDifficulty .. "\n"
end

return SongSelect