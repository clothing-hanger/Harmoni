require("love.error")
require("love.run")
function love.load()
    GPUInfo = {test = "HI"}
    love.graphics.setDefaultFilter("linear","linear")
    require("modules.extraFunctions")
    love.filesystem.createDirectory("Music")
    require("TEMP")
    CHE = require("engine.CHE")
    CHE:init()

    require("modules.gamemodes")

    ChartParse = require("modules.chartParse")
    MusicTimeManager = require("modules.musicTimeManager")
    SongListManager = require("modules.songListManager")

    State.switch(States.menu.titleScreen)
end

function love.update(dt)
    CHE:update(dt)
end

function love.mousepressed(x, y, b)
    CHE:mousepressed(x, y, b)
end

function love.mousereleased(x, y, b)
    CHE:mousereleased(x, y, b)
end

function love.wheelmoved(x,y)
    State.scroll(y)
end

function love.draw(dt)  --if you wanna edit this, go to engine/CHE.lua and edit the CHE:draw() function to keep the screen aspect ratio shit
    local baseFont = love.graphics.getFont()
    CHE:draw(dt)

    love.graphics.setFont(baseFont)
    local UPS, DPS = love.timer.getFPS()
    love.graphics.printf(string.format("UPS: %d, DPS: %d", UPS, DPS), 0, 0, love.graphics.getWidth(), "right")
end

function love.quit()
    CHE:exit()
end