function love.mousepressed()
    print("test")
end

function updateCursor(dt)
    cursorX, cursorY = toGameScreen(love.mouse.getPosition())
end