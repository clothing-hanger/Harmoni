local songSelect = State()

function songSelect:enter(test)
end

function songSelect:update(dt)
    if Input:pressed("menuConfirm") then
        State.switch(States.game.gameModeManager, "mania", "test.harmc")
    end
end

function songSelect:draw()
    love.graphics.print("select your song,, oh wait you CANT theres not menu yet lol (y'all are NOT getting this game)")

end

return songSelect