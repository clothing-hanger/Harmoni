local TitleState = State()
local noteLanes = {}
function TitleState:enter()
    resetMenuMusic = function()
        songList = love.filesystem.getDirectoryItems("Music")
        randomSong = love.math.random(1,#songList)
        diffList = {}
        selectedSong = love.math.random(1,#songList)
        diffListAndOtherShitIdfk = love.filesystem.getDirectoryItems("Music/" .. songList[selectedSong] .. "/")
        for i = 1,#diffListAndOtherShitIdfk do 
            local file = diffListAndOtherShitIdfk[i]
            if file:endsWith("qua") then
                table.insert(diffList, file)
            end
        end
        for i = 1,#diffListAndOtherShitIdfk do
            print(diffListAndOtherShitIdfk[i])
        end
        randomDifficulty = love.math.random(1, #diffList)
        logo = love.graphics.newImage("Images/TITLE/logo.png")
        backgroundFade = {0}
        onTitle = true
        logoYPos = {20}
        titleState = 1
        curScreen = "title"
        H = love.graphics.newImage("Images/TITLE/H.png")
        R = love.graphics.newImage("Images/TITLE/R.png")  -- the notes in the background originally were part of the logo, thats why their file name is letters
        O = love.graphics.newImage("Images/TITLE/O.png")
        I = love.graphics.newImage("Images/TITLE/I.png")
        gradient = love.graphics.newImage("Images/TITLE/gradient.png")
        chartRandomXPositions = {}
        speed = 0.6
        logoSize = 1
        curSelection = 1
        buttonWidth = {0,0,0}
        notes = {}
        bumpNotes = {}
        chart = tinyyaml.parse(love.filesystem.read("Music/" .. songList[selectedSong] .. "/" .. diffList[randomDifficulty]))
        for i = 1,#diffList do
            print(diffList[i])
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
        for i = 1,#chart.HitObjects do
            local hitObject = chart.HitObjects[i]
            local startTime = hitObject.StartTime
            local endTime = hitObject.EndTime or 0
            local lane = hitObject.Lane


            table.insert(chartRandomXPositions, love.math.random(0,love.graphics.getWidth()))
            table.insert(noteLanes, lane)
            table.insert(notes, startTime)
            table.insert(bumpNotes, startTime)
            lastNoteTime = startTime -- this should work because the last time its run will be the last note
        end
        MenuMusic = love.audio.newSource("Music/" .. songList[selectedSong] .. "/" .. metaData.song, "stream")
        background = love.graphics.newImage("Music/" .. songList[selectedSong] .. "/" .. metaData.background)
        MenuMusic:play()
        MusicTime = 0
    end
    resetMenuMusic()
end

function TitleState:update(dt)
    MusicTime = MusicTime + (love.timer.getTime() * 1000) - (previousFrameTime or (love.timer.getTime()*1000))
    previousFrameTime = love.timer.getTime() * 1000

    for i = 1,#bumpNotes do
        if -(MusicTime - bumpNotes[i]) < 10 then
            table.remove(bumpNotes, i)
            TitleState:logoBump()
            break
        end
    end
    for i = 1,3 do
        if i == curSelection then
            buttonWidth[i] = math.min(15, buttonWidth[i] + 250*dt)
        else
            buttonWidth[i] = math.max(0, buttonWidth[i] - 250*dt)
        end
    end

    logoSize = math.max(logoSize - 0.15*dt, 1)

    if Input:pressed("MenuConfirm") then
        if titleState == 1 then
            TitleState:switchMenu()

        elseif titleState == 2 then
            MenuMusicLocation = MenuMusic:tell()
            MenuMusicNumber = randomSong
            comingFromTitle = true
            onTitle = false
            MenuMusic:stop()
            State.switch(States.SongSelectState)
        end
    elseif Input:pressed("MenuDown") then
        if curSelection < 3 then
            curSelection = curSelection + 1
        else
            curSelection = 1
        end
    elseif Input:pressed("MenuUp") then
        if curSelection == 1 then
            curSelection = 3
        else
            curSelection = curSelection - 1
        end
    end

    if not MenuMusic:isPlaying() and onTitle then
        resetMenuMusic()
    end

    printableSpeed = speed *(logoSize+0.7)

end

function scrollTitleButtons(scroll)
    curSelection = curSelection-scroll
    if curSelection > 3 then
        curSelection = 1
    elseif curSelection < 1 then 
        curSelection = 3 
    end
end

function TitleState:switchMenu()
    Timer.tween(1, logoYPos, {-200}, "out-expo")
    titleState = 2
end



function TitleState:logoBump()
    logoSize = math.min(logoSize + 0.01, 1.3)
end
--there was never anything here
function TitleState:draw()
    love.graphics.setColor(1,1,1,0.5)

    love.graphics.draw(background, love.graphics.getWidth()/2, love.graphics.getHeight()/2, nil, love.graphics.getWidth()/background:getWidth()+(logoSize-1)/6,love.graphics.getHeight()/background:getHeight()+(logoSize-1)/6, background:getWidth()/2, background:getHeight()/2)
    love.graphics.setColor(1,1,1,(logoSize-1)+0.15)
    love.graphics.draw(gradient, 0, love.graphics.getHeight()/2, nil, love.graphics.getWidth()/gradient:getWidth(),(love.graphics.getHeight()/gradient:getHeight()/2))
    love.graphics.setColor(1,1,1,1)

    love.graphics.setColor(0,0,0,backgroundFade[1])
    love.graphics.rectangle("fill", 0,0,love.graphics.getWidth(),love.graphics.getHeight())
    love.graphics.setColor(1,1,1,1)
    love.graphics.translate(0,-100)
    for i = 1,#notes do
        if -(MusicTime - notes[i])*speed < love.graphics.getHeight()+100 then
            love.graphics.setColor(1,1,1,0.1+(logoSize-1)*25)

            
            if noteLanes[i] == 1 then
                love.graphics.draw(H, chartRandomXPositions[i], -(MusicTime - notes[i])*printableSpeed)
            elseif noteLanes[i] == 2 then
                love.graphics.draw(R, chartRandomXPositions[i], -(MusicTime - notes[i])*printableSpeed)
            elseif noteLanes[i] == 3 then
                love.graphics.draw(O, chartRandomXPositions[i], -(MusicTime - notes[i])*printableSpeed)
            elseif noteLanes[i] == 4 then
                love.graphics.draw(I, chartRandomXPositions[i], -(MusicTime - notes[i])*printableSpeed)
            end

            --]]
            love.graphics.setColor(1,1,1,1)
        end
    end
    love.graphics.translate(love.graphics.getWidth()/2-logo:getWidth()/2,logoYPos[1])

    love.graphics.draw(logo, logo:getWidth()/2, love.graphics.getHeight()/2-logo:getHeight()/2+100, nil, logoSize, math.min(logoSize+((logoSize-1)*3), 1.5), logo:getWidth()/2, logo:getHeight()/2)
    love.graphics.translate(0,logoYPos[1])
    love.graphics.rectangle("line", logo:getWidth()/2-120-buttonWidth[3], 850, 240+(buttonWidth[3]*2), 25)
    --love.graphics.setFont(MenuFontExtraSmall)
    love.graphics.setFont(MenuFontSmall)

    love.graphics.printf("Credits", logo:getWidth()/2-120, 850, 240, "center")


    love.graphics.translate(0,-30)
    love.graphics.rectangle("line", logo:getWidth()/2-120-buttonWidth[2], 850, 240+(buttonWidth[2]*2), 25)
    love.graphics.printf("Options", logo:getWidth()/2-120, 850, 240, "center")



    love.graphics.translate(0,-30)
    love.graphics.rectangle("line", logo:getWidth()/2-120-buttonWidth[1], 850, 240+(buttonWidth[1]*2), 25)
    love.graphics.printf("Play", logo:getWidth()/2-120, 850, 240, "center")


end

return TitleState