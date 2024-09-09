local Results = State()

function Results:enter()
    doScreenWipe("rightOut")
    Results:initObjects()
    self.BGTranslate = 0
    Timer.tween(0.55, self, {BGTranslate = -200}, "out-expo")
end

function Results:initObjects()
    Objects.Game.NoteHitPlot:new()
    Objects.Game.JudgementBarGraph:new()
    
end

function Results:update(dt) 
    Objects.Game.NoteHitPlot:update()
    Objects.Game.JudgementBarGraph:update()

    if Input:pressed("menuConfirm") then
        State.switch(States.Menu.SongSelect)
    end
end

function Results:draw()
    love.graphics.push()
        love.graphics.translate(0, self.BGTranslate)
        if background then love.graphics.draw(background,0,0,0,Inits.GameWidth/background:getWidth(),Inits.GameHeight/background:getHeight()) end
        gradient(0, Inits.GameHeight-70, Inits.GameWidth, 70, {0,0,0,0}, {0,0,0,1}, "vertical")

    love.graphics.pop()
    gradient(0, 200, Inits.GameWidth, 70, {0,0,0,0}, {0,0,0,0.9}, "vertical")
    love.graphics.setColor(0,0,0,0.9)
    love.graphics.rectangle("fill", 0, 270, Inits.GameWidth, Inits.GameHeight)

    Objects.Game.NoteHitPlot:draw()
    Objects.Game.JudgementBarGraph:draw()

end

return Results