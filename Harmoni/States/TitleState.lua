local TitleState = State()
local noteLanes = {}
function TitleState:enter()
    logo = love.graphics.newImage("Images/TITLE/logo.png")
    backgroundFade = {0}
    onTitle = true
    logoYPos = {20}
    lettersPositions = {0,0,0,0,0,0,0}
    curScreen = "title"
    titleState = 1

    beatBump = {1}



    H = love.graphics.newImage("Images/TITLE/H.png")
    A = love.graphics.newImage("Images/TITLE/A.png")
    R = love.graphics.newImage("Images/TITLE/R.png")
    M = love.graphics.newImage("Images/TITLE/M.png")
    O = love.graphics.newImage("Images/TITLE/O.png")
    N = love.graphics.newImage("Images/TITLE/N.png")
    I = love.graphics.newImage("Images/TITLE/I.png")



    gradient = love.graphics.newImage("Images/TITLE/gradient.png")
    logoSize = 1
    resetMenuMusic = function()
        doingTitleMusicReset = true
        MenuMusic = nil
        
        print("resetMenuMusic")
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

        chartRandomXPositions = {}
        speedTitle = 0.6
        logoSize = 1
        curSelection = 1
        buttonWidth = {0,0,0,0,0,0}  -- what does this even do???????   nvm lmao i found it (its bad when this is how i see my own code)
        ButtonLabels = {"Play", "Options", "Credits", "Donate", "GitHub", "Discord"}

        if not MenuMusic then
            notes = {}
            bumpNotes = {}
            quaverParse(("Music/" .. songList[selectedSong] .. "/" .. diffList[randomDifficulty]))
            for i = 1,#diffList do
                print(diffList[i])
            end

            for i = 1,#chart.HitObjects do
                local hitObject = chart.HitObjects[i]
                local startTime = hitObject.StartTime
                local endTime = hitObject.EndTime or 0
                local lane = hitObject.Lane
                table.insert(chartRandomXPositions, love.math.random(0,Inits.GameWidth))
                table.insert(noteLanes, lane)
                table.insert(notes, startTime)
                table.insert(bumpNotes, startTime)
                lastNoteTime = startTime -- this should work because the last time its run will be the last note
            end
            MenuMusic = love.audio.newSource("Music/" .. songList[selectedSong] .. "/" .. metaData.song, "stream")
            background = love.graphics.newImage("Music/" .. songList[selectedSong] .. "/" .. metaData.background)
            MenuMusic:play()
            MusicTime = 0
            doingTitleMusicReset = false
        end
    
    end
    titleTip()

    if State.last() ~= States.SongSelectState and State.last() ~= States.SettingsState and State.last() ~= States.CreditsState then  --shut up i know its bad

        resetMenuMusic()
    else
        logoYPos = {-200}
        titleState = 2
    end
    printablespeedTitle = speedTitle *(logoSize+0.7)

end

function TitleState:update(dt)

    ButtonLabels[1] = (tostring(logoSize))
    

    if #bumpNotes == 0 then
        bumpNotes = notes
    end

    for i = 1,#bumpNotes do
        if -(MusicTime - bumpNotes[i]) < 0 then
            table.remove(bumpNotes, i)
            TitleState:logoBump()
            break
        end
    end
    for i = 1,#ButtonLabels do
        if i == curSelection then
            buttonWidth[i] = math.min(15, buttonWidth[i] + 250*dt)
        else
            buttonWidth[i] = math.max(0, buttonWidth[i] - 250*dt)
        end
    end

    logoSize = math.max(logoSize - 20*dt, 1)

    if Input:pressed("MenuConfirm") then
        if titleState == 1 then
            TitleState:switchMenu()

        elseif titleState == 2 then
           -- MenuMusicLocation = MenuMusic:tell()
           -- MenuMusicNumber = randomSong
            onTitle = false
           -- MenuMusic:stop()
           if curSelection == 1 then
                State.switch(States.SongSelectState)
           elseif curSelection == 2 then
                State.switch(States.SettingsState)
           elseif curSelection == 3 then
                State.switch(States.CreditsState)
           elseif curSelection == 4 then
                love.system.openURL("https://ko-fi.com/harmoni69655")
           elseif curSelection == 5 then
                love.system.openURL("https://github.com/clothing-hanger/Harmoni")
           elseif curSelection == 6 then
            love.system.openURL("https://discord.gg/bBcjrRAeh4")
        end

        end
    elseif Input:pressed("MenuDown") then
            curSelection = curSelection + 1
        
    elseif Input:pressed("MenuUp") then
            curSelection = curSelection - 1
    end

    if curSelection > #ButtonLabels then
        curSelection = 1
    elseif curSelection < 1 then
        curSelection = #ButtonLabels
    end

    if not MenuMusic:isPlaying() and onTitle and not doingTitleMusicReset then
        resetMenuMusic()
    end

    printablespeedTitle = speedTitle *(logoSize+0.7)

    TitleState:doBPMshit()
