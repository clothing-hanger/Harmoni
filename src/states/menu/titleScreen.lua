local titleScreen = State("titleScreen")

function titleScreen:enter()

    self.squiglyLineTest = UIsquiglyLine(
        0, 
        baseScreenRatio.y / 2, 
        baseScreenRatio.x, 
        baseScreenRatio.y / 2, 
        30,
        10,
        1000,
        3,
        10
    )
end

function titleScreen:update(dt)
    self.squiglyLineTest:update(dt)
    if Input:pressed("menuConfirm") then
        State.switch(States.menu.songSelect)
    end
    --print("test")
end

function titleScreen:draw()
    self.squiglyLineTest:draw()
    love.graphics.print("harmoni lol")

end

return titleScreen