-- Extension of debug module in lua

function debug.printInfo()
    love.graphics.print(
        "FPS: " .. tostring(love.timer.getFPS()) .. 
        "\nLua Memory (KB): " .. tostring(math.floor(collectgarbage("count"))) ..
        "\nGraphics Memory (MB): " .. tostring(math.floor(love.graphics.getStats().texturememory/1024/1024))
    )
end