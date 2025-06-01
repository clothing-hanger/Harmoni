local CHE = {}
Mouse = {}

-- Convert mouse (screen) coordinates to canvas (1920x1080) coordinates
function toCanvasCoords(mx, my)
    local ratio = math.min(love.graphics.getWidth() / baseScreenRatio.x, love.graphics.getHeight() / baseScreenRatio.y)
    mx = (mx - love.graphics.getWidth() / 2) / ratio + baseScreenRatio.x / 2
    my = (my - love.graphics.getHeight() / 2) / ratio + baseScreenRatio.y / 2
    return mx, my
end

-- Check if the mouse is over a UI object (button)
function mouseOver(object)
    local mx, my = toCanvasCoords(Mouse.x, Mouse.y)
    return mx >= object.x and mx <= object.x + object.width and
           my >= object.y and my <= object.y + object.height
end

function CHE:init()
    baseScreenRatio = {}
    baseScreenRatio.x, baseScreenRatio.y = 2560, 1440

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
    love.graphics.clear(0, 0, 0, 1)
    State.draw()
    love.graphics.setCanvas()
    love.graphics.pop()

    local ratio = math.min(love.graphics.getWidth() / baseScreenRatio.x, love.graphics.getHeight() / baseScreenRatio.y)
    love.graphics.draw(CHECanvas, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 0, ratio, ratio, baseScreenRatio.x / 2, baseScreenRatio.y / 2)

    love.graphics.circle("fill", Mouse.x, Mouse.y, 5)
end

function love.resize(w, h)
end

function CHE:exit()
end

return CHE
