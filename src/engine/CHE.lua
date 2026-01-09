local CHE = {}
Mouse = {}

local sessionBegin
function toCanvasCoords(mx, my)
    local ratio = math.min(love.graphics.getWidth() / baseScreenRatio.x, love.graphics.getHeight() / baseScreenRatio.y)
    mx = (mx - love.graphics.getWidth() / 2) / ratio + baseScreenRatio.x / 2
    my = (my - love.graphics.getHeight() / 2) / ratio + baseScreenRatio.y / 2
    return mx, my
end

function mouseOver(object)
    local mx, my = cursor:getPosition()
    return mx >= object.x and mx <= object.x + object.width and
           my >= object.y and my <= object.y + object.height
end

function CHE:init()

    Console = require("engine.modules.console")

    baseScreenRatio = { x = 2560, y = 1440 }

    CHECanvas = love.graphics.newCanvas(baseScreenRatio.x, baseScreenRatio.y)
    love.graphics.setDefaultFilter("linear")

    require("modules.controls")
    Input = setupControls()

    require("engine.modules.lua")
    Class = require("engine.class.class")
    State = require("engine.state.State")
    require("modules.Transitions")
    States = require("modules.States")
    Timer = require("engine.lib.Timer")
    Ease = require("engine.lib.Ease")
    GIF = require("engine.lib.GIF")
    Profiler = require("engine.modules.profiler")
    GIF.pushLove()
    GIF.enableDrawUpdates()
    WINDOW = require("engine.modules.window")

    -- game stufffff :3
    maniaGrades = require("modules.maniaGrades") -- this is here but judgments isnt because this one isnt just a table like judgements is

    if type(WINDOW) ~= "table" then WINDOW = nil end
    if WINDOW then
        local ok = WINDOW.setDarkMode(WINDOW.isDarkMode())
        if not ok then
            print("Failed to set dark mode for window.")
        end
    end
    NOTIFICATIONS = require("engine.modules.notifications")
    if type(NOTIFICATIONS) ~= "table" then NOTIFICATIONS = nil end
    require("modules.Objects")

    cursor = cursor()

    local screenMiddle = baseScreenRatio.x / 2
    musicPath = "Music/"
    maniaNoteSize = 180
    sliderNoteSize = 180
    maninaLaneGap = 10
    maniaScrollSpeed = 2.85
    maniaLaneYOffset = 110

    gameplayBackgroundDim = 0.65

    CHETime = {real = 0, session = 0}
    sessionBegin = love.timer.getTime()

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
    local id = 1
    if NOTIFICATIONS then
        NOTIFICATIONS.setAppID("com.ch.harmoni")
    end

    self.flashbangsound = love.audio.newSource("sounds/flashbang.mp3", "static")
    self.flashbangimage = nil
    self.flashbangalphas = {rect = 0, img = 0}
   -- CHE:flashbangTrigger()
end

function CHE:update(dt)
    local id = 1
    Mouse.x, Mouse.y = love.mouse.getPosition()

    State.update(dt)
    Input:update()
    Timer.update(dt)
    cursor:update(dt)

    CHETime.real, CHETime.session = self:updateTime()

    love.mouse.setVisible(false)
    if NOTIFICATIONS then NOTIFICATIONS.update() end
end

function CHE:updateTime()
    local sessionTimeStamp = love.timer.getTime() - sessionBegin
    local sessionHours = math.floor(sessionTimeStamp/3600)
    local sessionMinutes = math.floor((sessionTimeStamp%3600))/60

    local realTime = os.date("%I:%M %p")
    local sessionTime = string.format("%02d:%02d",sessionHours,sessionMinutes)
    return realTime, sessionTime
end

function CHE:keypressed(k, sc, isrepeat)
    if k == "q" then CHE:flashbang() end
    Console.keypressed(k)
end

function CHE:textinput(t)
    Console.textinput(t)
end

local function updateMouse(mx, my)
    Mouse.x, Mouse.y = mx, my
