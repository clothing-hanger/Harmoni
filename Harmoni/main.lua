Inits = require("inits")
love.keyboard.setKeyRepeat(true)
local utf8 = require("utf8")
require("settings")
if disablePrint then
    function print() end
end
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

function love.directorydropped(file)
    love.filesystem.mount(file, "Music")
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
            setFullscreen = { "key:f11" },
            MenuBack = { "key:escape", "key:backspace" },
            SearchToggle = { "key:tab"},
        }
    })
    Class = require("Libraries.Class")
    State = require("Libraries.State")
    tinyyaml = require("Libraries.tinyyaml")

    Timer = require("Libraries.Timer")

    GameScreen = love.graphics.newCanvas(Inits.GameWidth, Inits.GameHeight)

    -- Initialize Game
    States = require("Modules.States")
    Shaders = require("Modules.Shaders")
    Objects = require("Modules.Objects")
    String = require("Modules.String")
    ChartParse = require("Modules.ChartParse")

    require("Modules.Debug")


    volumeOpacity = {0}
    volumeVelocity = 0
    printableVolume = {love.audio.getVolume()}
    maxVolVelocity = 25


    Tips = {
        "Press F11 to Fullscreen.",
        "Please report any bugs you find by opening a Github issue",
        "Press R in the Song Select menu to pick a random song", -- this isnt even added yet lmfao
        "Request features by opening a Github issue",
        "Don't miss",
        "Settings will be added eventually I promise lmao"
    }

    extremeRareTips = {
        ""
    }

    ExtraBigFont = love.graphics.newFont("Fonts/verdana.ttf", 60)
    ReallyFuckingBigFont = love.graphics.newFont("Fonts/framdit.ttf", 400)

    BigFont = love.graphics.newFont("Fonts/framdit.ttf", 50)
    MediumFont = love.graphics.newFont("Fonts/framdit.ttf", 25)
    MenuFontBig = love.graphics.newFont("Fonts/verdana.ttf", 30)
    MenuFontSmall = love.graphics.newFont("Fonts/verdana.ttf", 20)
    MenuFontExtraSmall = love.graphics.newFont("Fonts/verdana.ttf", 16)


    DefaultFont = love.graphics.newFont(12)
    State.switch(States.TitleState)
end

function love.update(dt)
    MusicTime = MusicTime + (love.timer.getTime() * 1000) - (previousFrameTime or (love.timer.getTime()*1000))
    previousFrameTime = love.timer.getTime() * 1000
    Input:update()
    State.update(dt)
    Timer.update(dt)
    volumeOpacity[1] = volumeOpacity[1] - 1*dt
    volumeVelocity = math.max(0, volumeVelocity-100*dt)

    if Input:pressed("setFullscreen") then
        isFullscreen = not isFullscreen
        love.window.setFullscreen(isFullscreen, "exclusive")
    end
    love.audio.setVolume(volume)
    tweenVolumeDisplay()

    if songSelectSearch then
        searchSongs()
    end


end

function love.textinput(t)
    if songSelectSearch then
        search = search .. t
    end
end

function love.keypressed(key)

    if key == "backspace" then
        -- get the byte offset to the last UTF-8 character in the string.
        local byteoffset = utf8.offset(search, -1)

        if byteoffset then
            -- remove the last UTF-8 character.
            -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
            search = string.sub(search, 1, byteoffset - 1)
        end
    end
end

function tweenVolumeDisplay()
    if volumeTween then
        Timer.cancel(volumeTween)
    end
    volumeTween = Timer.tween(0.2, printableVolume, {love.audio.getVolume()}, "out-back")  --using out-back makes it feel snappier
end

function love.wheelmoved(x,y)

    if love.keyboard.isDown("lalt") or love.keyboard.isDown("ralt") then
        volumeOpacity[1] = 1
        volumeVelocity = math.min(maxVolVelocity, volumeVelocity+2.5)
        if y < 0 then  -- down
            if math.abs(volumeVelocity) < 6 then
                volume = math.max(love.audio.getVolume()+(y*0.01),0)
            else
                volume = math.max(love.audio.getVolume()+(y*0.01)*(volumeVelocity),0)
            end
        else        -- up
            if math.abs(volumeVelocity) < 6 then
                volume = math.min(love.audio.getVolume()+(y*0.01),1)
            else
                volume = math.min(love.audio.getVolume()+(y*0.01)*(volumeVelocity),1)
            end
        end
    elseif curScreen == "songSelect" then
        scrollSongs(y)
    elseif curScreen == "title" then
        scrollTitleButtons(y)
    end
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
    love.graphics.setFont(ExtraBigFont)
    love.graphics.setColor(1,1,1,volumeOpacity[1])
    love.graphics.setColor(0,0,0,volumeOpacity[1])
    love.graphics.arc("fill",200,300,100,0, printableVolume[1]*math.pi*2)
    love.graphics.setLineWidth(5)
    love.graphics.setColor(0,1,1,volumeOpacity[1])
    if printableVolume[1] < 0.98 then
        love.graphics.arc("line",200,300,100,0, printableVolume[1]*math.pi*2)
    else
        love.graphics.circle("line",200,300,100)
    end
    love.graphics.setColor(1,1,1,volumeOpacity[1])

    love.graphics.print(math.ceil(love.audio.getVolume()*100) .. "%",200-85,300-40)
    love.graphics.setColor(1,1,1)


end

function love.resize(w, h)
    Inits.WindowWidth = w
    Inits.WindowHeight = h
end

function love.quit()

end