local CHE = {}
Mouse = {}

function toCanvasCoords(mx, my)
    local ratio = math.min(love.graphics.getWidth() / baseScreenRatio.x, love.graphics.getHeight() / baseScreenRatio.y)
    mx = (mx - love.graphics.getWidth() / 2) / ratio + baseScreenRatio.x / 2
    my = (my - love.graphics.getHeight() / 2) / ratio + baseScreenRatio.y / 2
    return mx, my
end

function mouseOver(object)
    local mx, my = toCanvasCoords(Mouse.x, Mouse.y)
    return mx >= object.x and mx <= object.x + object.width and
           my >= object.y and my <= object.y + object.height
end

function CHE:init()
    baseScreenRatio = { x = 2560, y = 1440 }

    CHECanvas = love.graphics.newCanvas(baseScreenRatio.x, baseScreenRatio.y)
    love.graphics.setDefaultFilter("linear")

    require("modules.controls")
    Input = setupControls()

    Class = require("engine.class.class")
    State = require("engine.state.State")
    States = require("modules.states")
    Timer = require("engine.lib.Timer")
    Console = require("engine.modules.console")
    Ease = require("engine.lib.Ease")
    require("modules.objects")

    tryExcept(function()
        DLL_Video = require("video")
    end)

    cursor = cursor()

    local screenMiddle = baseScreenRatio.x / 2
    musicPath = "Music/"
    maniaNoteSize = 180
    maninaLaneGap = 10
    maniaScrollSpeed = 2.85
    maniaLaneYOffset = 110

    gameplayBackgroundDim = 0.65

    if Settings:getValue("Game", "Mania", "Scroll Direction") == "Down" then
        maniaLaneYOffset = baseScreenRatio.y - maniaLaneYOffset
    end

    defaultFont = love.graphics.newFont(12)

    local loadFont = love.graphics.newFont

    songButtonFontLarge = loadFont("fonts/astonpoliz.regular.ttf", 35)
    songButtonFontSmall = loadFont("fonts/astonpoliz.regular.ttf", 25)
    songSelectSongInfoFontLarge = loadFont("fonts/astonpoliz.regular.ttf", 35)
    songSelectSongInfoFontSmall = loadFont("fonts/astonpoliz.regular.ttf", 25)

    maniaLanePositions = {
        ["4K"] = {
            screenMiddle - (1.5 * maniaNoteSize + 1.5 * maninaLaneGap),
            screenMiddle - (0.5 * maniaNoteSize + 0.5 * maninaLaneGap),
            screenMiddle + (0.5 * maniaNoteSize + 0.5 * maninaLaneGap),
            screenMiddle + (1.5 * maniaNoteSize + 1.5 * maninaLaneGap),
        },
        ["7K"] = {
            screenMiddle - (3 * maniaNoteSize + 3 * maninaLaneGap),
            screenMiddle - (2 * maniaNoteSize + 2 * maninaLaneGap),
            screenMiddle - (1 * maniaNoteSize + 1 * maninaLaneGap),
            screenMiddle,
            screenMiddle + (1 * maniaNoteSize + 1 * maninaLaneGap),
            screenMiddle + (2 * maniaNoteSize + 2 * maninaLaneGap),
            screenMiddle + (3 * maniaNoteSize + 3 * maninaLaneGap),
        }
    }

    maniaInputs = {
        [4] = { "lane14K", "lane24K", "lane34K", "lane44K" },
        [7] = { "lane17K", "lane27K", "lane37K", "lane47K", "lane57K", "lane67K", "lane77K" }
    }

    SkinHandler:loadSkin("Default Arrow Batched")
end

function CHE:update(dt)
    Mouse.x, Mouse.y = love.mouse.getPosition()

    State.update(dt)
    Input:update()
    Timer.update(dt)
    cursor:update(dt)

    love.mouse.setVisible(false)
end

function CHE:keypressed(k, sc, isrepeat)
    Console.keypressed(k)
end

function CHE:textinput(t)
    Console.textinput(t)
end

local function updateMouse()
    Mouse.x, Mouse.y = love.mouse.getPosition()
end

function CHE:mousepressed(_, _, b)
    updateMouse()
    cursor:mousepressed(Mouse.x, Mouse.y, b)
    State.mousepressed(Mouse.x, Mouse.y, b)
end

function CHE:mousemoved(_, _, dx, dy)
    updateMouse()
    State.mousemoved(Mouse.x, Mouse.y, dx, dy)
end

function CHE:mousereleased(_, _, b)
    updateMouse()
    cursor:mousereleased(Mouse.x, Mouse.y, b)
    State.mousereleased(Mouse.x, Mouse.y, b)
end

function CHE:draw(dt)
    love.graphics.push()
    love.graphics.setCanvas({CHECanvas, stencil = true})
    love.graphics.clear(0, 0, 0, 1)

    local startFont = love.graphics.getFont()
    local lastLineWidth = love.graphics.getLineWidth()
    local lastColor = { love.graphics.getColor() }

    State.draw(dt)

    love.graphics.setFont(startFont)
    love.graphics.setLineWidth(lastLineWidth)
    love.graphics.setColor(lastColor)
    love.graphics.setCanvas()
    love.graphics.pop()

    local ratio = math.min(
        love.graphics.getWidth() / baseScreenRatio.x,
        love.graphics.getHeight() / baseScreenRatio.y
    )
    love.graphics.draw(
        CHECanvas,
        love.graphics.getWidth() / 2, love.graphics.getHeight() / 2,
        0, ratio, ratio,
        baseScreenRatio.x / 2, baseScreenRatio.y / 2
    )

    if Console.isVisible then
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle("fill", 0, 0, Console.width, Console.height)
        Console.draw()
    end

    cursor:draw()
end

function love.resize(w, h) end
function CHE:exit() end

return CHE
