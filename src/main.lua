require("love.error")
require("love.run")


dontShowBG = false  -- i can NOT work on this game anywhere people can see my laptop cuz these fucking weird ass backgrounds FUCK YOU QUAVER AND OSU MAPPERS WHAT IS WRONG WITH YOU FUCKING PEOPLE

local function table_find(t, value)
    for i, v in ipairs(t) do
        if v == value then
            return i
        end
    end
    return nil
end

function love.load(args)
    Settings = require("Modules.Settings")
    Settings.default = Settings:defaultSettings()
    Settings:loadSettings()

    GPUInfo = {test = "HI"}
    love.graphics.setDefaultFilter("linear","linear")
    require("modules.extraFunctions")
    love.filesystem.createDirectory("Music")
    love.filesystem.createDirectory("Settings")

    SkinHandler = require("modules.skinHandler")
    Settings:addSkinsToSettings(SkinHandler:getAllSkins())

    CHE = require("engine.CHE")
    CHE:init()

    require("modules.gamemodes")

    require("bob.init")
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

function love.mousemoved(x, y, dx, dy)
    cursor.dx, cursor.dy = toCanvasCoords(dx, dy)
    CHE:mousemoved(x, y, dx, dy)
end

function love.mousereleased(x, y, b)
    CHE:mousereleased(x, y, b)
end

function love.keypressed(key, scancode, isrepeat)
    CHE:keypressed(key, scancode, isrepeat)
end

function love.textinput(text)
    CHE:textinput(text)
end

function love.wheelmoved(x,y)
    State.scroll(y)
end

function love.draw(dt)  --if you wanna edit this, go to engine/CHE.lua and edit the CHE:draw() function to keep the screen aspect ratio shit
    local baseFont = love.graphics.getFont()
    CHE:draw(dt)

    love.graphics.setFont(baseFont)
    local DPS, UPS = love.timer.getFPS()
    love.graphics.setColor(0, 0, 0)

    local graphicStats = love.graphics.getStats()
    local drawCalls = graphicStats.drawcalls or 0
    local drawCallsBatched = graphicStats.drawcallsbatched or 0
    local textureMemory = graphicStats.texturememory or 0
    for x = -1, 1 do
        for y = -1, 1 do
            love.graphics.printf(string.format("UPS: %d, DPS: %d\nDrawCalls: %d (%d batched)\nTextureMemory: %dMB", UPS, DPS, drawCalls, drawCallsBatched, textureMemory/1024/1024), x, y, love.graphics.getWidth(), "right")
        end
    end
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(string.format("UPS: %d, DPS: %d\nDrawCalls: %d (%d batched)\nTextureMemory: %dMB", UPS, DPS, drawCalls, drawCallsBatched, textureMemory/1024/1024), 0, 0, love.graphics.getWidth(), "right")
end

function love.quit()
    CHE:exit()
end
