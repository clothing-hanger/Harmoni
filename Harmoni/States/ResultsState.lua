local ResultsState = State()

function ResultsState:enter()
    ResultsScreenImage = love.graphics.newImage("Images/RESULTS/ResultsScreen.png")
end

function ResultsState:update(dt)
    ResultsState:update(dt)
end

function ResultsState:draw()
    love.graphics.setColor(1,1,1,0.75)
        love.graphics.draw(background, 0, 0, nil, Inits.WindowWidth/background:getWidth(),Inits.WindowHeight/background:getHeight())

    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(ResultsScreenImage)
end

return ResultsState