local SongSelectState = State()
local AllDirections = {
    "Left",
    "Down",
    "Up",
    "Right",
}
function SongSelectState:enter()
    curScreen = "songSelect" 
    songList = love.filesystem.getDirectoryItems("Music")
    --selectedSong = randomSong
    menuState = 1
    printableSelectedSong = {selectedSong} -- used for scrolling song list
    selectedDifficulty = 1
    printableSelectedDifficulty = {selectedDifficulty} -- used for scrolling diff list 
    SongListXPositions = {}
    diffListXPositions = {}
    DiffNameList = {}
    diffList = {}
    diffListAndOtherShitIdfk = love.filesystem.getDirectoryItems("Music/" .. songList[selectedSong] .. "/")
    for i = 1,#diffListAndOtherShitIdfk do 
        local file = diffListAndOtherShitIdfk[i]
        if file:endsWith("qua") then
            table.insert(diffList, file)
        end
    end
    lanes = {}
    for i = 1,4 do
        table.insert(lanes, {})
    end
    search = ""

--[]
    NoteLeft = NoteLeftImage
    NoteDown = NoteDownImage
    NoteUp = NoteUpImage
    NoteRight = NoteRightImage

    ReceptorLeft = ReceptorLeftImage
    ReceptorDown = ReceptorDownImage
    ReceptorUp = ReceptorUpImage
    ReceptorRight = ReceptorRightImage

    disc = love.graphics.newImage("Images/SONGSELECT/disc.png")
    loading = love.graphics.newImage("Images/SONGSELECT/loading.png")
    discRotation = 0

    for i = 1,#songList do
        table.insert(SongListXPositions, 900)
    end

    for i = 1,#diffList do
        table.insert(diffListXPositions, 900)
    end
    if State.last() ~= States.TitleState then
        SongSelectState:loadSong(true)
    else
        SongSelectState:loadSong(false)
        backgroundFade[1] = 1
    end
    
end

