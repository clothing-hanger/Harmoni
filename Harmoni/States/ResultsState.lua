local ResultsState = State()

function ResultsState:enter()
    resultX = 0
    resultY = -930
    graphWidth = 930
    healthGraphHeight = 292


    healthGraphTable = {}
    accuracyGraphTable = {}


    
    for i = 1,#hitTimes do
        table.insert(healthGraphTable, (hitTimes[i][2])/(songLength*1000)*graphWidth) -- hitTimes[i][6]*healthGraphHeight)
        table.insert(healthGraphTable, -(hitTimes[i][6]*healthGraphHeight))
        table.insert(accuracyGraphTable, (hitTimes[i][2])/(songLength*1000)*graphWidth) -- hitTimes[i][6]*healthGraphHeight)
        table.insert(accuracyGraphTable, -(hitTimes[i][5]*healthGraphHeight))
    end

end

function ResultsState:update(dt)

    if Input:pressed("GameConfirm") then
        State.switch(States.SongSelectState)
    end



    if Input:down("GameLeft") then
        resultX = resultX - 1
    elseif Input:down("GameRight") then
        resultX = resultX + 1
    elseif Input:down("GameUp") then
        resultY = resultY - 1
    elseif Input:down("GameDown") then
        resultY = resultY + 1
    end
end

