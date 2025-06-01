require("love.error")
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

function love.wheelmoved(x,y)
    State.scroll(y)
end

function love.draw()  --if you wanna edit this, go to engine/CHE.lua and edit the CHE:draw() function to keep the screen aspect ratio shit
    CHE:draw()
end
