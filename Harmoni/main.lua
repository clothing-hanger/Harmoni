Inits = require("inits")

function toGameScreen(x, y)
    -- converts a position to the game screen
    local ratio = 1
    ratio = math.min(Inits.WindowWidth/Inits.GameWidth, Inits.WindowHeight/Inits.GameHeight)
    local x, y = x - Inits.WindowWidth/2, y - Inits.WindowHeight/2
    x, y = x / ratio, y / ratio
    x, y = x + Inits.GameWidth/2, y + Inits.GameHeight/2
    love.graphics.setDefaultFilter("nearest")

    return x, y
end

function love.load()
    -- Setup Libraries
    Input = (require("Libraries.Baton")).new({
        controls = {
            GameLeft  =  { "key:d" },
            GameDown  =  { "key:f" },
            GameUp    =  { "key:j" },
            GameRight =  { "key:k" },
            GameConfirm  =  { "key:space", "key:return" },
            MenuUp = { "key:up" },
            MenuDown = { "key:down" },
            MenuConfirm = { "key:space", "key:return" },
            setFullscreen = { "key:f11" }
        }
    })
    Class = require("Libraries.Class")
    State = require("Libraries.State")
    Timer = require("Libraries.Timer")

    GameScreen = love.graphics.newCanvas(Inits.GameWidth, Inits.GameHeight)

    -- Initialize Game
    States = require("Modules.States")
    Shaders = require("Modules.Shaders")
    Objects = require("Modules.Objects")
    require("Modules.Debug")


    BigFont = love.graphics.newFont("Fonts/framdit.ttf", 50)
    MediumFont = love.graphics.newFont("Fonts/framdit.ttf", 25)
    MenuFontBig = love.graphics.newFont("Fonts/verdana.ttf", 30)
    MenuFontSmall = love.graphics.newFont("Fonts/verdana.ttf", 20)

    DefaultFont = love.graphics.newFont(12)
    State.switch(States.TitleState)
end

function love.update(dt)
    Input:update()
    State.update(dt)
    Timer.update(dt)
    if Input:pressed("setFullscreen") then
        isFullscreen = not isFullscreen
        love.window.setFullscreen(isFullscreen, "exclusive")
    end
end

function love.wheelmoved(x,y)
    --if State.current() == SongSelectState then
        scrollSongs(y)
end

function love.draw()
    love.graphics.push()
        love.graphics.setCanvas(GameScreen)
            love.graphics.clear(0,0,0,1)
            State.draw()
        love.graphics.setCanvas()
    love.graphics.pop()

    -- ratio
    local ratio = 1
    ratio = math.min(Inits.WindowWidth/Inits.GameWidth, Inits.WindowHeight/Inits.GameHeight)
    love.graphics.setColor(1,1,1,1)
    -- draw game screen with the calculated ratio and center it on the screen
    love.graphics.setShader(Shaders.CurrentShader)
    love.graphics.draw(GameScreen, Inits.WindowWidth/2, Inits.WindowHeight/2, 0, ratio, ratio, Inits.GameWidth/2, Inits.GameHeight/2)
    love.graphics.setShader()

    debug.printInfo()
end

function love.resize(w, h)
    Inits.WindowWidth = w
    Inits.WindowHeight = h
end

function love.quit()

end