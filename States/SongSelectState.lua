local SongSelectState = State()

function SongSelectState:enter()
    backgroundFade = {0}

    songList = love.filesystem.getDirectoryItems("Music")
    printableList = ""
    for i = 1,#songList do
        printableList = printableList .. songList[i] .. "\n"
    end
    selectedSong = 1
    printableSongList = {selectedSong}
    SongSelectState:PlayMenuMusic()
    songListXPPos = {}
    for i = 1,#songList do
        table.insert(songListXPPos,900)
    end
end

function SongSelectState:update(dt)
    if Input:pressed("GameDown") then
        if selectedSong ~= #songList then
            selectedSong = selectedSong + 1
        else
            selectedSong = 1
        end
        SongSelectState:TweenSongList()
    elseif Input:pressed("GameUp") then
        if selectedSong == 1 then
            selectedSong = #songList
        else
            selectedSong = selectedSong - 1
        end
        SongSelectState:TweenSongList()
    elseif Input:pressed("GameConfirm") then
        State.switch(States.PlayState)
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
end

function SongSelectState:PlayMenuMusic()
    if MenuMusic then
        MenuMusic:stop()
    end
    MenuMusic = love.audio.newSource("Music/" .. songList[selectedSong] .. "/audio.mp3", "stream")
    MenuMusic:play()

    if backgroundFadeTween then Timer.cancel(backgroundFadeTween) end

    backgroundFadeTween = Timer.tween(0.1, backgroundFade, {1}, "linear", function()
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
        love.graphics.draw(background)
    end
    love.graphics.setColor(0,0,0,backgroundFade[1])
    love.graphics.rectangle("fill", 0,0,love.graphics.getWidth(),love.graphics.getHeight())
    love.graphics.setColor(1,1,1,1)
    love.graphics.push()
    love.graphics.translate(0, 300)


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
    love.graphics.pop()
end

return SongSelectState