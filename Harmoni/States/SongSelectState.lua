local SongSelectState = State()

function SongSelectState:enter()
    backgroundFade = {0}
    songMenuBounceIn = {450}
    songList = love.filesystem.getDirectoryItems("Music")
    printableList = ""
    for i = 1,#songList do
        printableList = printableList .. songList[i] .. "\n"
    end
    selectedSong = randomSong
    printableSongList = {selectedSong}
    SongSelectState:PlayMenuMusic()
    songListXPPos = {}
    for i = 1,#songList do
        table.insert(songListXPPos,900)
    end
    
    Timer.tween(2, songMenuBounceIn, {0}, "in-bounce")
    disc = love.graphics.newImage("Images/SONGSELECT/disc.png")
    loading = love.graphics.newImage("Images/SONGSELECT/loading.png")
    discRotation = 0
end

function SongSelectState:update(dt)

    if Input:pressed("MenuDown") then
        if selectedSong ~= #songList then
            selectedSong = selectedSong + 1
        else
            selectedSong = 1
        end
        SongSelectState:TweenSongList()
    elseif Input:pressed("MenuUp") then
        if selectedSong == 1 then
            selectedSong = #songList
        else
            selectedSong = selectedSong - 1
        end
        SongSelectState:TweenSongList()
    elseif Input:pressed("MenuConfirm") then
        State.switch(States.PlayState)
        MusicTime = -math.huge  -- there is no fucking way this isnt low enough of a number
        MenuMusic:stop()
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
    discRotation = discRotation + 5*dt
end

function scrollSongs(scroll)
    selectedSong = selectedSong-scroll
    if selectedSong > #songList then
        selectedSong = 1
    elseif selectedSong < 1 then 
        selectedSong = #songList 
    end
    SongSelectState:TweenSongList()
end

function SongSelectState:PlayMenuMusic()
    if MenuMusic then
        MenuMusic:stop()
    end
    MenuMusic = love.audio.newSource("Music/" .. songList[selectedSong] .. "/audio.mp3", "stream")

    MenuMusic:seek(titleSongLocation)
    titleSongLocation = 0
    MenuMusic:play()



    if backgroundFadeTween then Timer.cancel(backgroundFadeTween) end

    backgroundFadeTween = Timer.tween(0.1, backgroundFade, {1}, "linear", function()
        discRotation = 0
        background = love.graphics.newImage("Music/" .. songList[selectedSong] .. "/background.jpg")
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

    love.graphics.printf(songList[selectedSong], 20, 60, 480)



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
    love.graphics.setFont(DefaultFont)

    love.graphics.pop()
end

return SongSelectState