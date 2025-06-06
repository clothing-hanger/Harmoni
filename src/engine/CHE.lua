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

    cursor = cursor()






    local screenMiddle = baseScreenRatio.x / 2         --TEMP SHIT 
    musicPath = "Music/"
    maniaNoteSize = 100
    maninaLaneGap = 110
    maniaScrollSpeed = 2
    maniaLaneYOffset = 100

    defaultFont = love.graphics.newFont(12)

    songButtonFontLarge = love.graphics.newFont("fonts/astonpoliz.regular.ttf", 35)
    songButtonFontSmall = love.graphics.newFont("fonts/astonpoliz.regular.ttf", 25)

    songSelectSongInfoFontLarge = love.graphics.newFont("fonts/astonpoliz.regular.ttf", 35)
    songSelectSongInfoFontSmall = love.graphics.newFont("fonts/astonpoliz.regular.ttf", 25)

    maniaLanePositions = {
        screenMiddle - (1.5 * maniaNoteSize + 1.5 * maninaLaneGap),
        screenMiddle - (0.5 * maniaNoteSize + 0.5 * maninaLaneGap),
        screenMiddle + (0.5 * maniaNoteSize + 0.5 * maninaLaneGap),
        screenMiddle + (1.5 * maniaNoteSize + 1.5 * maninaLaneGap),
    }

end

function CHE:update(dt)
    State.update(dt)
    Input:update()
    Mouse.x, Mouse.y = love.mouse.getPosition()
    cursor:update(dt)
    love.mouse.setVisible(false)
end

function CHE:mousepressed(x, y, b)
    Mouse.x, Mouse.y = love.mouse.getPosition()
    cursor:mousepressed(Mouse.x, Mouse.y, b)
end

function CHE:mousemoved(x, y, dx, dy)
    Mouse.x, Mouse.y = love.mouse.getPosition()
    State.mousemoved(Mouse.x, Mouse.y, dx, dy)
end

function CHE:mousereleased(x, y, b)
    Mouse.x, Mouse.y = love.mouse.getPosition()
    cursor:mousereleased(Mouse.x, Mouse.y, b)
end

function CHE:draw(dt)
    love.graphics.push()
    love.graphics.setCanvas({CHECanvas, stencil = true})
    love.graphics.clear(0, 0, 0, 1)
    local startFont = love.graphics.getFont()
    local lastLineWidth = love.graphics.getLineWidth()
    local lastColor = {love.graphics.getColor()}
    State.draw(dt)
    love.graphics.setFont(startFont)
    love.graphics.setLineWidth(lastLineWidth)
    love.graphics.setColor(lastColor)
    love.graphics.setCanvas()
    love.graphics.pop()

    local ratio = math.min(love.graphics.getWidth() / baseScreenRatio.x, love.graphics.getHeight() / baseScreenRatio.y)
    love.graphics.draw(CHECanvas, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 0, ratio, ratio, baseScreenRatio.x / 2, baseScreenRatio.y / 2)

  --  love.graphics.circle("fill", Mouse.x, Mouse.y, 5
    cursor:draw()
end

function love.resize(w, h)
end

function CHE:exit()
end

return CHE
