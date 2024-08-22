function love.mousepressed()
end

function updateCursor(dt)
    cursorX, cursorY = toGameScreen(love.mouse.getPosition())
end


function cursorTextDraw()
    if not cursorText then return end
    --if mouseTimer > 0 then return end  i might add this back to tbh i like the desc just appearing instantly

    love.graphics.setFont(Skin.Fonts["Menu Small"])
    love.graphics.setColor(1,1,1)

    love.graphics.print(cursorText, cursorX+15, cursorY)
end