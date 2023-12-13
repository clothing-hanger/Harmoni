local ResultsState = State()

function ResultsState:enter()
    inMenu = true
    ResultsScreenImage = love.graphics.newImage("Images/RESULTS/ResultsScreen.png")
end

function ResultsState:update(dt)
    ResultsState:update(dt)
end

function ResultsState:draw()
    love.graphics.setColor(1,1,1,0.75)
    love.graphics.draw(background)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(ResultsScreenImage)
end

return ResultsState