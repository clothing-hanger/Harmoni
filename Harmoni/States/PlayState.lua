local PlayState = State()
function PlayState:enter()

    --load assets


    hitTimes = {}
    curScreen = "play"

    
    lane1 = {}
    lane2 = {}
    lane3 = {}
    lane4 = {}

    MusicTime = -2000


    if MenuMusic then
        MenuMusic:stop()
    end

    quaverParse("Music/" .. songList[selectedSong] .. "/" .. diffList[selectedDiff])




    ReceptorLeft = love.graphics.newImage("Images/RECEPTORS/ReceptorLeft.png")
    ReceptorDown = love.graphics.newImage("Images/RECEPTORS/ReceptorDown.png")
    ReceptorUp = love.graphics.newImage("Images/RECEPTORS/ReceptorUp.png")
    ReceptorRight = love.graphics.newImage("Images/RECEPTORS/ReceptorRight.png")
    ReceptorLeftPressed = love.graphics.newImage("Images/RECEPTORS/ReceptorPressedLeft.png")
    ReceptorDownPressed = love.graphics.newImage("Images/RECEPTORS/ReceptorPressedDown.png")
    ReceptorUpPressed = love.graphics.newImage("Images/RECEPTORS/ReceptorPressedUp.png")
    ReceptorRightPressed = love.graphics.newImage("Images/RECEPTORS/ReceptorPressedRight.png")
    NoteLeft = love.graphics.newImage("Images/NOTES/NoteLeft.png")
    NoteDown = love.graphics.newImage("Images/NOTES/NoteDown.png")
    NoteUp = love.graphics.newImage("Images/NOTES/NoteUp.png")
    NoteRight = love.graphics.newImage("Images/NOTES/NoteRight.png")
    Marvelous = love.graphics.newImage("Images/JUDGEMENTS/Marvelous.png")
    Perfect = love.graphics.newImage("Images/JUDGEMENTS/Perfect.png")
    Great = love.graphics.newImage("Images/JUDGEMENTS/Great.png")
    Good = love.graphics.newImage("Images/JUDGEMENTS/Good.png")
    Okay = love.graphics.newImage("Images/JUDGEMENTS/Okay.png")
    Miss = love.graphics.newImage("Images/JUDGEMENTS/Miss.png")
    HealthImage = love.graphics.newImage("Images/HUD/health.png")

    
    marvTiming = 36
    perfTiming = 86
    greatTiming = 136
    goodTiming = 186
    okayTiming = 236
    missTiming = 286

    marvCount = 0
    perfCount = 0
    greatCount = 0
    goodCount = 0
    okayCount = 0
    missCount = 0
    judgeCounterXPos = {0,0,0,0,0,0}





    --set variables
    MusicTime = -10000
    speed = 1.6
    downScroll = false
    if downScroll then
        speed = -speed
    end
    speed1 = speed
    speed2 = speed
    speed3 = speed
    speed4 = speed
    LaneWidth = 120
    health = 1
    timeRemainingBar = {love.graphics.getWidth()}
    paused = false
    judgeColors = {0,0,0,0,0,0}
    judgePos = {0}
    gameOverNotePush = {1}
    gameOver = false
    gameOverSongSlowdown = {1}
    backgroundDim = {0}
    comboSize = {1}
    backgroundDimSetting = 0.9 
    score = 0
    accuracy = 0
    currentBestPossibleScore = 0
    combo = 0
    printableScore = {score}
    printableHealth = {health}
    convertedAccuracy = 0
    printableAccuracy = {accuracy}




    BotPlay = false


    dimBackground()


