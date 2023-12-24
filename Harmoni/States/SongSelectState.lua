local SongSelectState = State()

function SongSelectState:enter()

    backgroundFade = {0}
    songMenuBounceIn = {450}
    songList = love.filesystem.getDirectoryItems("Music")
    --selectedSong = randomSong
    selectedDiff = 1
    printableSongList = {selectedSong}
    printableDiffList = {selectedDiff}
    

    SongSelectState:PlayMenuMusic()
    songListXPPos = {}
    for i = 1,#songList do
        table.insert(songListXPPos,900)
    end
    resetDiffListXPPos = function()
        diffListXPPos = {}

        for i = 1,#diffList do
            table.insert(diffListXPPos,900)
        end
    end
    resetDiffListXPPos()
    Timer.tween(2, songMenuBounceIn, {0}, "in-bounce")
    disc = love.graphics.newImage("Images/SONGSELECT/disc.png")
    loading = love.graphics.newImage("Images/SONGSELECT/loading.png")
    discRotation = 0
    curScreen = "songSelect"
end

function SongSelectState:update(dt)


    if Input:pressed("MenuDown") then
        if selectedSong ~= #songList then
            selectedSong = selectedSong + 1
        else
            selectedSong = 1
        end
        SongSelectState:TweenSongList()
        resetDiffListXPPos()
    elseif Input:pressed("MenuUp") then
        if selectedSong == 1 then
            selectedSong = #songList
        else
            selectedSong = selectedSong - 1
        end
        SongSelectState:TweenSongList()
        resetDiffListXPPos()
    elseif Input:pressed("MenuConfirm") then
        if difficultySelect then
            State.switch(States.PlayState)
        end
        difficultySelect = not difficultySelect

        MusicTime = -math.huge

    elseif Input:pressed("MenuBack") then
        if difficultySelect then
            difficultySelect = false
        end
    end

 
    for i = 1,#songListXPPos do
        local songOutPos = 800
        local songInPos = 900

        if i ~= selectedSong then
            if songListXPPos[i] ~= songInPos then
                songListXPPos[i] = math.min(songListXPPos[i]+800*dt, songInPos)
            end
        else
            if songListXPPos[i] ~= songOutPos then
                songListXPPos[i] = math.max(songListXPPos[i]-800*dt, songOutPos)
            end
        end
    end
    for i = 1,#diffListXPPos do
        local songOutPos = 800
        local songInPos = 900
        if i ~= selectedDiff then
            if diffListXPPos[i] ~= songInPos then
                diffListXPPos[i] = math.min(diffListXPPos[i]+800*dt, songInPos)
            end
        else
            if diffListXPPos[i] ~= songOutPos then
                diffListXPPos[i] = math.max(diffListXPPos[i]-800*dt, songOutPos)
            end
        end
    end

    
    discRotation = discRotation + 5*dt
end

function scrollSongs(scroll)
    MenuMusic:stop()
    MenuMusic = nil
    background = nil
    if not difficultySelect then
        selectedSong = selectedSong-scroll
        if selectedSong > #songList then
            selectedSong = 1
        elseif selectedSong < 1 then 
            selectedSong = #songList 
        end
        SongSelectState:TweenSongList()
        resetDiffListXPPos()
    else
--[[
        if scroll < 0 then
            selectedDiff = selectedDiff + 1
        else
            selectedDiff = selectedDiff - 1
        end
--]]
        selectedDiff = selectedDiff-scroll
        if selectedDiff > #diffList then
            selectedDiff = 1
        elseif selectedDiff < 1 then
            selectedDiff = #diffList
        end
        print(selectedDiff)
        
        resetDiffListXPPos()

        SongSelectState:TweenSongList()
    end
end

function SongSelectState:PlayMenuMusic()
    if MenuMusic then
        MenuMusic:stop()
    end
    diffList = {}
    DiffNameList = {}
    diffListAndOtherShitIdfk = love.filesystem.getDirectoryItems("Music/" .. songList[selectedSong] .. "/")
    for i = 1,#diffListAndOtherShitIdfk do 
        local file = diffListAndOtherShitIdfk[i]
        if file:endsWith("qua") then
            table.insert(diffList, file)
        end
    end
    if selectedDiff > #diffList then
        selectedDiff = 1
    end
    chart = tinyyaml.parse(love.filesystem.read("Music/" .. songList[selectedSong] .. "/" .. diffList[selectedDiff]))
    for i = 1,#diffList do
        table.insert(DiffNameList, chart.DifficultyName)
    end
    metaData = {
        name = chart.Title,
        song = chart.AudioFile,
        artist = chart.Artist,
        source = chart.Source, -- not sure what this one even is really
        tags = chart.Tags, -- not gonna be used in this file but im putting it here for now so i dont forget it
        diffName = chart.DifficultyName,
        creator = chart.Creator,
        background = chart.BackgroundFile,
        previewTime = chart.PreviewTime or 0, -- also wont be used here
        noteCount = 0,
        length = 0,
        bpm = 0,   -- idk if ill ever use bpm 😭😭 idk how it works
        inputMode = chart.Mode:gsub("Keys", ""),  -- will be used to make sure its 4 key
    }
    MenuMusic = love.audio.newSource("Music/" .. songList[selectedSong] .. "/" .. metaData.song, "stream")


    MenuMusic:seek(titleSongLocation)
    titleSongLocation = 0
    MenuMusic:play()



    if backgroundFadeTween then Timer.cancel(backgroundFadeTween) end

    backgroundFadeTween = Timer.tween(0.1, backgroundFade, {1}, "linear", function()
        discRotation = 0
        background = love.graphics.newImage("Music/" .. songList[selectedSong] .. "/" .. metaData.background)
        if backgroundFadeTween then Timer.cancel(backgroundFadeTween) end
        backgroundFadeTween = Timer.tween(0.1, backgroundFade, {0})
    end)
