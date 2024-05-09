local ResultsState = State()

function ResultsState:enter()
    ResultsScreenImage = love.graphics.newImage("Images/RESULTS/ResultsScreen.png")
end

function ResultsState:update(dt)
end

function ResultsState:draw()
    --[[
    love.graphics.setColor(1,1,1,0.75)
        love.graphics.draw(background, 0, 0, nil, Inits.GameWidth/background:getWidth(),Inits.GameHeight/background:getHeight())

    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(ResultsScreenImage)
    -]]
    love.graphics.push()




        
    if gameOver then
        grade = "F"
    end

    blurEffect(function()
    love.graphics.draw(background, 0, 0, nil, Inits.GameWidth/background:getWidth(),Inits.GameHeight/background:getHeight())
    end)
    
    love.graphics.setColor(0,0,0,backgroundDim[1])
    love.graphics.rectangle("fill", 0, 0, Inits.GameWidth, Inits.GameHeight)
    if not resultsScreenTranslate then
        resultsScreenTranslate = {-500}
        Timer.tween(0.3, resultsScreenTranslate, {0}, "out-expo")
    end
    love.graphics.translate(0,resultsScreenTranslate[1])
    love.graphics.setColor(1,1,1,1)

    love.graphics.setFont(fontPoland50)

    love.graphics.printf(metaData.name, 10, 10, 5000)
    love.graphics.printf(string.format("%.2f", tostring(math.min((printableAccuracy[1]))), 100).."%", 50, 500, 200, "right")
    love.graphics.setFont(MediumFont)

    love.graphics.printf(metaData.diffName, 10, 80, 5000)





   love.graphics.setFont(fontPoland150)

    love.graphics.print(grade, 45, Inits.GameHeight/2-235)




   -- love.graphics.pop()
   -- love.graphics.push()


    love.graphics.translate(Inits.GameWidth/2-250,Inits.GameHeight/2)
    love.graphics.setLineWidth(1)
    love.graphics.scale(1, 0.5)
    graphWidth = 500
    love.graphics.setFont(MenuFontExtraSmall)

    love.graphics.setColor(1,1,1)
    love.graphics.line(0, marvTiming, graphWidth, marvTiming)
    love.graphics.printf(marvTiming, -22, marvTiming, 100, "left", 0, 0.5, 1)
    love.graphics.setColor(1,1,78/255)
    love.graphics.line(0, perfTiming, graphWidth, perfTiming)
    love.graphics.printf(perfTiming, -22, perfTiming, 100, "left", 0, 0.5, 1)

    love.graphics.setColor(92/255, 1, 82/255)
    love.graphics.line(0, greatTiming, graphWidth,greatTiming)
    love.graphics.printf(greatTiming, -22, greatTiming, 100, "left", 0, 0.5, 1)

    love.graphics.setColor(0,61/255,1)
    love.graphics.line(0, goodTiming, graphWidth, goodTiming)
    love.graphics.printf(goodTiming, -22, goodTiming, 100, "left", 0, 0.5, 1)

    love.graphics.setColor(129/255,0,1)
    love.graphics.line(0, okayTiming, graphWidth, okayTiming)
    love.graphics.printf(okayTiming, -22, okayTiming, 100, "left", 0, 0.5, 1)

    love.graphics.setColor(1,65/255,65/255)
    love.graphics.line(0, missTiming, graphWidth, missTiming)
    love.graphics.printf(missTiming, -22, missTiming, 100, "left", 0, 0.5, 1)

    love.graphics.setColor(1,1,1)
    love.graphics.line(0, 0, graphWidth, 0)
    love.graphics.printf(-0, -22, 0, 100, "left", 0, 0.5, 1)

    love.graphics.setColor(1,1,1)
    love.graphics.line(0, -marvTiming, graphWidth, -marvTiming)
    love.graphics.printf(-marvTiming, -22, -marvTiming, 100, "left", 0, 0.5, 1)

    love.graphics.setColor(1,1,78/255)
    love.graphics.line(0, -perfTiming, graphWidth, -perfTiming)
    love.graphics.printf(-perfTiming, -22, -perfTiming, 100, "left", 0, 0.5, 1)

    love.graphics.setColor(92/255, 1, 82/255)
    love.graphics.line(0, -greatTiming, graphWidth, -greatTiming)
    love.graphics.printf(-greatTiming, -22, -greatTiming, 100, "left", 0, 0.5, 1)

    love.graphics.setColor(0,61/255,1)
    love.graphics.line(0, -goodTiming, graphWidth, -goodTiming)
    love.graphics.printf(-goodTiming, -22, -goodTiming, 100, "left", 0, 0.5, 1)

    love.graphics.setColor(129/255,0,1)
    love.graphics.line(0, -okayTiming, graphWidth, -okayTiming)
    love.graphics.printf(-okayTiming, -22, -okayTiming, 100, "left", 0, 0.5, 1)

    love.graphics.setColor(1,65/255,65/255)
    love.graphics.line(0, -missTiming, graphWidth, -missTiming)
    love.graphics.printf(-missTiming, -22, -missTiming, 100, "left", 0, 0.5, 1)







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
            love.graphics.rectangle("fill", (hitTimes[i][2])/(songLength*1000)*graphWidth, hitTimes[i][1], 3, 6, 1.5, 3)
        end
    end



    love.graphics.setLineWidth(1000)
    love.graphics.push()
    love.graphics.scale(1,1.8)
    love.graphics.translate(860, -700)

    love.graphics.rotate(math.rad(90))

    love.graphics.setColor(1,1,1)

    love.graphics.line(600, 286, 600, (-((marvCount/totalNoteCount)*300))+286)
    love.graphics.line(640, 286, 640, -((perfCount/totalNoteCount)*300)+286)
    love.graphics.setColor(92/255,1, 82/255)

    love.graphics.line(680, 286, 680, -((greatCount/totalNoteCount)*300)+286)
    love.graphics.line(720, 286, 720, -((goodCount/totalNoteCount)*300)+286)
    love.graphics.setColor(1,65/255,65/255)

    love.graphics.line(760, 286, 760, -((okayCount/totalNoteCount)*300)+286)
    love.graphics.line(800, 286, 800, -((missCount/totalNoteCount)*300)+286)
    love.graphics.setColor(1,1,1)

    love.graphics.pop()
    love.graphics.setLineWidth(1)


    love.graphics.setFont(MediumFont)
    love.graphics.scale(1,2)
    love.graphics.printf(marvCount,465,-103, 100, "right")
    love.graphics.printf(perfCount,465, -67, 100, "right")
    love.graphics.setColor(92/255,1, 82/255)
    love.graphics.printf(greatCount,465, -32, 100, "right")
    love.graphics.printf(goodCount,465,  3, 100, "right")
    love.graphics.setColor(1,65/255,65/255)
    love.graphics.printf(okayCount,465, 39, 100 ,"right")
    love.graphics.printf(missCount,465, 75, 100, "right")

    love.graphics.setLineWidth(1)

    love.graphics.pop()
end

return ResultsState