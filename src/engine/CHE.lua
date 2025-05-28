local CHE = {}
Mouse = {}


function mouseOver(object)
    return Mouse.x >= object.x and Mouse.x <= object.x + object.width and Mouse.y >= object.y and Mouse.y <= object.y + object.height
end

function toGameScreen(x, y)
    local ratio = 1
    ratio = math.min(Inits.WindowWidth/Inits.GameWidth, Inits.WindowHeight/Inits.GameHeight)
    local x, y = x - Inits.WindowWidth/2, y - Inits.WindowHeight/2
    x, y = x / ratio, y / ratio
    x, y = x + Inits.GameWidth/2, y + Inits.GameHeight/2
    return x, y
end

function CHE:init()
    baseScreenRatio = {}
    baseScreenRatio.x, baseScreenRatio.y = love.graphics.getWidth(), love.graphics.getHeight()
    CHECanvas = love.graphics.newCanvas(baseScreenRatio.x, baseScreenRatio.y)
    love.graphics.setDefaultFilter("linear")

    require("modules.controls")

    Input = setupControls()
    Class = require("engine.class.class")
    State = require("engine.state.State")

    States = require("modules.states")
    require("modules.objects")

end

function CHE:update(dt)
    State.update(dt)
    Input:update()
    Mouse.x, Mouse.y = love.mouse.getPosition()
end

function CHE:draw()
    love.graphics.push()
    love.graphics.setCanvas(CHECanvas)
    love.graphics.clear(0,0,0,1)
    State.draw()
    love.graphics.setCanvas()
    love.graphics.pop()

    local ratio = 1
    ratio = math.min(love.graphics.getWidth()/baseScreenRatio.x, love.graphics.getHeight()/baseScreenRatio.y)
    love.graphics.draw(CHECanvas, love.graphics.getWidth()/2, love.graphics.getHeight()/2, 0, ratio, ratio, baseScreenRatio.x/2, baseScreenRatio.y/2)
end

return CHE