end

function switchMenuAssets()
   -- background = 
end

function SongSelectState:TweenSongList()
    if songListTween then
        Timer.cancel(songListTween)
    end
    songListTween = Timer.tween(0.3, printableSongList, {selectedSong}, "out-quad")
    SongSelectState:PlayMenuMusic()

    if diffListTween then
        Timer.cancel(diffListTween)
    end
    diffListTween = Timer.tween(0.3, printableDiffList, {selectedDiff}, "out-quad")
end

function SongSelectState:draw()

    if background then
            love.graphics.draw(background, 0, 0, nil, love.graphics.getWidth()/background:getWidth(),love.graphics.getHeight()/background:getHeight())

    end
    love.graphics.setColor(0,0,0,0.9)
    love.graphics.rectangle("fill", 0, 0, 500, 200)
    love.graphics.setColor(0,1,1)
    love.graphics.rectangle("line", 0, 0, 500, 200)
    love.graphics.setFont(MenuFontBig)
    love.graphics.printf("Now Playing: ", 20, 20, 500)
    love.graphics.setFont(MenuFontSmall)

    love.graphics.printf(metaData.name.."\n" ..metaData.diffName .. "\nArtist- " .. metaData.artist .. "\nCharter- " .. metaData.creator, 20, 60, 480)



    love.graphics.setColor(0,0,0,0.9)
    love.graphics.rectangle("fill", love.graphics.getWidth()-250, 0, 250, 50)
    love.graphics.setColor(0,1,1)

    love.graphics.rectangle("line", love.graphics.getWidth()-250, 0, 250, 50)
    love.graphics.printf(#songList.." Songs Found", love.graphics.getWidth()-240, 10, 240, "left")
    love.graphics.push()

    love.graphics.setColor(0.75,0.75,0.75)

    love.graphics.draw(disc, 450, 150, discRotation, 0.08, 0.08,disc:getWidth()/2,disc:getHeight()/2)



    love.graphics.pop()





    love.graphics.setColor(0,0,0,backgroundFade[1])

    
    love.graphics.rectangle("fill", 0,0,love.graphics.getWidth(),love.graphics.getHeight())
    
   love.graphics.setColor(1,1,1, backgroundFade[1])

    love.graphics.draw(loading, love.graphics.getWidth()/2, love.graphics.getHeight()/2, -discRotation, 0.08, 0.08,loading:getWidth()/2,loading:getHeight()/2)

    love.graphics.setColor(1,1,1,1)
    love.graphics.push()
    love.graphics.translate(songMenuBounceIn[1], 300)

    if not difficultySelect then

        for i = 1,#songList do
            if i == selectedSong then
                love.graphics.setColor(0,0,0,0.9)
                love.graphics.rectangle("fill", songListXPPos[i], (110*i)-(printableSongList[1]*110), 3000, 100)
                love.graphics.setColor(0,1,1)
                love.graphics.rectangle("line", songListXPPos[i], (110*i)-(printableSongList[1]*110), 3000, 100)
                love.graphics.print(songList[i], songListXPPos[i]+10, (110*i)+10-(printableSongList[1] *110))
            else
                love.graphics.setColor(0,0,0,0.9)
                love.graphics.rectangle("fill", songListXPPos[i], (110*i)-(printableSongList[1]*110), 3000, 100)
                love.graphics.setColor(0,1,1)
                love.graphics.rectangle("line", songListXPPos[i], (110*i)-(printableSongList[1]*110), 3000, 100)
                love.graphics.print(songList[i], songListXPPos[i]+10, (110*i)+10-(printableSongList[1] *110))
            end
        end
    else
        for i = 1,#diffList do        -- diffList, selectedDiff, diffListXPPos, printableDiffList
            if i == selectedDiff then
                love.graphics.setColor(0,0,0,0.9)
                love.graphics.rectangle("fill", diffListXPPos[i], (110*i)-(printableDiffList[1]*110), 3000, 100)
                love.graphics.setColor(0,1,1)
                love.graphics.rectangle("line", diffListXPPos[i], (110*i)-(printableDiffList[1]*110), 3000, 100)
                love.graphics.print(diffList[i], diffListXPPos[i]+10, (110*i)+10-(printableDiffList[1] *110))
            else
                love.graphics.setColor(0,0,0,0.9)
                love.graphics.rectangle("fill", diffListXPPos[i], (110*i)-(printableDiffList[1]*110), 3000, 100)
                love.graphics.setColor(0,1,1)
                love.graphics.rectangle("line", diffListXPPos[i], (110*i)-(printableDiffList[1]*110), 3000, 100)
                love.graphics.print(diffList[i], diffListXPPos[i]+10, (110*i)+10-(printableDiffList[1] *110))
            end
        end
    end

    


    love.graphics.setFont(DefaultFont)

    love.graphics.pop()
end

return SongSelectState