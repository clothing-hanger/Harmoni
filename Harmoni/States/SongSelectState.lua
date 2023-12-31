local SongSelectState = State()

function SongSelectState:enter()

    backgroundFade = {0}
    songMenuBounceIn = {450}
    songList = love.filesystem.getDirectoryItems("Music")
    --selectedSong = randomSong
    selectedDiff = 1
    printableSongList = {selectedSong}
    printableDiffList = {selectedDiff}
    
    lane1 = {}
    lane2 = {}
    lane3 = {}
    lane4 = {}

    speed = 1.6

    speed1 = speed
    speed2 = speed
    speed3 = speed
    speed4 = speed

    NoteLeft = love.graphics.newImage("Images/NOTES/NoteLeft.png")
    NoteDown = love.graphics.newImage("Images/NOTES/NoteDown.png")
    NoteUp = love.graphics.newImage("Images/NOTES/NoteUp.png")
    NoteRight = love.graphics.newImage("Images/NOTES/NoteRight.png")

    ReceptorLeft = love.graphics.newImage("Images/RECEPTORS/ReceptorLeft.png")
    ReceptorDown = love.graphics.newImage("Images/RECEPTORS/ReceptorDown.png")
    ReceptorUp = love.graphics.newImage("Images/RECEPTORS/ReceptorUp.png")
    ReceptorRight = love.graphics.newImage("Images/RECEPTORS/ReceptorRight.png")

    LaneWidth = 120


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


    SongSelectState:displayChart()
end

function SongSelectState:update(dt)
    resetDiffListXPPos()
    MusicTime = MusicTime + (love.timer.getTime() * 1000) - (previousFrameTime or (love.timer.getTime()*1000))
    previousFrameTime = love.timer.getTime() * 1000

    if Input:pressed("MenuDown") then
        if not difficultySelect then
            if selectedSong ~= #songList then
                selectedSong = selectedSong + 1
            else
                selectedSong = 1
            end
        else
            if selectedDiff ~= #diffList then
                selectedDiff = selectedDiff + 1
            else
                selectedDiff = 1
            end
        end
        SongSelectState:TweenSongList()
        resetDiffListXPPos()
    elseif Input:pressed("MenuUp") then
        if not difficultySelect then
            if selectedSong == 1 then
                selectedSong = #songList
            else
                selectedSong = selectedSong - 1
            end
        else
            if selectedDiff == 1 then
                selectedDiff = #diffList
            else
                selectedDiff = selectedDiff - 1
            end
        end
        SongSelectState:TweenSongList()
        resetDiffListXPPos()
    elseif Input:pressed("MenuConfirm") then
        if difficultySelect then
            MusicTime = -math.huge

            State.switch(States.PlayState)
        end
        difficultySelect = not difficultySelect


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
    if #lane1+#lane2+#lane3+#lane4 > 0 then
         SongSelectState:checkBotInput()
    end
    if MenuMusic and MenuMusic:isPlaying() then  --not sure why it only works like this
        discRotation = discRotation + 5*dt
    end
    --else
      --  lane1 = {}
        --lane2 = {}
        --lane3 = {}
        --lane4 = {}
   -- end
end

function SongSelectState:displayChart()
    lane1 = {}
    lane2 = {}
    lane3 = {}
    lane4 = {}
    quaverParse("Music/" .. songList[selectedSong] .. "/" .. diffList[selectedDiff])
    MusicTime = 0
end

function scrollSongs(scroll)
    if MenuMusic then
    MenuMusic:stop()
    end
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
    SongSelectState:displayChart()
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
    MusicTime = 0


    SongSelectState:displayChart()
    if backgroundFadeTween then Timer.cancel(backgroundFadeTween) end

    backgroundFadeTween = Timer.tween(0.1, backgroundFade, {1}, "linear", function()
        discRotation = 0
        if love.filesystem.exists("Music/" .. songList[selectedSong] .. "/" .. metaData.background) then
            background = love.graphics.newImage("Music/" .. songList[selectedSong] .. "/" .. metaData.background)
        end
        if backgroundFadeTween then Timer.cancel(backgroundFadeTween) end
        backgroundFadeTween = Timer.tween(0.1, backgroundFade, {0})
    end)
end

function SongSelectState:checkBotInput()
    for i = 1, #lane1 do
        local NoteTime = lane1[i] - MusicTime
        if NoteTime < 0 then
            table.remove(lane1, i)
            break
        end
    end
    for i = 1, #lane2 do
        local NoteTime = lane2[i] - MusicTime
        if NoteTime < 0 then
            table.remove(lane2, i)
            break
        end
    end
    for i = 1, #lane3 do
        local NoteTime = lane3[i] - MusicTime
        if NoteTime < 0 then
            table.remove(lane3, i)
            break
        end
    end
    for i = 1, #lane4 do
        local NoteTime = lane4[i] - MusicTime
        if NoteTime < 0 then
            table.remove(lane4, i)
            break
        end
    end
end

function switchMenuAssets()
   -- background = 
end

function SongSelectState:TweenSongList()
    if songListTween then
        Timer.cancel(songListTween)
    end
    songListTween = Timer.tween(0.3, printableSongList, {selectedSong}, "out-quad")
    if MenuMusicTimer then
        Timer.cancel(MenuMusicTimer)
    end
    MenuMusicTimer = Timer.after(0.1, function()
        SongSelectState:PlayMenuMusic()
    end)

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
    love.graphics.pop()

    love.graphics.setColor(1,1,1,1)

    love.graphics.push()
    love.graphics.translate(-390,205)
   -- love.graphics.scale(0.5,0.5)
    love.graphics.draw(ReceptorLeft, love.graphics.getWidth()/2-(LaneWidth*2), 0)
    love.graphics.draw(ReceptorDown, love.graphics.getWidth()/2-(LaneWidth), 0)
    love.graphics.draw(ReceptorUp, love.graphics.getWidth()/2, 0)
    love.graphics.draw(ReceptorRight, love.graphics.getWidth()/2+(LaneWidth), 0)



    for i = 1,#lane1 do
        if -(MusicTime - lane1[i])*speed1 < love.graphics.getHeight() then
            love.graphics.draw(NoteLeft, love.graphics.getWidth()/2-(LaneWidth*2), -(MusicTime - lane1[i])*speed1)
        end
    end

    for i = 1,#lane2 do
        if -(MusicTime - lane2[i])*speed2 < love.graphics.getHeight() then
            love.graphics.draw(NoteDown, love.graphics.getWidth()/2-LaneWidth, -(MusicTime - lane2[i])*speed2)
        end
    end


    for i = 1,#lane3 do
        if -(MusicTime - lane3[i])*speed3 < love.graphics.getHeight() then
            love.graphics.draw(NoteUp, love.graphics.getWidth()/2, -(MusicTime - lane3[i])*speed3)
        end
    end
    for i = 1,#lane4 do
        if -(MusicTime - lane4[i])*speed4 < love.graphics.getHeight() then
            love.graphics.draw(NoteRight, love.graphics.getWidth()/2+LaneWidth, -(MusicTime - lane4[i])*speed4)
        end
    end
    love.graphics.pop()

    


    love.graphics.setFont(DefaultFont)

end

return SongSelectState