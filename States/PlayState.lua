local PlayState = State()
function PlayState:enter()

    --load assets
    chart = love.filesystem.load("Music/" .. songList[selectedSong] .. "/chart.lua")()
    bestScorePerNote = 1000000/#chart
    lane1 = {}
    lane2 = {}
    lane3 = {}
    lane4 = {}
    for i = 1,#chart do
        if chart[i][2] == 1 then
            table.insert(lane1, chart[i][1])
        elseif chart[i][2] == 2 then
            table.insert(lane2, chart[i][1])
        elseif chart[i][2] == 3 then
            table.insert(lane3, chart[i][1])
        elseif chart[i][2] == 4 then
            table.insert(lane4, chart[i][1])
        end
    end
    song = love.audio.newSource("Music/" .. songList[selectedSong] .. "/audio.mp3", "stream")
    background = love.graphics.newImage("Music/" .. songList[selectedSong] .. "/background.jpg")

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


    marvTiming = 43+10
    perfTiming = 68+15
    greatTiming = 93+15
    goodTiming = 117 +15
    okayTiming = 142+15
    missTiming = 166+15

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
    LaneWidth = 120
    health = 1
    paused = false
    judgeColors = {0,0,0,0,0,0}
    judgePos = {0}
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


    --nothing after this is for loading shit
    dimBackground()


end
function PlayState:update(dt)
    MusicTime = MusicTime + (love.timer.getTime() * 1000) - (previousFrameTime or (love.timer.getTime()*1000))
    previousFrameTime = love.timer.getTime() * 1000
    if paused then
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
    end

    if Input:pressed("GameConfirm") then
        pause()
    end



    if (#lane1+#lane2+#lane3+#lane4 == 0) or (printableHealth[1] <= 0) then
        --State.switch(States.ResultsState)
    end    


end

function pause()
    paused = not paused
    PausedMusicTime = MusicTime
    if paused then
        song:pause()
    else
        song:play()
    end
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

    if noteTime < marvTiming then  -- marvelous
        score = score + bestScorePerNote
        judgeColors = {1,0,0,0,0,0}
        marvCount = marvCount + 1
        judgeCountTween(1)
        incrementCombo()
        health = math.min(health + 0.025, 1)
    elseif noteTime < perfTiming then  -- perfect
        score = score + (bestScorePerNote/2)
        judgeColors = {0,1,0,0,0,0}
        judgeCountTween(2)
        incrementCombo()
        perfCount = perfCount + 1
        health = math.min(health + 0.02, 1)
    elseif noteTime < greatTiming then  -- great
        score = score + (bestScorePerNote/3)
        greatCount = greatCount + 1
        judgeColors = {0,0,1,0,0,0}
        judgeCountTween(3)
        incrementCombo()
        health = math.min(health + 0.01, 1)
    elseif noteTime < goodTiming then  -- good
        score = score + (bestScorePerNote/4)
        judgeColors = {0,0,0,1,0,0}
        judgeCountTween(4)
        incrementCombo()
        goodCount = goodCount + 1
    elseif noteTime < okayTiming then  -- okay
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
        local noteTime = math.abs(lane1[i] - MusicTime)
        if noteTime < missTiming and Input:pressed("GameLeft")then
            judge(noteTime)
            table.remove(lane1, i)
            break
        end

    end
    for i = 1,#lane2 do
        local noteTime = math.abs(lane2[i] - MusicTime)
        if noteTime < missTiming and Input:pressed("GameDown")then
            judge(noteTime)
            table.remove(lane2, i)
            break
        end
    end
    for i = 1,#lane3 do
        local noteTime = math.abs(lane3[i] - MusicTime)
        if noteTime < missTiming and Input:pressed("GameUp")then
            judge(noteTime)
            table.remove(lane3, i)
            break
        end
    end
    for i = 1,#lane4 do
        local noteTime = math.abs(lane4[i] - MusicTime)
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
        if NoteTime < marvTiming then
            judge(NoteTime)
            table.remove(lane1, i)
            break
        end
    end
    for i = 1, #lane2 do
        local NoteTime = lane2[i] - MusicTime
        if NoteTime < marvTiming then
            judge(NoteTime)
            table.remove(lane2, i)
            break
        end
    end
    for i = 1, #lane3 do
        local NoteTime = lane3[i] - MusicTime
        if NoteTime < marvTiming then
            judge(NoteTime)
            table.remove(lane3, i)
            break
        end
    end
    for i = 1, #lane4 do
        local NoteTime = lane4[i] - MusicTime
        if NoteTime < marvTiming then
            judge(NoteTime)
            table.remove(lane4, i)
            break
        end
    end
end
function PlayState:draw()
    love.graphics.setCanvas(GameScreen)
        love.graphics.draw(background, 0, 0, nil, love.graphics.getWidth()/background:getWidth(),love.graphics.getHeight()/background:getHeight())

    love.graphics.setColor(0,0,0,backgroundDim[1])
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1,1,1,1)

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

        for i = 1,#lane1 do
            if -(MusicTime - lane1[i])*speed < love.graphics.getHeight() then
                love.graphics.draw(NoteLeft, love.graphics.getWidth()/2-(LaneWidth*2), -(MusicTime - lane1[i])*speed)
            end
        end

        for i = 1,#lane2 do
            if -(MusicTime - lane2[i])*speed < love.graphics.getHeight() then
                love.graphics.draw(NoteDown, love.graphics.getWidth()/2-LaneWidth, -(MusicTime - lane2[i])*speed)
            end
        end


        for i = 1,#lane3 do
            if -(MusicTime - lane3[i])*speed < love.graphics.getHeight() then
                love.graphics.draw(NoteUp, love.graphics.getWidth()/2, -(MusicTime - lane3[i])*speed)
            end
        end
        for i = 1,#lane4 do
            if -(MusicTime - lane4[i])*speed < love.graphics.getHeight() then
                love.graphics.draw(NoteRight, love.graphics.getWidth()/2+LaneWidth, -(MusicTime - lane4[i])*speed)
            end
        end
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


    love.graphics.setColor(0,1,1)


    love.graphics.rectangle("fill", 900, 632, 20, -printableHealth[1]*500)
    love.graphics.draw(HealthImage, 880, 650-HealthImage:getHeight())



    --love.graphics.line(0, love.graphics.getHeight()/2, love.graphics.getWidth(), love.graphics.getHeight()/2)


end

return PlayState