
function love.load()
    love.filesystem.createDirectory("Music")
    require("TEMP")
    CHE = require("engine.CHE")
    CHE:init()

    require("modules.gamemodes")
    require("modules.chartParse.harmc")
    require("modules.musicTime")

    State.switch(States.menu.titleScreen)
end

function love.update(dt)
    CHE:update(dt) 
end

function love.draw()  --if you wanna edit this, go to engine/CHE.lua and edit the CHE:draw() function to keep the screen aspect ratio shit
    CHE:draw()
end