function ResultsState:draw()
    love.graphics.draw(background, Inits.GameWidth/2, Inits.GameHeight/2, nil, Inits.GameWidth/background:getWidth()+beatBump[1],Inits.GameHeight/background:getHeight()+beatBump[1], background:getWidth()/2, background:getHeight()/2)
    love.graphics.setColor(0,0,0,0.7)
    love.graphics.rectangle("fill",0,(936/3),Inits.GameWidth,936-(936/3))
    love.graphics.setColor(1,0,0)

    love.graphics.print(resultX .. ", " .. resultY)
    love.graphics.setColor(1,1,1)

    love.graphics.line(0,(936/3)*2,Inits.GameWidth,(936/3)*2)
    love.graphics.line(Inits.GameWidth/2,(936/3), Inits.GameWidth/2, 936)




    -- note hit plot graph

    love.graphics.setFont(MenuFontExtraSmall)
    love.graphics.scale(0.8,0.8)
    love.graphics.translate(1100, 580)
    love.graphics.push()
    love.graphics.setColor(1,1,1)
    love.graphics.line(0, marvTiming, graphWidth, marvTiming)
    love.graphics.printf(marvTiming, -22, marvTiming, 100, "left")
    love.graphics.setColor(1,1,78/255)
    love.graphics.line(0, perfTiming, graphWidth, perfTiming)
    love.graphics.printf(perfTiming, -22, perfTiming, 100, "left")

    love.graphics.setColor(92/255, 1, 82/255)
    love.graphics.line(0, greatTiming, graphWidth,greatTiming)
    love.graphics.printf(greatTiming, -22, greatTiming, 100, "left")

    love.graphics.setColor(0,61/255,1)
    love.graphics.line(0, goodTiming, graphWidth, goodTiming)
    love.graphics.printf(goodTiming, -22, goodTiming, 100, "left")

    love.graphics.setColor(129/255,0,1)
    love.graphics.line(0, okayTiming, graphWidth, okayTiming)
    love.graphics.printf(okayTiming, -22, okayTiming, 100, "left")

    love.graphics.setColor(1,65/255,65/255)
    love.graphics.line(0, missTiming, graphWidth, missTiming)
    love.graphics.printf(missTiming, -22, missTiming, 100, "left")

    love.graphics.setColor(1,1,1)
    love.graphics.line(0, 0, graphWidth, 0)
    love.graphics.printf(-0, -22, 0, 100, "left")

    love.graphics.setColor(1,1,1)
    love.graphics.line(0, -marvTiming, graphWidth, -marvTiming)
    love.graphics.printf(-marvTiming, -22, -marvTiming, 100, "left")

    love.graphics.setColor(1,1,78/255)
    love.graphics.line(0, -perfTiming, graphWidth, -perfTiming)
    love.graphics.printf(-perfTiming, -22, -perfTiming, 100, "left")

    love.graphics.setColor(92/255, 1, 82/255)
    love.graphics.line(0, -greatTiming, graphWidth, -greatTiming)
    love.graphics.printf(-greatTiming, -22, -greatTiming, 100, "left")

    love.graphics.setColor(0,61/255,1)
    love.graphics.line(0, -goodTiming, graphWidth, -goodTiming)
    love.graphics.printf(-goodTiming, -22, -goodTiming, 100, "left")

    love.graphics.setColor(129/255,0,1)
    love.graphics.line(0, -okayTiming, graphWidth, -okayTiming)
    love.graphics.printf(-okayTiming, -22, -okayTiming, 100, "left")

    love.graphics.setColor(1,65/255,65/255)
    love.graphics.line(0, -missTiming, graphWidth, -missTiming)
    love.graphics.printf(-missTiming, -22, -missTiming, 100, "left")    

    for i = 1,#hitTimes do
        miss = false

        if hitTimes[i][1] > missTiming then
            miss = true
        end
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
            miss = true
        end
        if miss then
            love.graphics.setColor(1,65/255,65/255)
            love.graphics.line(((hitTimes[i][2])/(songLength*1000)*graphWidth), -missTiming, ((hitTimes[i][2])/(songLength*1000)*graphWidth), missTiming)
        else
            love.graphics.circle("fill", (hitTimes[i][2])/(songLength*1000)*graphWidth, hitTimes[i][1], 1.5)
        end
    end
    love.graphics.pop()





    -- judgment bar graph
        
    love.graphics.setLineWidth(34)
    love.graphics.push()
    love.graphics.translate(-1045, -973)
    love.graphics.scale(1, 2)

   -- love.graphics.rotate(math.rad(90))

    love.graphics.scale(1,0.7)

    love.graphics.setColor(1,1,1)

    love.graphics.line(0, 600, (((marvCount/totalNoteCount)*graphWidth))+0, 600)
    love.graphics.line(0, 640, ((perfCount/totalNoteCount)*graphWidth)+0, 640)
    love.graphics.setColor(92/255,1, 82/255)


    love.graphics.line(0, 680,  ((greatCount/totalNoteCount)*graphWidth)+0, 680)
    love.graphics.line(0, 720, ((goodCount/totalNoteCount)*graphWidth)+0, 720)
    love.graphics.setColor(1,65/255,65/255)

    
    love.graphics.line(0, 760, ((okayCount/totalNoteCount)*graphWidth)+0, 760)
    love.graphics.line(0, 800, ((missCount/totalNoteCount)*graphWidth)+0, 800)

    love.graphics.setColor(1,1,1)

    love.graphics.pop()
    love.graphics.setLineWidth(2)






    -- health graph


    love.graphics.push()
    love.graphics.translate(-1054, 524)
    love.graphics.setColor(0.2,0.2,0.2)
    love.graphics.rectangle("fill", 0, healthGraphHeight, graphWidth, healthGraphHeight)
    for i = 1,#hitTimes do
        if i == #hitTimes then
            love.graphics.setColor(0,1,1)

            love.graphics.line(0, -(hitTimes[i][6]*healthGraphHeight), graphWidth, -(hitTimes[i][6]*healthGraphHeight))
            love.graphics.setColor(1,1,1)
            love.graphics.print(string.format("%.2f", tostring(math.min(printableAccuracy[1]))) .. "%", -40, -(hitTimes[i][6]*healthGraphHeight))

        end
    end
    love.graphics.line(0, 0, graphWidth, 0)
    love.graphics.line(0, -healthGraphHeight, graphWidth, -healthGraphHeight)
    love.graphics.setColor(1,1,0)
    love.graphics.setLineWidth(1)

    love.graphics.line(healthGraphTable)
    love.graphics.setLineWidth(2)


    love.graphics.print("0%", -40, 0)
    love.graphics.print("100%", -40, -healthGraphHeight)
    love.graphics.pop()


    

    -- accuracy graph


    love.graphics.push()
    love.graphics.translate(0, 524)
    love.graphics.setColor(0.2,0.2,0.2)
    love.graphics.rectangle("fill", 0, healthGraphHeight, graphWidth, healthGraphHeight)
    for i = 1,#hitTimes do
        if i == #hitTimes then
            love.graphics.setColor(0,1,1)

            love.graphics.line(0, -(hitTimes[i][5]*healthGraphHeight), graphWidth, -(hitTimes[i][5]*healthGraphHeight))
            love.graphics.setColor(1,1,1)
            love.graphics.print(string.format("%.2f", tostring(math.min(health*100))) .. "%", -40, -(hitTimes[i][5]*healthGraphHeight))

        end
    end

    love.graphics.setColor(1,1,0)

    love.graphics.line(0, 0, graphWidth, 0)
    love.graphics.line(0, -healthGraphHeight, graphWidth, -healthGraphHeight)

    love.graphics.setColor(1,1,1)
    love.graphics.setLineWidth(1)

    love.graphics.line(accuracyGraphTable)
    love.graphics.setLineWidth(2)



    love.graphics.print("0%", -40, 0)
    love.graphics.print("100%", -40, -healthGraphHeight)

    love.graphics.pop()

    love.graphics.setLineWidth(1)


end

return ResultsState