end

function CHE:mousepressed(x, y, b)
    updateMouse(x, y)
    cursor:mousepressed(Mouse.x, Mouse.y, b)
    State.mousepressed(Mouse.x, Mouse.y, b)
end

function CHE:mousemoved(x, y, dx, dy)
    updateMouse(x, y)
    State.mousemoved(Mouse.x, Mouse.y, dx, dy)
end

function CHE:mousereleased(x, y, b)
    updateMouse(x, y)
    cursor:mousereleased(Mouse.x, Mouse.y, b)
    State.mousereleased(Mouse.x, Mouse.y, b)
end

function CHE:flashbangTrigger()
    Timer.after(4, function() 
        local num = love.math.random(1,3)
        print("flashbang chance ", num)
        if num == 3 and not self.doingflashbang then
            CHE:flashbang()
        end
        CHE:flashbangTrigger()
    end)
end

function CHE:flashbang()
    self.doingflashbang = true
    Timer.after(0.1, function() end)
    love.graphics.captureScreenshot(function (capture)
        self.flashbangsound:play()
        self.flashbangalphas = {rect = 1, img = 1}
        self.flashbangimage = love.graphics.newImage(capture)
        self.flashrecttimer = Timer.after(2.7, function()
            Timer.tween(1, self.flashbangalphas, {rect = 0})
            Timer.tween(2, self.flashbangalphas, {img = 0}, "linear", function()
                self.doingflashbang = false
            end)
        end)
    end)
end


function CHE:draw(dt)
    local lastFont = defaultFont
    love.graphics.push()
        love.graphics.setCanvas({CHECanvas, stencil = true})
            love.graphics.clear(0, 0, 0, 1)

            local startFont = love.graphics.getFont()
            local lastLineWidth = love.graphics.getLineWidth()
            local r, g, b, a = love.graphics.getColor()

            State.draw(dt)

            love.graphics.setFont(startFont)
            love.graphics.setLineWidth(lastLineWidth)
            love.graphics.setColor(r, g, b, a)
        love.graphics.setCanvas()
    love.graphics.pop()

    local ratio = math.min(
        love.graphics.getWidth() / baseScreenRatio.x,
        love.graphics.getHeight() / baseScreenRatio.y
    )

    if murica then
        love.graphics.setShader(murica)
    end

    love.graphics.draw(
        CHECanvas,
        love.graphics.getWidth() / 2, love.graphics.getHeight() / 2,
        0, ratio, ratio,
        baseScreenRatio.x / 2, baseScreenRatio.y / 2
    )

    if murica then
        love.graphics.setShader()
    end

    if Console.isVisible then
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle("fill", 0, 0, Console.width, Console.height)
        Console.draw()
    end

    cursor:draw()

    local DPS, UPS = love.timer.getFPS()
    love.graphics.setColor(0, 0, 0)

    local graphicStats = love.graphics.getStats()
    local drawCalls = graphicStats.drawcalls or 0
    local drawCallsBatched = graphicStats.drawcallsbatched or 0
    local textureMemory = graphicStats.texturememory or 0

    local str = string.format("UPS: %d, DPS: %d\nDrawCalls: %d (%d batched)\nTextureMemory: %dMB", UPS, DPS, drawCalls, drawCallsBatched, textureMemory/1024/1024)
    for x = -1, 1 do
        for y = -1, 1 do
            love.graphics.printf(str, x, y, love.graphics.getWidth(), "right")
        end
    end
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(str, 0, 0, love.graphics.getWidth(), "right")

    love.graphics.setFont(lastFont)

    if self.doingflashbang then
        love.graphics.setColor(1,1,1,self.flashbangalphas.img)
        if self.flashbangimage then love.graphics.draw(self.flashbangimage) end
        love.graphics.setColor(1,1,1,self.flashbangalphas.rect)
        love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),love.graphics.getHeight())
        love.graphics.setColor(1,1,1,1)
    end
end

function CHE:exit() end

return CHE
