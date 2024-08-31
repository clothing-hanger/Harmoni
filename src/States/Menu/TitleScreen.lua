local TitleScreen = State()

local selection
local logo
local buttons
local logoSize

function TitleScreen:enter()
    Objects.Menu.ModifiersMenu:new()

    --self.switchSong = States.Menu.SongSelect.switchSong     -- gonna switch to this but temp im not using it
    --self.setupDifficultyList = States.Menu.SongSelect.setupDifficultyList
    
    SelectedSong = love.math.random(1,#SongList)
    SelectedDifficulty = 1
    selection = 1

    logoSize = {x = 1, y = 1, r = 1}
    if not Song or (Song and not Song:isPlaying()) then 
        TitleScreen:switchSong()
    end

    buttons = {    -- time to make yet another completely different button format because i cant code consistently
        {
            text = "Play", 
            x = Inits.GameWidth/2-100,
            y = Inits.GameHeight/2, 
            width = 200, 
            height = 50,
            func = function()
                State.switch(States.Menu.SongSelect)
            end,
        },
        {
            text = "Settings",
            x = Inits.GameWidth/2-100, 
            y = Inits.GameHeight/2-100, 
            width = 200, 
            height = 50, 
            func = function()
                State.switch(States.Menu.SettingsMenu)
            end,     
        },
    }
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
    Objects.Menu.ModifiersMenu:configureMods()

    quaverParse("Music/"..SongList[SelectedSong].."/"..DifficultyList[SelectedDifficulty])
    if Song and Song:isPlaying() then
        Song:stop()
    end
    Song:play()
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

function TitleScreen:logoBump()
    logoSize = {x = 1.05, y = 1.1, r = 0}
    Timer.tween(0.25, logoSize, {x = 1., y = 1}, "out-quad")
end

function TitleScreen:update()

    updateBPM()
    if onBeat then TitleScreen:logoBump() end
    
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


    if Input:pressed("menuClickLeft") then
        for _, Button in pairs(buttons) do
            if cursorX >= Button.x and cursorX <= Button.x+Button.width and cursorY >= Button.y and cursorY <= Button.y + Button.height then
                Button.func()
            end
        end
    end
end

function TitleScreen:draw()
    if background then love.graphics.draw(background, Inits.GameWidth/2, Inits.GameHeight/2,   0, (Inits.GameWidth/background:getWidth()), (Inits.GameHeight/background:getHeight()), background:getWidth()/2, background:getHeight()/2) end
    love.graphics.draw(Skin.Menu["Main Logo"], Inits.GameWidth/2, Inits.GameHeight/2-250, 0, logoSize.x, logoSize.y, Skin.Menu["Main Logo"]:getWidth()/2, Skin.Menu["Main Logo"]:getHeight()/2)
    love.graphics.setFont(Skin.Fonts["Menu Small"])
    for _, Button in pairs(buttons) do
        love.graphics.setColor(0,0,0,0.8)
        love.graphics.rectangle("fill", Button.x, Button.y, Button.width, Button.height)
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle("line", Button.x, Button.y, Button.width, Button.height)
        love.graphics.printf(Button.text, Button.x, Button.y+10, Button.width, "center")
    end
    love.graphics.print("Selection:  " .. selection)
    love.graphics.print("Really good title screen", Inits.GameWidth/2, 150)
    
end

return TitleScreen