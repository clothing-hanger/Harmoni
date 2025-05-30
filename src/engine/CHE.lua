local CHE = {}
Mouse = {}

function mouseOver(object)
    return Mouse.x >= object.x and Mouse.x <= object.x + object.width and Mouse.y >= object.y and Mouse.y <= object.y + object.height
end

function toGameScreen(x, y)
    local ratio = 1
    ratio = math.min(baseScreenRatio.x/love.graphics.getWidth(), baseScreenRatio.y/love.graphics.getHeight())
    local x, y = x - love.graphics.getWidth()/2, y - love.graphics.getHeight()/2
    x, y = x / ratio, y / ratio
    x, y = x + love.graphics.getWidth()/2, y + love.graphics.getHeight()/2
    return x, y
end

function CHE:init()
    baseScreenRatio = {}
    baseScreenRatio.x, baseScreenRatio.y = 1920, 1080

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
    love.graphics.setCanvas({CHECanvas, stencil = true})
    love.graphics.clear(0,0,0,1)
    State.draw()
    love.graphics.setCanvas()
    love.graphics.pop()

    local ratio = 1
    ratio = math.min(love.graphics.getWidth()/baseScreenRatio.x, love.graphics.getHeight()/baseScreenRatio.y)
    love.graphics.draw(CHECanvas, love.graphics.getWidth()/2, love.graphics.getHeight()/2, 0, ratio, ratio, baseScreenRatio.x/2, baseScreenRatio.y/2)
end

function love.resize(w,h)
    
end

return CHE