end


function TitleState:doBPMshit()
    if not bpmIsInit then
        bpmIsInit = true
        BpmTimerStartTime = nil
        nextBeat = nil
    end
    for i = 1, #timingPointsTable do
        if timingPointsTable[i][1] then
            if MusicTime >= timingPointsTable[i][1] then
                currentBpm = timingPointsTable[i][2]
                print("BPM change: " .. currentBpm)
                table.remove(timingPointsTable, i)
                break
            end
        else
            if currentBpm ~= metaData.bpm then
                currentBpm = metaData.bpm
                notification("BPM Not Found", notifErrorIcon)
            end
        end
    end
    if not BpmTimerStartTime and MusicTime > 0 then
        BpmTimerStartTime = MusicTime
        nextBeat = BpmTimerStartTime + (60000/(currentBpm or 0))
        print("First BpmTimerStartTime: " .. BpmTimerStartTime)
    end
    if nextBeat and MusicTime >= nextBeat then
        TitleState:beat()
        BpmTimerStartTime = MusicTime
        nextBeat = BpmTimerStartTime + (60000/(currentBpm or 0))
    end
end

function TitleState:beat()


    beatBump = {1.015 + logoSize/230, 100/225, 100/255, 0}

    if beatBumpTimer then
        Timer.cancel(beatBumpTimer)
    end
    beatBumpTimer = Timer.tween((60000/currentBpm)/1000, beatBump, {[1] = 1, [2] = 1, [3] = 1, [4] = 1}, "out-quad") -- lmfao why does bounce look genuinely better   yeah lmao i changed my mind about using a bounce tween
end


function scrollTitleButtons(scroll)
    curSelection = curSelection-scroll
    if curSelection > #ButtonLabels then
        curSelection = 1
    elseif curSelection < 1 then 
        curSelection = #ButtonLabels 
    end
end

function TitleState:switchMenu()
    Timer.tween(1, logoYPos, {-200}, "out-expo")
    titleState = 2
end

function TitleState:logoBump()
    logoSize = math.min(logoSize + 1.5, 35)
end



