require("love.init")
--require("modules.things")

-- i can NOT work on this game anywhere people can see my laptop cuz these fucking weird 
-- ass backgrounds FUCK YOU QUAVER AND OSU MAPPERS WHAT IS WRONG WITH YOU FUCKING PEOPLE
dontShowBG = false

spongebirth = love.graphics.newImage("images/spongebirth.png")

if type(jit) ~= nil and love.system.getOS() ~= "OS X" then
    jit.opt.start("maxtrace=8000", "maxrecord=16000")
    jit.opt.start("minstitch=3")
    jit.opt.start("maxmcode=40960")
end

function love.load(args)
    Settings = require("modules.Settings")
    Settings.default = Settings:defaultSettings()
    Settings:loadSettings()

    GPUInfo = {test = "HI"}
    love.graphics.setDefaultFilter("linear","linear")
    require("modules.extraFunctions")
    love.filesystem.createDirectory("Music")
    love.filesystem.createDirectory("Settings")

    SkinHandler = require("modules.skinHandler")
    LocaleHandler = require("modules.localeHandler")
    CLibs = require("modules.handleCLibs")
    Settings:addSkinsToSettings(SkinHandler:getAllSkins())

    CHE = require("engine.CHE")
    CHE:init()
        _G.GlobalNotificationsHandler = notificationsHandler()

    require("modules.gamemodes")

    require("bob")  -- bob 💖
    -- bob WILL be added

    maniaChartDifficultyCalculator = require("modules.maniaChartDifficultyCalculator")
    ChartParse = require("modules.chartParse")
    MusicTimeManager = require("modules.musicTimeManager")
    ScoreHandler = require("modules.scoreHandler")
    SongListManager = require("modules.songListManager")
    CaptionParser = require("modules.captionParser")




    -- seems to be the best place to load these so,,, we load modifiers in main lol 
    modifiersTable = require("modules.modifiers")

    State.switch(States.menu.preloadState)

    -- load objects
    printToConsole(SkinHandler:getRandomColors())
    throbbert = throbbert(SkinHandler:getRandomColors())
end

function love.update(dt)
    CHE:update(dt)
    throbbert:update(dt)
    _G.GlobalNotificationsHandler:update(dt) -- you laugh you go to HELL
end 

function love.mousepressed(x, y, b)
    CHE:mousepressed(x, y, b)
end

function love.mousemoved(x, y, dx, dy)
    cursor.dx, cursor.dy = toCanvasCoords(dx, dy)
    CHE:mousemoved(x, y, dx, dy)
end

function love.mousereleased(x, y, b)
    CHE:mousereleased(x, y, b)
end

function love.keypressed(key, scancode, isrepeat)
    CHE:keypressed(key, scancode, isrepeat)
end

function love.textinput(text)
    CHE:textinput(text)
end

function love.wheelmoved(x,y)
    State.scroll(y)
end

function love.resize(w, h) end

--if you wanna edit this, go to engine/CHE.lua and edit the CHE:draw() function to keep drawing in a letterboxed environment
function love.draw(dt)
    love.graphics.draw(spongebirth, 0, 0, 0, 0.5, 0.5)

    CHE:draw(dt)
    GlobalNotificationsHandler:draw()
end

function love.quit()
    CHE:exit()
end


