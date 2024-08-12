-- Extension of debug module in lua
local stateString = ""
function debug.printInfo()
    if stateDebugString then stateString = stateDebugString end
    
    love.graphics.translate(0, Inits.GameHeight-200)
    love.graphics.setFont(defaultFont)
    love.graphics.setColor(0,0,0,0.5)
    love.graphics.rectangle("fill", 0, 0, 200, 200)
    love.graphics.setColor(1,1,1)
    love.graphics.print(
        "FPS: " .. tostring(love.timer.getFPS()) .. 
        "\nLua Memory (KB): " .. tostring(math.floor(collectgarbage("count"))) ..
        "\nGraphics Memory (MB): " .. tostring(math.floor(love.graphics.getStats().texturememory/1024/1024)) ..
        stateString
    )
    love.graphics.translate(0, -Inits.GameHeight-200)

end