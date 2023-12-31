local TitleState = State()
local noteLanes = {}
function TitleState:enter()
    logo = love.graphics.newImage("Images/TITLE/logo.png")
    backgroundFade = {0}
    onTitle = true
    logoYPos = {20}
    curScreen = "title"
    titleState = 1
    H = love.graphics.newImage("Images/TITLE/H.png")
    R = love.graphics.newImage("Images/TITLE/R.png")  -- the notes in the background originally were part of the logo, thats why their file name is letters
    O = love.graphics.newImage("Images/TITLE/O.png")
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
        buttonWidth = {0,0,0}

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

    if State.last() ~= States.SongSelectState and State.last() ~= States.SettingsState then

        resetMenuMusic()
    else
        logoYPos = {-200}
        titleState = 2
    end
        

end

function TitleState:update(dt)

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
           -- MenuMusicLocation = MenuMusic:tell()
           -- MenuMusicNumber = randomSong
            onTitle = false
           -- MenuMusic:stop()
           if curSelection == 1 then
                State.switch(States.SongSelectState)
           elseif curSelection == 2 then
                State.switch(States.SettingsState)
           --     love.window.showMessageBox("Not Implimented Yet :(", "as a temporary way to edit settings, open the file 'settings.lua' (located in the Harmoni folder) in a text editor")
           elseif curSelection == 3 then
            love.window.showMessageBox("Not Implimented Yet :(", "no credits menu yet, but credits are to me (clothing hanger) for like most of it, \nguglioisstupid and Rit for quaver chart parsing code, \nand the charters to all the songs i stole from quaver \n(they are listed at the top right of the screen in the song select menu)")
           end
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

    if not MenuMusic:isPlaying() and onTitle and not doingTitleMusicReset then
        resetMenuMusic()
    end

    printablespeedTitle = speedTitle *(logoSize+0.7)
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