function SongSelectState:update(dt)
    MusicTime = MusicTime + (love.timer.getTime() * 1000) - (previousFrameTime or (love.timer.getTime()*1000))
    previousFrameTime = love.timer.getTime() * 1000

    if State.last() == States.PlayState and not MenuMusic:isPlaying() and not dontFuckingReloadTheSongEveryFrameDumbass then
       -- MenuMusic:stop()
       dontFuckingReloadTheSongEveryFrameDumbass = true
        SongSelectState:loadSong(true)
    end
        if Input:pressed("MenuDown") then
            if menuState == 1 then
                selectedSong = selectedSong+1
                SongSelectState:loadSong(true)
            elseif menuState == 2 then
                selectedDifficulty = selectedDifficulty+1
                SongSelectState:loadSong(false)
            end
          --  SongSelectState:loadSong()
        elseif Input:pressed("MenuUp") then
            if menuState == 1 then  
                selectedSong = selectedSong-1
                SongSelectState:loadSong(true)
            elseif menuState == 2 then
                selectedDifficulty = selectedDifficulty-1
                SongSelectState:loadSong(false)
            end
        elseif Input:pressed("MenuConfirm") then
            if menuState == 1 then
                menuState = 2
                selectedDifficulty = 1
            elseif menuState == 2 then
                if MenuMusic:isPlaying() then
                    State.switch(States.PlayState)
                end
            end
        elseif Input:pressed("MenuBack") then
            if menuState == 2 then
                menuState = 1
            elseif menuState == 1 then
                State.switch(States.TitleState)
            end

        elseif Input:pressed("openSongGoogleDrive") then
            love.system.openURL("https://drive.google.com/drive/folders/1MpRIkEXY1FmRLVSEzlWHJzWJScREgD37?usp=drive_link")  --lmao google drive 
        elseif Input:pressed("openSongFolder") then
            os.execute("start " .. love.filesystem.getSaveDirectory() .. "/Music")
        elseif Input:pressed("randomSongKey") then
            selectedDifficulty = 1
            selectedSong = love.math.random(1,#songList)
            SongSelectState:loadSong(true)
        end


    if MenuMusic:isPlaying() then
        discRotation = discRotation + 5*dt
    end

    for i = 1,#SongListXPositions do
        if i == selectedSong then
            SongListXPositions[i] = math.max(SongListXPositions[i]-500*dt, 800)
        else
            SongListXPositions[i] = math.min(SongListXPositions[i]+500*dt, 900)
        end
    end
    if doDiffListTween then
        for i = 1,#diffListXPositions do
            if i == selectedDifficulty then
                diffListXPositions[i] = math.max(diffListXPositions[i]-500*dt, 800)
            else
                diffListXPositions[i] = math.min(diffListXPositions[i]+500*dt, 900)
            end
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
    if selectedDifficulty < 1 then
        selectedDifficulty = #diffList
    elseif selectedDifficulty > #diffList then
        selectedDifficulty = 1
    end
end

function searchSongs()
    print("searchSongs()")
    local searchSongList = love.filesystem.getDirectoryItems("Music")
    songList = {}
    for word in search:gmatch("([^ ]+)") do
        for i, k in ipairs(searchSongList) do
            if k:match(word) then
                table.insert(songList, searchSongList[i])
            end
        end
    end
end


function SongSelectState:loadSong(doSongRestart)
    doDiffListTween = false

    if doSongRestart then
        selectedDifficulty = 1
    end
    if menuSongTimer then
        Timer.cancel(menuSongTimer)
    end
    menuSongTimer = Timer.after(menuSongDelayTime, function()       -- make a setting
        if doSongRestart then
            MenuMusic:stop()
        end
        local savedDiffPositions = {}
        for i = 1,#diffListXPositions do
            if diffListXPositions[i] ~= 900 then
                table.insert(savedDiffPositions, {diffListXPositions[i], i})
            end
        end
        diffList = {}
        diffListXPositions = {}
    
        diffListAndOtherShitIdfk = love.filesystem.getDirectoryItems("Music/" .. songList[selectedSong] .. "/")
        for i = 1,#diffListAndOtherShitIdfk do 
            local file = diffListAndOtherShitIdfk[i]
            if file:endsWith("qua") then
                table.insert(diffList, file)
            end
        end
        for i = 1,#diffList do
            table.insert(diffListXPositions, 900)
        end
        for i = 1,#savedDiffPositions do
            table.insert(diffListXPositions, savedDiffPositions[i][2], savedDiffPositions[i][1])
        end
        if selectedDifficulty < 1 then
            selectedDifficulty = #diffList
        elseif selectedDifficulty > #diffList then
            selectedDifficulty = 1
        end
        quaverParse("Music/" .. songList[selectedSong] .. "/" .. diffList[selectedDifficulty])
        --[[ print(songList[selectedSong])
        print(diffList[selectedDifficulty]) ]]
        
        if doSongRestart then
            MusicTime = metaData.previewTime
            MenuMusic = love.audio.newSource("Music/" .. songList[selectedSong] .. "/" .. metaData.song, "stream")
            MenuMusic:play()
            if metaData.previewTime/1000 <= 0 then
            else
                MenuMusic:seek(metaData.previewTime/1000)
            end

        end
        if backgroundFadeTween then Timer.cancel(backgroundFadeTween) end

        backgroundFadeTween = Timer.tween(0.1, backgroundFade, {1}, "linear", function()
            discRotation = 0
         --   if love.filesystem.getInfo("Music/" .. songList[selectedSong] .. "/" .. metaData.background) then
             --   background = love.graphics.newImage("Music/" .. songList[selectedSong] .. "/" .. metaData.background)
          --  end
            if backgroundFadeTween then Timer.cancel(backgroundFadeTween) end
            backgroundFadeTween = Timer.tween(0.1, backgroundFade, {0})
        end)
    end)

  --  for i,diff in ipairs(diffList) do
  --      quaverParse("Music/" .. songList[selectedSong] .. "/" .. diffList[i])
    --    table.insert(DiffNameList, metaData.diffName)
   -- end
   doDiffListTween = true


end

function scrollSongs(y)

    if menuState == 1 then  
        selectedSong = selectedSong - y
        MenuMusic:stop()
        SongSelectState:loadSong(true)
    elseif menuState == 2 then
        selectedDifficulty = selectedDifficulty - y
        SongSelectState:loadSong(false)
    end
end

function SongSelectState:draw()
    
    if background then
        love.graphics.draw(background, 0, 0, nil, Inits.GameWidth/background:getWidth(),Inits.GameHeight/background:getHeight())
    end
    love.graphics.push()
    love.graphics.translate(-390,205)
    for i = 1,4 do
        love.graphics.draw(_G["Receptor" .. AllDirections[i]], Inits.GameWidth/2-(LaneWidth*2)+(LaneWidth*(i-1)), not downScroll and 0 or 385,nil,125/_G["Receptor" .. AllDirections[i]]:getWidth(),125/_G["Receptor" .. AllDirections[i]]:getHeight())
    end

    for i, lane in ipairs(lanes) do
        for k, note in ipairs(lane) do
            local topPos = not downScroll and 0 or -385
            local bottomPos = not downScroll and 485 or 385
            if -(MusicTime - note.time)*_G["speed" .. i] < bottomPos and -(MusicTime - note.time)*_G["speed" .. i] > topPos then
                if MenuMusic:isPlaying() then 
                    love.graphics.draw(_G["Note" .. AllDirections[i]], Inits.GameWidth/2-(LaneWidth*2)+(LaneWidth*(i-1)), -(MusicTime - note.time)*_G["speed" .. i],nil,125/_G["Note" .. AllDirections[i]]:getWidth(),125/_G["Note" .. AllDirections[i]]:getHeight())
                end
            end
        end
    end
    love.graphics.pop()
    love.graphics.setColor(0,0,0,0.9)

    love.graphics.rectangle("fill", 0, 0, 500, 200, 7, 7, 50)
    love.graphics.setColor(0.5,0.5,0.5)
    if banner then
        love.graphics.draw(banner, 0, 0, nil, 500/banner:getWidth(), 97/banner:getHeight())
    end
    love.graphics.setColor(0,1,1)

    love.graphics.rectangle("line", 0, 0, 500, 200, 7, 7, 50)
    love.graphics.setFont(MenuFontBig)
    love.graphics.printf("Now Playing: ", 20, 20, 500)
    love.graphics.setFont(MenuFontSmall)
    love.graphics.printf(metaData.name.."\n" ..metaData.diffName .. "\nArtist- " .. metaData.artist .. "\nCharter- " .. metaData.creator, 20, 60, 480)
    love.graphics.print(search, 500, 500)
    love.graphics.push()
    love.graphics.setColor(0.75,0.75,0.75)
    love.graphics.draw(disc, 450, 150, discRotation, 0.08, 0.08,disc:getWidth()/2,disc:getHeight()/2)
    love.graphics.pop()
    love.graphics.setColor(0,0,0,backgroundFade[1])
    love.graphics.rectangle("fill", 0,0,Inits.GameWidth,Inits.GameHeight)
    love.graphics.setColor(1,1,1, backgroundFade[1])
    love.graphics.draw(loading, Inits.GameWidth/2, Inits.GameHeight/2, -discRotation, 0.08, 0.08,loading:getWidth()/2,loading:getHeight()/2)
    love.graphics.setColor(1,1,1,1)
    love.graphics.setFont(MenuFontSmall)
    love.graphics.push()
    if menuState == 1 then
        love.graphics.push()
        love.graphics.translate(0, -(printableSelectedSong[1]*60)+Inits.GameHeight/2)

        for i = 1,#songList do

            if i == selectedSong then
                love.graphics.setColor(0,0,0,0.9)
                love.graphics.rectangle("fill", SongListXPositions[i], i*60, 1000, 50, 7, 7, 50)
                love.graphics.setColor(0,1,1)
                love.graphics.rectangle("line", SongListXPositions[i], i*60, 1000, 50, 7, 7, 50)
                love.graphics.print(songList[i], SongListXPositions[i]+12, i*60+12)
            else
                love.graphics.rectangle("fill", SongListXPositions[i], i*60, 1000, 50, 7, 7, 50)
                love.graphics.setColor(0,0.8,0.8)

                love.graphics.rectangle("line", SongListXPositions[i], i*60, 1000, 50, 7, 7, 50)
                love.graphics.setColor(0,0,0,0.8)

                love.graphics.print(songList[i], SongListXPositions[i]+12, i*60+12)
            end
            love.graphics.setColor(1,1,1)

        end

        love.graphics.pop()

    elseif menuState == 2 then
        love.graphics.push()
        love.graphics.translate(0, -(selectedDifficulty*60)+Inits.GameHeight/2)

        for i = 1,#diffList do
            if i == selectedDifficulty then
                love.graphics.setColor(0,0,0,0.9)
                love.graphics.rectangle("fill", diffListXPositions[i], i*60, 1000, 50, 7, 7, 50)
                love.graphics.setColor(0,1,1)

                love.graphics.rectangle("line", diffListXPositions[i], i*60, 1000, 50, 7, 7, 50)
                love.graphics.print(diffList[i], diffListXPositions[i]+12, i*60+12)
            else
                love.graphics.setColor(1,1,1,0.9)
                love.graphics.rectangle("fill", diffListXPositions[i], i*60, 1000, 50, 7, 7, 50)
                love.graphics.setColor(0,0.8,0.8)

                love.graphics.rectangle("line", diffListXPositions[i], i*60, 1000, 50, 7, 7, 50)
                love.graphics.print(diffList[i], diffListXPositions[i]+12, i*60+12)
            end
        end
        love.graphics.pop()

    end
    love.graphics.pop()

    love.graphics.push()
    love.graphics.setColor(0,0,0,0.9)
    love.graphics.rectangle("fill", Inits.GameWidth-300, 0, 300, 80, 7, 7, 50)
    love.graphics.setColor(0,1,1)
    love.graphics.rectangle("line", Inits.GameWidth-300, 0, 300, 80, 7, 7, 50)
    love.graphics.setFont(MenuFontExtraSmall)
    love.graphics.printf(#songList.." Songs Found\nPress F1 to download Song Packs\nPress F2 to open Music Folder", Inits.GameWidth-290, 10, 290, "left")
   -- love.graphics.scale(0.5,0.5)
   love.graphics.setColor(1,1,1)
    love.graphics.pop()

end

return SongSelectState