end
function PlayState:update(dt)
    MusicTime = MusicTime + (love.timer.getTime() * 1000) - (previousFrameTime or (love.timer.getTime()*1000))
    previousFrameTime = love.timer.getTime() * 1000
    if paused or gameOver then
        MusicTime = PausedMusicTime
    end

    if BotPlay then
        checkBotInput()
    else
        checkInput()
    end
    checkMiss()

    if MusicTime >= 0 and not song:isPlaying() and MusicTime < 1000 --[[ to make sure it doesnt restart --]] then
        song:play()
    
        -- songLengthTimer = (Timer.tween(songLength, timeRemainingBar, {0}))  -- if it works it works lmfao
        songLengthTimer = (Timer.tween(songLengthToLastNote, timeRemainingBar, {0})) 
    end

    if Input:pressed("GameConfirm") then
        pause()
    end

    if printableHealth[1] < 0 then
        printableHealth[1] = 0
    end

    if (#lane1+#lane2+#lane3+#lane4 == 0) or gameOver and MusicTime > 1 and not paused then
        resultsScreen = true
        if Input:pressed("MenuConfirm") then
            resultsScreen = false
            PlayState:leave(States.SongSelectState)
        end
    end   
    
    if printableHealth[1] <= 0 and not gameOver then            
        PlayState:gameOver()
    end
    if gameOverSongSlowdown[1] ~= 1 then
        if songLengthTimer then
            Timer.cancel(songLengthTimer)
        end
        song:setPitch(gameOverSongSlowdown[1])
        print(gameOverSongSlowdown[1])
    end


end
 
function pause()
    if not resultsScreen then
        paused = not paused
        PausedMusicTime = MusicTime
        if paused then
            song:pause()
        else
            song:play()
        end
    end
end

function PlayState:gameOver()
    PausedMusicTime = MusicTime
    paused = true
    if gameOverSongSlowdown[1] == 1 then
        --song:setPitch(-1)
        gameOverNotePush = {0}
        gameOverTween = Timer.tween(1.5, gameOverNotePush, {love.graphics.getHeight()/2}, "out-elastic")
        gameOverSongTween = Timer.tween(1.5, gameOverSongSlowdown, {0.01}, "linear", function()
            song:stop()
            paused = false
            gameOver = true
        end)
    end
end

function PlayState:leave(state)
    --song = nil
    background = nil
    State.switch(state)
    resultsScreenTranslate = nil
    resultsScreenTween = nil
end


function checkMiss()
    for i = 1,#lane1 do
        if MusicTime - lane1[i] > missTiming then
            judge(MusicTime - i)
            table.remove(lane1, i)
            health = health - 0.03
            break
        end
    end
    for i = 1,#lane2 do
        if MusicTime - lane2[i] > missTiming then
            judge(MusicTime - i)
            table.remove(lane2, i)
            health = health - 0.03
            break
        end
    end
    for i = 1,#lane3 do
        if MusicTime - lane3[i] > missTiming then
            judge(MusicTime - i)
            table.remove(lane3, i)
            health = health - 0.03
            break
        end
    end
    for i = 1,#lane4 do
        if MusicTime - lane4[i] > missTiming then
            judge(MusicTime - i)
            table.remove(lane4, i)
            health = health - 0.03
            break
        end
    end
end

function incrementCombo()
    combo = combo + 1
    if comboTween then
        Timer.cancel(comboTween)
    end
    comboSize = {1.5}
    comboTween = Timer.tween(0.5, comboSize, {1}, "out-quad")
end

function judge(noteTime)
    
    judgePos = {-10}
    table.insert(hitTimes, {noteTime, MusicTime})

    if math.abs(noteTime) < marvTiming then  -- marvelous
        score = score + bestScorePerNote
        judgeColors = {1,0,0,0,0,0}
        marvCount = marvCount + 1
        judgeCountTween(1)
        incrementCombo()
        health = math.min(health + 0.025, 1)
    elseif math.abs(noteTime) < perfTiming then  -- perfect
        score = score + (bestScorePerNote/2)
        judgeColors = {0,1,0,0,0,0}
        judgeCountTween(2)
        incrementCombo()
        perfCount = perfCount + 1
        health = math.min(health + 0.02, 1)
    elseif math.abs(noteTime) < greatTiming then  -- great
        score = score + (bestScorePerNote/3)
        greatCount = greatCount + 1
        judgeColors = {0,0,1,0,0,0}
        judgeCountTween(3)
        incrementCombo()
        health = math.min(health + 0.01, 1)
    elseif math.abs(noteTime) < goodTiming then  -- good
        score = score + (bestScorePerNote/4)
        judgeColors = {0,0,0,1,0,0}
        judgeCountTween(4)
        incrementCombo()
        goodCount = goodCount + 1
    elseif math.abs(noteTime) < okayTiming then  -- okay
        score = score + (bestScorePerNote/5)
        judgeColors = {0,0,0,0,1,0}
        judgeCountTween(5)
        incrementCombo()
        okayCount = okayCount + 1
        health = health - 0.01
    else                        -- miss lmao fuckin loser
        judgeColors = {0,0,0,0,0,1}
        judgeCountTween(6)
        missCount = missCount + 1
        combo = 0
        health = health - 0.03
    end

    currentBestPossibleScore = currentBestPossibleScore + bestScorePerNote
    accuracy = score/currentBestPossibleScore
    convertedAccuracy = accuracy*100


    printableScoreTween()

    if judgeTween then
        Timer.cancel(judgeTween)
    end
    judgeTween = Timer.tween(0.1, judgePos, {0}, "out-quad")

end

function judgeCountTween(index)
    if _G["judgeCountTween" .. index] then
        Timer.cancel(_G["judgeCountTween" .. index])
    end
    judgeCounterXPos[index] = 10
    _G["judgeCountTween" .. index] = Timer.tween(0.5,judgeCounterXPos,{[index] = 0},"out-quad")
end
function printableScoreTween()
    if scoreTween then
        Timer.cancel(scoreTween)
        Timer.cancel(accuracyTween)
        Timer.cancel(healthTween)
    end
    scoreTween = Timer.tween(0.5, printableScore, {score}, "out-quad")
    accuracyTween = Timer.tween(0.5, printableAccuracy, {convertedAccuracy}, "out-quad")
    healthTween = Timer.tween(0.5, printableHealth, {health}, "out-quad")


end


function dimBackground()
    Timer.tween(1.5, backgroundDim, {backgroundDimSetting}, "linear", function()
        MusicTime = -2000
    end)
end


function checkInput()
    for i = 1,#lane1 do
        local noteTime = lane1[i] - MusicTime
        if noteTime < missTiming and Input:pressed("GameLeft")then
            judge(noteTime)
            table.remove(lane1, i)
            break
        end

    end
    for i = 1,#lane2 do
        local noteTime = lane2[i] - MusicTime
        if noteTime < missTiming and Input:pressed("GameDown")then
            judge(noteTime)
            table.remove(lane2, i)
            break
        end
    end
    for i = 1,#lane3 do
        local noteTime = lane3[i] - MusicTime
        if noteTime < missTiming and Input:pressed("GameUp")then
            judge(noteTime)
            table.remove(lane3, i)
            break
        end
    end
    for i = 1,#lane4 do
        local noteTime = lane4[i] - MusicTime
        if noteTime < missTiming and Input:pressed("GameRight")then
            judge(noteTime)
            table.remove(lane4, i)
            break
        end
    end
end


function checkBotInput()
    for i = 1, #lane1 do
        local NoteTime = lane1[i] - MusicTime
        if NoteTime < -marvTiming/2 then
            judge(NoteTime)
            table.remove(lane1, i)
            break
        end
    end
    for i = 1, #lane2 do
        local NoteTime = lane2[i] - MusicTime
        if NoteTime < -marvTiming/2 then
            judge(NoteTime)
            table.remove(lane2, i)
            break
        end
    end
    for i = 1, #lane3 do
        local NoteTime = lane3[i] - MusicTime
        if NoteTime < -marvTiming/2 then
            judge(NoteTime)
            table.remove(lane3, i)
            break
        end
    end
    for i = 1, #lane4 do
        local NoteTime = lane4[i] - MusicTime
        if NoteTime < -marvTiming/2 then
            judge(NoteTime)
            table.remove(lane4, i)
            break
        end
    end
end
function PlayState:draw()
    love.graphics.setCanvas(GameScreen)


    if resultsScreen then


        if convertedAccuracy == 100 then
            grade = "S+"
        elseif convertedAccuracy > 95 then
            grade = "S"
        elseif convertedAccuracy > 90 then
            grade = "A"
        elseif convertedAccuracy > 80 then
            grade = "B"
        elseif convertedAccuracy > 70 then
            grade = "C"
        else 
            grade = "D"
        end

        if gameOver then
            grade = "F"
        end

        love.graphics.draw(background, 0, 0, nil, love.graphics.getWidth()/background:getWidth(),love.graphics.getHeight()/background:getHeight())

        love.graphics.setColor(0,0,0,backgroundDim[1])
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1,1,1,1)
    
        love.graphics.rectangle("fill", 0, love.graphics.getHeight()-20, timeRemainingBar[1], 20)

        love.graphics.push()
        --love.graphics.printf("PLACEHOLDER RESULTS SCREEN", 0, 280, love.graphics.getWidth(), "center")

       -- love.graphics.printf("Press Enter to Continue.", 0, 320, love.graphics.getWidth(), "center")
       if not resultsScreenTranslate then
        resultsScreenTranslate = {0, 0}
       end

        if resultsScreenTween then
            Timer.cancel(resultsScreenTween)
        end
        resultsScreenTween = Timer.tween(0.5, resultsScreenTranslate, {[1] = love.graphics.getWidth()/2 - 50, [2] = -50}, "out-expo")
    
        

       love.graphics.translate(resultsScreenTranslate[1], resultsScreenTranslate[2])

       love.graphics.setFont(ReallyFuckingBigFont)

        love.graphics.print(grade, -400, love.graphics.getHeight()/2-150)


       love.graphics.setFont(MediumFont)

            love.graphics.print(marvCount,judgeCounterXPos[1], (love.graphics.getHeight()/2)-100)

            love.graphics.print(perfCount,judgeCounterXPos[2], (love.graphics.getHeight()/2)-50)
        love.graphics.setColor(92/255,1, 82/255)

            love.graphics.print(greatCount,judgeCounterXPos[3], (love.graphics.getHeight()/2)+0)
            love.graphics.print(goodCount,judgeCounterXPos[4], (love.graphics.getHeight()/2)+50)
        love.graphics.setColor(1,65/255,65/255)
            love.graphics.print(okayCount,judgeCounterXPos[5], (love.graphics.getHeight()/2)+100)
        love.graphics.print(missCount,judgeCounterXPos[6], (love.graphics.getHeight()/2)+150)

        love.graphics.pop()
        love.graphics.push()


        love.graphics.translate(love.graphics.getWidth()/2,love.graphics.getHeight()/2)
        love.graphics.setLineWidth(1)
        love.graphics.scale(1, 0.5)

        graphWidth = 500
        love.graphics.setColor(1,1,1)
        love.graphics.line(0, marvTiming, graphWidth, marvTiming)

        love.graphics.setColor(1,1,78/255)
        love.graphics.line(0, perfTiming, graphWidth, perfTiming)
        
        love.graphics.setColor(92/255, 1, 82/255)
        love.graphics.line(0, greatTiming, graphWidth,greatTiming)

        love.graphics.setColor(0,61/255,1)
        love.graphics.line(0, goodTiming, graphWidth, goodTiming)

        love.graphics.setColor(129/255,0,1)
        love.graphics.line(0, okayTiming, graphWidth, okayTiming)

        love.graphics.setColor(1,65/255,65/255)
        love.graphics.line(0, missTiming, graphWidth, missTiming)

        love.graphics.setColor(1,1,1)
        love.graphics.line(0, 0, graphWidth, 0)

        love.graphics.setColor(1,1,1)
        love.graphics.line(0, -marvTiming, graphWidth, -marvTiming)

        love.graphics.setColor(1,1,78/255)
        love.graphics.line(0, -perfTiming, graphWidth, -perfTiming)

        love.graphics.setColor(92/255, 1, 82/255)
        love.graphics.line(0, -greatTiming, graphWidth, -greatTiming)

        love.graphics.setColor(0,61/255,1)
        love.graphics.line(0, -goodTiming, graphWidth, -goodTiming)

        love.graphics.setColor(129/255,0,1)
        love.graphics.line(0, -okayTiming, graphWidth, -okayTiming)

        love.graphics.setColor(1,65/255,65/255)
        love.graphics.line(0, -missTiming, graphWidth, -missTiming)


        for i = 1,#hitTimes do
            local noteHitTime = math.abs(hitTimes[i][1])
            if noteHitTime < marvTiming then
                love.graphics.setColor(1,1,1)
            elseif noteHitTime < perfTiming then
                love.graphics.setColor(1,1,78/255)
            elseif noteHitTime < greatTiming then
                love.graphics.setColor(92/255, 1, 82/255)
            elseif noteHitTime < goodTiming then
                love.graphics.setColor(0,61/255,1)
            elseif noteHitTime < okayTiming then
                love.graphics.setColor(129/255,0,1)
            elseif noteHitTime < missTiming then
                love.graphics.setColor(1,65/255,65/255)
            end
            love.graphics.rectangle("fill", (hitTimes[i][2])/(songLength*1000)*graphWidth, hitTimes[i][1], 3, 6, 1.5, 3)
        end




        --love.graphics.rectangle("line", )

        love.graphics.setLineWidth(5)

        love.graphics.pop()

    else
        love.graphics.draw(background, 0, 0, nil, love.graphics.getWidth()/background:getWidth(),love.graphics.getHeight()/background:getHeight())

        love.graphics.setColor(0,0,0,backgroundDim[1])
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1,1,1,1)
    
        love.graphics.rectangle("fill", 0, love.graphics.getHeight()-20, timeRemainingBar[1], 20)
        love.graphics.pop()

        love.graphics.push()
        if downScroll then
            love.graphics.translate(0, love.graphics.getHeight()-NoteUp:getHeight()) 
        end   -- downscroll
            if Input:down("GameLeft") then
                love.graphics.draw(ReceptorLeftPressed, love.graphics.getWidth()/2-(LaneWidth*2), 0)
            else
                love.graphics.draw(ReceptorLeft, love.graphics.getWidth()/2-(LaneWidth*2), 0)
            end
        
            if Input:down("GameDown") then
                love.graphics.draw(ReceptorDownPressed, love.graphics.getWidth()/2-(LaneWidth), 0)
            else
                love.graphics.draw(ReceptorDown, love.graphics.getWidth()/2-(LaneWidth), 0)
            end
        
            if Input:down("GameUp") then
                love.graphics.draw(ReceptorUpPressed, love.graphics.getWidth()/2, 0)
            else    
                love.graphics.draw(ReceptorUp, love.graphics.getWidth()/2, 0)
            end
        
            if Input:down("GameRight") then
                love.graphics.draw(ReceptorRightPressed, love.graphics.getWidth()/2+(LaneWidth), 0)
            else
                love.graphics.draw(ReceptorRight, love.graphics.getWidth()/2+(LaneWidth), 0)
            end
        
            love.graphics.push()
            if gameOverNotePush[1] ~= 0 then
                love.graphics.translate(0, gameOverNotePush[1])
            end
        
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

        love.graphics.pop()
        love.graphics.push()
    
            love.graphics.setFont(BigFont)
            love.graphics.setColor(0,0.5,1)
            love.graphics.print(math.floor(printableScore[1]),3,3)
            love.graphics.setColor(1,1,1)
    
            love.graphics.print(math.floor(printableScore[1]))
    
            love.graphics.setFont(DefaultFont)
    
    
    
    
        love.graphics.setColor(1,1,1,judgeColors[1])
        love.graphics.draw(Marvelous, (love.graphics.getWidth()/2)-(Marvelous:getWidth()/2), 200 + judgePos[1])
        love.graphics.setColor(1,1,1,judgeColors[2])
        love.graphics.draw(Perfect, (love.graphics.getWidth()/2)-(Marvelous:getWidth()/2), 200 + judgePos[1])         
        love.graphics.setColor(1,1,1,judgeColors[3])
        love.graphics.draw(Great, (love.graphics.getWidth()/2)-(Marvelous:getWidth()/2), 200 + judgePos[1])
        love.graphics.setColor(1,1,1,judgeColors[4])
        love.graphics.draw(Good, (love.graphics.getWidth()/2)-(Marvelous:getWidth()/2), 200 + judgePos[1])
        love.graphics.setColor(1,1,1,judgeColors[5])
        love.graphics.draw(Okay, (love.graphics.getWidth()/2)-(Marvelous:getWidth()/2), 200 + judgePos[1])
        love.graphics.setColor(1,1,1,judgeColors[6])
        love.graphics.draw(Miss, (love.graphics.getWidth()/2)-(Marvelous:getWidth()/2), 200 + judgePos[1])
        love.graphics.setColor(1,1,1,1)
        love.graphics.setFont(MediumFont)
    
        if marvCount ~= 0 then
            love.graphics.print(marvCount,judgeCounterXPos[1], (love.graphics.getHeight()/2)-100)
        else
            love.graphics.print("Marvelous",0, (love.graphics.getHeight()/2)-100)
        end
        if perfCount ~= 0 then
            love.graphics.print(perfCount,judgeCounterXPos[2], (love.graphics.getHeight()/2)-50)
        else
            love.graphics.print("Perfect",0, (love.graphics.getHeight()/2)-50)
        end
        love.graphics.setColor(92/255,1, 82/255)
    
        if greatCount ~= 0 then
            love.graphics.print(greatCount,judgeCounterXPos[3], (love.graphics.getHeight()/2)+0)
        else
            love.graphics.print("Great",0, (love.graphics.getHeight()/2)+0)
        end
        if goodCount ~= 0 then
            love.graphics.print(goodCount,judgeCounterXPos[4], (love.graphics.getHeight()/2)+50)
        else
            love.graphics.print("Good",0, (love.graphics.getHeight()/2)+50)
        end
        love.graphics.setColor(1,65/255,65/255)
        if okayCount ~= 0 then
            love.graphics.print(okayCount,judgeCounterXPos[5], (love.graphics.getHeight()/2)+100)
        else
            love.graphics.print("Okay",0, (love.graphics.getHeight()/2)+100)
        end
        if missCount ~= 0 then
           love.graphics.print(missCount,judgeCounterXPos[6], (love.graphics.getHeight()/2)+150)
        else
            love.graphics.print("Miss",0, (love.graphics.getHeight()/2)+150)
        end
    
    
    
    
    
    
        love.graphics.setColor(1,1,1,1)
        love.graphics.setFont(BigFont)
        if combo > 0 then
            love.graphics.printf(combo, 0, 240+judgePos[1], love.graphics.getWidth(), "center")
        end
        love.graphics.setColor(0,0.5,1)
        love.graphics.printf(string.format("%.2f", tostring(math.min((printableAccuracy[1]))), 100).."%", 3, 3, love.graphics.getWidth(), "right")
        love.graphics.setColor(1,1,1)
    
        accuracyColor = printableAccuracy[1]/100
    
        love.graphics.setColor(1+accuracyColor,accuracyColor,accuracyColor)
    
    
        love.graphics.printf(string.format("%.2f", tostring(math.min((printableAccuracy[1]))), 100).."%", 0, 0, love.graphics.getWidth(), "right")
    
        love.graphics.setFont(DefaultFont)
        love.graphics.setColor(0,0,0)
    
        love.graphics.rectangle("fill", 896, 636, 13, -508)
    
        love.graphics.setColor(0,0.5,1)
    
    
        love.graphics.rectangle("fill", 900, 632, 5, -printableHealth[1]*500)
        --love.graphics.draw(HealthImage, 880, 650-HealthImage:getHeight())
    
    
    
        --love.graphics.line(0, love.graphics.getHeight()/2, love.graphics.getWidth(), love.graphics.getHeight()/2)
    end


end

return PlayState