function titleTip()
    if tipTween then
        Timer.cancel(tipTween)
    end
    tipBoxBarLenght = {1}
    local dontgetthesamefuckingtip = currentTip
    local tip = Tips[love.math.random(1,#Tips)]
    currentTip = tip
    if dontgetthesamefuckingtip == currentTip then
        titleTip()
    else
        tipTween = Timer.tween(5, tipBoxBarLenght, {0},"linear",function() titleTip() end)
    end
end


--there was never anything here
function TitleState:draw()
    love.graphics.setColor(1,1,1,0.5)

    love.graphics.draw(background, Inits.GameWidth/2, Inits.GameHeight/2, nil, Inits.GameWidth/background:getWidth()+(logoSize-1)/6,Inits.GameHeight/background:getHeight()+(logoSize-1)/6, background:getWidth()/2, background:getHeight()/2)
    love.graphics.setColor(1,1,1,(logoSize-1))
    love.graphics.draw(gradient, 0, Inits.GameHeight/2, nil, Inits.GameWidth/gradient:getWidth(),(Inits.GameHeight/gradient:getHeight()/2))
    love.graphics.draw(gradient, 0, Inits.GameHeight/2, nil, Inits.GameWidth/gradient:getWidth(),(Inits.GameHeight/gradient:getHeight()/2))

    love.graphics.draw(gradient, 0, Inits.GameHeight/2, nil, Inits.GameWidth/gradient:getWidth(),-(Inits.GameHeight/gradient:getHeight()/2))
    love.graphics.draw(gradient, 0, Inits.GameHeight/2, nil, Inits.GameWidth/gradient:getWidth(),-(Inits.GameHeight/gradient:getHeight()/2))
    love.graphics.setColor(1,1,1,1)

    love.graphics.setColor(0,0,0,backgroundFade[1])
    love.graphics.rectangle("fill", 0,0,Inits.GameWidth,Inits.GameHeight)
    love.graphics.setColor(1,1,1,1)
    love.graphics.translate(0,-100)
    if #notes > 0 and #chartRandomXPositions > 0 then
        for i = 1,#notes do
            if -(MusicTime - notes[i])*speedTitle < Inits.GameHeight+100 then
                love.graphics.setColor(1,1,1,0.1+(logoSize-1)*25)

                
                if noteLanes[i] == 1 then
                    love.graphics.draw(H, chartRandomXPositions[i], -(MusicTime - notes[i])*printablespeedTitle)
                elseif noteLanes[i] == 2 then
                    love.graphics.draw(R, chartRandomXPositions[i], -(MusicTime - notes[i])*printablespeedTitle)
                elseif noteLanes[i] == 3 then
                    love.graphics.draw(O, chartRandomXPositions[i], -(MusicTime - notes[i])*printablespeedTitle)
                elseif noteLanes[i] == 4 then
                    love.graphics.draw(I, chartRandomXPositions[i], -(MusicTime - notes[i])*printablespeedTitle)
                end

                --]]
                love.graphics.setColor(1,1,1,1)
            end
        end
    end
    love.graphics.translate(Inits.GameWidth/2-logo:getWidth()/2,logoYPos[1])

    love.graphics.draw(logo, logo:getWidth()/2, Inits.GameHeight/2-logo:getHeight()/2+100, nil, logoSize, math.min(logoSize+((logoSize-1)*3), 1.5), logo:getWidth()/2, logo:getHeight()/2)
    love.graphics.translate(0,logoYPos[1])

    love.graphics.setColor(0,0,0,0.9)

    love.graphics.rectangle("fill", -400, 1050, 300, 150)
    love.graphics.setColor(1,1,1)
  
    love.graphics.rectangle("line", -400, 1050, 300, 150)
  --  love.graphics.setColor(0,1,1)
    --love.graphics.line(-400,1200,-100,1200*tipBoxBarLenght[1])

    love.graphics.rectangle("fill", -400,1180,300*tipBoxBarLenght[1],20)

    love.graphics.setFont(MenuFontSmall)

    love.graphics.printf(currentTip, -390, 1060, 280,"center")

    if curSelection == 3 then
        love.graphics.setColor(0,0,0,0.9)
    else
        love.graphics.setColor(1,1,1,0.9)
    end    
    love.graphics.rectangle("fill", logo:getWidth()/2-120-buttonWidth[3], 850, 240+(buttonWidth[3]*2), 25)
    if curSelection == 3 then
        love.graphics.setColor(0,1,1)
    else
        love.graphics.setColor(0,0.7,0.7)
    end 
    love.graphics.rectangle("line", logo:getWidth()/2-120-buttonWidth[3], 850, 240+(buttonWidth[3]*2), 25)
    if curSelection == 3 then
        love.graphics.setColor(0,1,1)
    else
        love.graphics.setColor(0,0,0)
    end 
    love.graphics.printf("Credits", logo:getWidth()/2-120, 850, 240, "center")


    love.graphics.translate(0,-30)
    if curSelection == 2 then
        love.graphics.setColor(0,0,0,0.9)
    else
        love.graphics.setColor(1,1,1,0.9)
    end
    love.graphics.rectangle("fill", logo:getWidth()/2-120-buttonWidth[2], 850, 240+(buttonWidth[2]*2), 25)
    if curSelection == 2 then
        love.graphics.setColor(0,1,1)
    else
        love.graphics.setColor(0,0.7,0.7)
    end 
    love.graphics.rectangle("line", logo:getWidth()/2-120-buttonWidth[2], 850, 240+(buttonWidth[2]*2), 25)
    if curSelection == 2 then
        love.graphics.setColor(0,1,1)
    else
        love.graphics.setColor(0,0,0)
    end
    love.graphics.printf("Options", logo:getWidth()/2-120, 850, 240, "center")

    love.graphics.translate(0,-30)
    if curSelection == 1 then
        love.graphics.setColor(0,0,0,0.9)
    else
        love.graphics.setColor(1,1,1,0.9)
    end
    love.graphics.rectangle("fill", logo:getWidth()/2-120-buttonWidth[1], 850, 240+(buttonWidth[1]*2), 25)
    if curSelection == 1 then
        love.graphics.setColor(0,1,1)
    else
        love.graphics.setColor(0,0.7,0.7)
    end     
    love.graphics.rectangle("line", logo:getWidth()/2-120-buttonWidth[1], 850, 240+(buttonWidth[1]*2), 25)
    if curSelection == 1 then
        love.graphics.setColor(0,1,1)
    else
        love.graphics.setColor(0,0,0)
    end
    love.graphics.printf("Play", logo:getWidth()/2-120, 850, 240, "center")


 --   love.graphics.rectangle()


end

return TitleState