function titleTip()
    imageTip = false
    if tipTween then
        Timer.cancel(tipTween)
    end
    randomRareTip = love.math.random(0.8, 100)
    if randomRareTip == 1 then
        rareTip = true
    end
    tipBoxBarLenght = {1}
    local dontgetthesamefuckingtip = currentTip
    local tip 
    if rareTip then
        randomTip = love.math.random(1, #extremeRareTips)
        tip = extremeRareTips[randomTip]
        if extremeRareTips[randomTip][2] then
            imageTip = true
        end
    else
        randomTip = love.math.random(1, #Tips)
        tip = Tips[randomTip]
        if Tips[randomTip][2] then
            imageTip = true
        end
    end
    currentTip = tip
    if dontgetthesamefuckingtip == currentTip then
        titleTip()
    else
        tipTween = Timer.tween(5, tipBoxBarLenght, {0}, "linear", function() titleTip() end)
    end
    rareTip = false
end

--there was never anything here             what used to be here lmao
function TitleState:draw()
    love.graphics.setColor(1,1,1,0.5)
    if background then
        love.graphics.draw(background, Inits.GameWidth/2, Inits.GameHeight/2, nil, Inits.GameWidth/background:getWidth()+((logoSize/230))/6,Inits.GameHeight/background:getHeight()+((logoSize/230))/6, background:getWidth()/2, background:getHeight()/2)
    end
    love.graphics.setColor(1,1,1,((logoSize-1)/80))
    love.graphics.draw(gradient, 0, Inits.GameHeight/2, nil, Inits.GameWidth/gradient:getWidth(),(Inits.GameHeight/gradient:getHeight()/2))
    love.graphics.draw(gradient, 0, Inits.GameHeight/2, nil, Inits.GameWidth/gradient:getWidth(),(Inits.GameHeight/gradient:getHeight()/2))

    love.graphics.draw(gradient, 0, Inits.GameHeight/2, nil, Inits.GameWidth/gradient:getWidth(),-(Inits.GameHeight/gradient:getHeight()/2))
    love.graphics.draw(gradient, 0, Inits.GameHeight/2, nil, Inits.GameWidth/gradient:getWidth(),-(Inits.GameHeight/gradient:getHeight()/2))
    love.graphics.setColor(1,1,1,1)

    love.graphics.setColor(0,0,0,backgroundFade[1])
    love.graphics.rectangle("fill", 0,0,Inits.GameWidth,Inits.GameHeight)
    love.graphics.setColor(1,1,1,1)
   -- love.graphics.translate(0,-100) 
    if #notes > 0 and #chartRandomXPositions > 0 then
        for i = 1,#notes do
            if -(MusicTime - notes[i])*speedTitle < Inits.GameHeight+100 then
                love.graphics.setColor(1,1,1,0.1+(logoSize-1)*25)

                
                if noteLanes[i] == 1 then
                  --  love.graphics.draw(H, chartRandomXPositions[i], -(MusicTime - notes[i])*printablespeedTitle)
                elseif noteLanes[i] == 2 then
                  --  love.graphics.draw(R, chartRandomXPositions[i], -(MusicTime - notes[i])*printablespeedTitle)
                elseif noteLanes[i] == 3 then
                  --  love.graphics.draw(O, chartRandomXPositions[i], -(MusicTime - notes[i])*printablespeedTitle)
                elseif noteLanes[i] == 4 then
                  --  love.graphics.draw(I, chartRandomXPositions[i], -(MusicTime - notes[i])*printablespeedTitle)
                end

                --]]
                love.graphics.setColor(1,1,1,1)
            end
        end
    end

  
  -- love.graphics.draw(logo, logo:getWidth()/2, Inits.GameHeight/2-logo:getHeight()/2+100, nil, logoSize, math.min(logoSize+((logoSize-1)*3), 1.5), logo:getWidth()/2, logo:getHeight()/2)
    love.graphics.push()
    love.graphics.translate(30,0)
    love.graphics.translate(Inits.GameWidth/2, Inits.GameHeight/2)
    love.graphics.translate(0,logoYPos[1]/1.1)

    love.graphics.scale(beatBump[1], beatBump[1])

    love.graphics.translate(-Inits.GameWidth/2, -Inits.GameHeight/2)

    love.graphics.setColor((beatBump[4] or 1), (beatBump[2] or 1), (beatBump[3] or 1))

    love.graphics.draw(H, Inits.GameWidth/2-H:getWidth()/2-425-(logoSize*3), Inits.GameHeight/2-H:getHeight()/2-28)
    love.graphics.draw(A, Inits.GameWidth/2-A:getWidth()/2-285-(logoSize*2), Inits.GameHeight/2-A:getHeight()/2)
    love.graphics.draw(R, Inits.GameWidth/2-R:getWidth()/2-160-(logoSize), Inits.GameHeight/2-R:getHeight()/2)
    love.graphics.draw(M, Inits.GameWidth/2-M:getWidth()/2, Inits.GameHeight/2-M:getHeight()/2)
    love.graphics.draw(O, Inits.GameWidth/2-O:getWidth()/2+170+(logoSize), Inits.GameHeight/2-O:getHeight()/2)
    love.graphics.draw(N, Inits.GameWidth/2-N:getWidth()/2+300+(logoSize*2), Inits.GameHeight/2-N:getHeight()/2)
    love.graphics.draw(I, Inits.GameWidth/2-I:getWidth()/2+395+(logoSize*3), Inits.GameHeight/2-I:getHeight()/2-25)


    love.graphics.pop()
    love.graphics.translate(Inits.GameWidth/2-logo:getWidth()/2,logoYPos[1])

   love.graphics.translate(0,logoYPos[1])

    love.graphics.setColor(0,0,0,0.9)

    love.graphics.rectangle("fill", -400, 1050, 300, 150, 7, 7, 50)
    love.graphics.setColor(1,1,1)
  
  --  love.graphics.setColor(0,1,1)
    --love.graphics.line(-400,1200,-100,1200*tipBoxBarLenght[1])


    love.graphics.setFont(MenuFontSmall)

    if imageTip then
        love.graphics.draw(currentTip[2], -400, 1050, nil, 300/currentTip[2]:getWidth(), 150/currentTip[2]:getHeight())
        love.graphics.printf(currentTip[1], -390, 1060, 280,"center")
    else
        love.graphics.printf(currentTip, -390, 1060, 280,"center")
    end
    love.graphics.rectangle("fill", -400,1190,300*tipBoxBarLenght[1],10, 7, 7, 50)

    love.graphics.printf(versionNumber, 350, 1180, 500, "right")

    love.graphics.rectangle("line", -400, 1050, 300, 150, 7, 7, 50)


    for i = 1,#ButtonLabels do
        if i == curSelection then
            love.graphics.setColor(0,0,0,0.9)
        else
            love.graphics.setColor(1,1,1,0.9)
        end
        love.graphics.rectangle("fill", logo:getWidth()/2-120-buttonWidth[i], (850+((30+logoSize/2)*i)), 240+(buttonWidth[i]*2), 25, 7, 7, 50)
        if i == curSelection then
            love.graphics.setColor(0,1,1)
        else
            love.graphics.setColor(0,0.7,0.7)
        end 
        love.graphics.rectangle("line", logo:getWidth()/2-120-buttonWidth[i], 850+((30+logoSize/2)*i), 240+(buttonWidth[i]*2), 25, 7, 7, 50)
        love.graphics.printf(ButtonLabels[i], logo:getWidth()/2-120, 850+((30+logoSize/2)*i), 240, "center")
    end





 --   love.graphics.rectangle()


end

return TitleState