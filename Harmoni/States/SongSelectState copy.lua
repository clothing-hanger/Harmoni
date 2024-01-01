local SongSelectState = State()

function SongSelectState:enter()
    curScreen = "songSelect" 
    songList = love.filesystem.getDirectoryItems("Music")
    selectedSong = 1
    printableSelectedSong = {selectedSong} -- used for scrolling song list
    selectedDifficulty = 1
    printableSelectedDifficulty = {selectedDifficulty} -- used for scrolling diff list 
    SongListXPositions = {}
    LaneWidth = 120
    diffList = {}
    diffListAndOtherShitIdfk = love.filesystem.getDirectoryItems("Music/" .. songList[selectedSong] .. "/")
    for i = 1,#diffListAndOtherShitIdfk do 
        local file = diffListAndOtherShitIdfk[i]
        if file:endsWith("qua") then
            table.insert(diffList, file)
        end
    end

    speed = 1.6
    lane1={}
    lane2={}
    lane3={}
    lane4={}
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

    disc = love.graphics.newImage("Images/SONGSELECT/disc.png")
    loading = love.graphics.newImage("Images/SONGSELECT/loading.png")
    discRotation = 0

    for i = 1,#songList do
        table.insert(SongListXPositions, 900)
    end

    for i = 1,#diffList do
        print(diffList[i])
    end
end

function SongSelectState:update(dt)
    MusicTime = MusicTime + (love.timer.getTime() * 1000) - (previousFrameTime or (love.timer.getTime()*1000))
    previousFrameTime = love.timer.getTime() * 1000

    if Input:pressed("MenuDown") then
        selectedSong = selectedSong+1
        SongSelectState:loadSong()
    elseif Input:pressed("MenuUp") then
        selectedSong = selectedSong-1
        SongSelectState:loadSong()
    end

    for i = 1,#SongListXPositions do
        if i == selectedSong then
            SongListXPositions[i] = math.max(SongListXPositions[i]-500*dt, 800)
        else
            SongListXPositions[i] = math.min(SongListXPositions[i]+500*dt, 900)
        end
    end

    if songListTween then
        Timer.cancel(songListTween)
    end
    songListTween = Timer.tween(0.2, printableSelectedSong, {selectedSong}, "out-quad")
    if selectedSong < 1 then
        selectedSong = #songList
    elseif selectedSong > #songList then
        selectedSong = 1
    end

end

function SongSelectState:loadSong()
    if menuSongTimer then
        Timer.cancel(menuSongTimer)
    end
    menuSongTimer = Timer.after(1, function()
        MenuMusic:stop()
        diffList = {}
        diffListAndOtherShitIdfk = love.filesystem.getDirectoryItems("Music/" .. songList[selectedSong] .. "/")
        for i = 1,#diffListAndOtherShitIdfk do 
            local file = diffListAndOtherShitIdfk[i]
            if file:endsWith("qua") then
                table.insert(diffList, file)
            end
        end
        quaverParse("Music/" .. songList[selectedSong] .. "/" .. diffList[selectedDifficulty])
        print(songList[selectedSong])
        print(diffList[selectedDifficulty])
        MusicTime = 0
        MenuMusic = love.audio.newSource("Music/" .. songList[selectedSong] .. "/" .. metaData.song, "stream")
        MenuMusic:play()
        selectedDifficulty = 1
    end)
end

function scrollSongs(y)
    selectedSong = selectedSong - y
    MenuMusic:stop()
    SongSelectState:loadSong()
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
    love.graphics.setFont(MenuFontSmall)
    love.graphics.translate(0, -(printableSelectedSong[1]*60)+love.graphics.getHeight()/2)
    for i = 1,#songList do
        if i == selectedSong then
            love.graphics.rectangle("line", SongListXPositions[i], i*60, 1000, 50)
            love.graphics.print(songList[i], SongListXPositions[i], i*60)
        else
            love.graphics.rectangle("line", SongListXPositions[i], i*60, 1000, 50)
            love.graphics.print(songList[i], SongListXPositions[i], i*60)
        end
    end
    love.graphics.pop()
    love.graphics.push()
    love.graphics.translate(-390,205)
   -- love.graphics.scale(0.5,0.5)
    love.graphics.draw(ReceptorLeft, love.graphics.getWidth()/2-(LaneWidth*2), 0)
    love.graphics.draw(ReceptorDown, love.graphics.getWidth()/2-(LaneWidth), 0)
    love.graphics.draw(ReceptorUp, love.graphics.getWidth()/2, 0)
    love.graphics.draw(ReceptorRight, love.graphics.getWidth()/2+(LaneWidth), 0)



    for i = 1,#lane1 do
        if -(MusicTime - lane1[i])*speed1 < love.graphics.getHeight() then
            if MenuMusic:isPlaying() then love.graphics.draw(NoteLeft, love.graphics.getWidth()/2-(LaneWidth*2), -(MusicTime - lane1[i])*speed1) end
        end
    end

    for i = 1,#lane2 do
        if -(MusicTime - lane2[i])*speed2 < love.graphics.getHeight() then
            if MenuMusic:isPlaying() then love.graphics.draw(NoteDown, love.graphics.getWidth()/2-LaneWidth, -(MusicTime - lane2[i])*speed2) end
        end
    end


    for i = 1,#lane3 do
        if -(MusicTime - lane3[i])*speed3 < love.graphics.getHeight() then
            if MenuMusic:isPlaying() then love.graphics.draw(NoteUp, love.graphics.getWidth()/2, -(MusicTime - lane3[i])*speed3) end
        end
    end
    for i = 1,#lane4 do
        if -(MusicTime - lane4[i])*speed4 < love.graphics.getHeight() then
            if MenuMusic:isPlaying() then   love.graphics.draw(NoteRight, love.graphics.getWidth()/2+LaneWidth, -(MusicTime - lane4[i])*speed4) end
        end
    end
    love.graphics.pop()

end

return SongSelectState