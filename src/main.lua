
function love.load()
    CHE = require("engine.CHE")
    CHE:init()

    State.switch(States.testState)
end

function love.update(dt)
    CHE:update(dt)
end

function love.draw()  --if you wanna edit this, go to engine/CHE.lua and edit the CHE:draw() function to keep the screen aspect ratio shit
    CHE:draw()
end