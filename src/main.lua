Inits = require("inits")
utf8 = require("utf8")
love.filesystem.createDirectory("Music")
love.filesystem.createDirectory("Settings")

love.audio.setVolume(0.15)

function toGameScreen(x, y)
    -- converts a position to the game screen
    local ratio = 1
    ratio = math.min(Inits.WindowWidth/Inits.GameWidth, Inits.WindowHeight/Inits.GameHeight)
    local x, y = x - Inits.WindowWidth/2, y - Inits.WindowHeight/2
    x, y = x / ratio, y / ratio
    x, y = x + Inits.GameWidth/2, y + Inits.GameHeight/2

    return x, y
end

function love.load()

    love.graphics.setDefaultFilter("linear")
    -- Setup Libraries
    require("Modules.Controls") -- this goes with other libs since it inits a lib
    Class = require("Libraries.Class")
    State = require("Libraries.State")
    Tinyyaml = require("Libraries.Tinyyaml")
    Timer = require("Libraries.Timer")

    -- Initialize Game
    GameScreen = love.graphics.newCanvas(Inits.GameWidth, Inits.GameHeight)
    States = require("Modules.States")
    Shaders = require("Modules.Shaders")
    Objects = require("Modules.Objects")
    Threads = require("Modules.Threads")
    require("Modules.Love")
    require("Modules.Lua")
    require("Modules.Constants")
    require("Modules.RGB")
    require("Modules.musicTime")
    require("Modules.TableToFile")
    require("Modules.Skin")
    require("Modules.Settings")
    require("Modules.Gradient")
    require("Modules.Parse")
    require("Modules.Debug")
    require("Modules.BPM")
    require("Modules.screenWipe")
    require("Modules.Notifications")
    require("Modules.Judgements")
    require("Modules.Grades")
    require("Modules.DifficultyCalculator")
    require("Modules.Cursor")
    require("Modules.VolumeControl")

    Skin:loadSkin()

    loadSettings()
    defaultFont = love.graphics.newFont(12)

    State.switch(States.Misc.PreLoader)
    debugInit()
    __updateDebugStats() -- force our stats to update

    --shaders
    riodejanerio = love.graphics.newShader("Shaders/rio-de-janerio.glsl")  --👅👅👅
end

---@diagnostic disable-next-line: duplicate-set-field
function love.update(dt)
    cursorText = nil
    if not console.isOpen then Input:update() end
    debugUpdate(dt)
    State.update(dt)
    Timer.update(dt)
    updateCursor(dt)
    debugUpdate(dt)
    notificationUpdate(dt)
    volumeUpdate(dt)

   -- updatemusicTimeFunction()   -- TEMPORARY FIX FOR SONGS NOT RESETTING

    mouseTimer = (mouseTimer and mouseTimer - 1000*dt) or 1000
    mouseMoved = false
end

function love.wheelmoved(_, y)
    if love.keyboard.isDown("ralt") or love.keyboard.isDown("lalt") then
        volumeScroll(y)
        return
    end
    State.wheelmoved(y)
end

function love.mousemoved()
    mouseMoved = true
    mouseTimer = 1000
end

function love.textinput(text)
    if console.isOpen then consoleTextinpput(text) end

    if State.current() == States.Menu.SettingsMenu then
        for _, TextBox in pairs(textBoxes) do
            TextBox:textinput(text)
        end
    end
end

function love.keypressed(key)
    if console.isOpen then
        consoleKeypressed(key)
    end
    if key == "f1" then
        console.isOpen = not console.isOpen
    end
    if State.current() == States.Menu.SettingsMenu then
        for _, TextBox in pairs(textBoxes) do
            TextBox:keypressed(key)
        end
    end
end

function love.draw()
    love.graphics.push()
        love.graphics.setCanvas(GameScreen)
            love.graphics.clear(0,0,0,1)
            State.draw()
            screenWipeDraw()
            notificationDraw()
            volumeControlDraw()
        love.graphics.setCanvas()
    love.graphics.pop()

    -- ratio
    local ratio = 1
    ratio = math.min(Inits.WindowWidth/Inits.GameWidth, Inits.WindowHeight/Inits.GameHeight)
    love.graphics.setColor(1,1,1,1)

    -- draw game screen with the calculated ratio and center it on the screen
    love.graphics.setShader(Shaders.CurrentShader)
    if freakyMode then
        love.graphics.setShader(riodejanerio)
    end
    love.graphics.draw(GameScreen, Inits.WindowWidth/2, Inits.WindowHeight/2, 0, ratio, ratio, Inits.GameWidth/2, Inits.GameHeight/2)
    love.graphics.setShader()
    
    cursorTextDraw()
    debugDraw()
end

function love.resize(w, h)
    Inits.WindowWidth = w
    Inits.WindowHeight = h
end

function love.quit()
    --States.Menu.SettingsMenu:saveSettings()
end