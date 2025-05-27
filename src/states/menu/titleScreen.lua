local titleScreen = State("titleScreen")

function titleScreen:enter()

end

function titleScreen:update(dt)
    if Input:pressed("menuConfirm") then
        State.switch(States.menu.songSelect)
    end
    --print("test")
end

function titleScreen:draw()
    love.graphics.print("harmoni lol")

end

return titleScreen