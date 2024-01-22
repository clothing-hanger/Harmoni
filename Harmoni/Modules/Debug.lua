-- Extension of debug module in lua

function debug.printInfo()
    love.graphics.setFont(DefaultFont)
  --  if debugOverlay == "FPS" then
        love.graphics.print(
            "FPS: " .. tostring(love.timer.getFPS())
        )

        --[[
    elseif debugOverlay == "RAM" then
        love.graphics.print(
            "Lua Memory (KB): " .. tostring(math.floor(collectgarbage("count"))) ..
            "\nGraphics Memory (MB): " .. tostring(math.floor(love.graphics.getStats().texturememory/1024/1024))
        )
    elseif debugOverlay == "BOTH" then
        love.graphics.print(
            "FPS: " .. tostring(love.timer.getFPS()) .. 
            "\nLua Memory (KB): " .. tostring(math.floor(collectgarbage("count"))) ..
            "\nGraphics Memory (MB): " .. tostring(math.floor(love.graphics.getStats().texturememory/1024/1024))
        )
    end
    --]]
end