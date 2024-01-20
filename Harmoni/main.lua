local utf8 = require("utf8")
Inits = require("inits")



love.keyboard.setKeyRepeat(true)

songListLength = love.filesystem.getDirectoryItems("Music")
if #songListLength == 0 then
    print("Install Included Songs")
    includedSongs = love.filesystem.getDirectoryItems("Included Songs")
    --print(#love.filesystem.getDirectoryItems("Included Songs"))
    for i,dir in ipairs(includedSongs) do
        local path = "Music/"..dir
       -- print(path)
        love.filesystem.createDirectory(path)
        local files = love.filesystem.getDirectoryItems("Included Songs/"..dir)
        print("Included Songs/"..dir)
        print(#files)
        for i,file in ipairs(files) do
            love.filesystem.write(path.."/"..file, love.filesystem.read("Included Songs/"..dir.."/"..file))
        end
    end
end


--[[

for _,dir in ipairs(tracks) do
    -- this is the path you want to use in the save folder, combined with the current track's folder name
    local path = 'music/' .. dir
    -- this creates music as well, if it didn't exist before.
    lfs.createDirectory(path)
    -- get all files within the current track's folder
    local stuff = lfs.getDirectoryItems(path)
    -- iterate over those and copy them out to the correct place
    for _,file in ipairs(stuff) do
      love.filesystem.write(path .. '/' .. file, love.filesystem.read('_music/' .. dir .. '/' .. file))
    end
  end

  --]]

if disablePrint then
    function print() end
end
 
function toGameScreen(x, y)
    -- converts a position to the game screen
    local ratio = 1
    ratio = math.min(Inits.GameWidth/Inits.GameWidth, Inits.GameHeight/Inits.GameHeight)
    local x, y = x - Inits.GameWidth/2, y - Inits.GameHeight/2
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
            GameConfirm  =  { "key:return" },

            MenuUp = { "key:up" },
            MenuDown = { "key:down" },
            MenuConfirm = { "key:return" },

            setFullscreen = { "key:f11" },
            MenuBack = { "key:escape", "key:backspace" },
            SearchToggle = { "key:tab"},
            openSongGoogleDrive = { "key:f1" },
            openSongFolder = { "key:f2" }
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
    MusicTime = 0


    Tips = {
        "Press F11 to Fullscreen.",
        "Please report any bugs you find by opening a Github issue",
        "Press R in the Song Select menu to pick a random song \n(not even added yet lmfao this is just here so i dont forget to add it)", -- this isnt even added yet lmfao
        "Request features by opening a Github issue",
        "Don't miss",
        "Settings will work correctly eventually I promise lmao",
        "Wishlist Rit on Steam!"
    }

    extremeRareTips = {
        "you should just delete the game honestly",
        "still better than osu",
        "'did you know that in heat colors change to another color dont believe me stick your fingers up your ass'\n- Sapple",

    }

    volume = 1
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

    if Input:pressed("setFullscreen") then
        isFullscreen = not isFullscreen
        love.window.setFullscreen(isFullscreen, "exclusive")
    end

    volumeOpacity[1] = volumeOpacity[1] - 1*dt
    volumeVelocity = math.max(0, volumeVelocity-100*dt)
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
    ratio = math.min(Inits.GameWidth/Inits.GameWidth, Inits.GameHeight/Inits.GameHeight)
    love.graphics.setColor(1,1,1,1)
    -- draw game screen with the calculated ratio and center it on the screen
    love.graphics.setShader(Shaders.CurrentShader)
    love.graphics.draw(GameScreen, Inits.GameWidth/2, Inits.GameHeight/2, 0, ratio, ratio, Inits.GameWidth/2, Inits.GameHeight/2)

    love.graphics.setShader()

    debug.printInfo()
    love.graphics.setFont(MenuFontSmall)

    love.graphics.setLineWidth(5)
    love.graphics.push()
    love.graphics.translate(Inits.GameWidth-200, Inits.GameHeight-250)
    love.graphics.setColor(1,1,1,volumeOpacity[1])


    love.graphics.scale(0.5,0.5)
    love.graphics.setColor(0,0,0,volumeOpacity[1])
    love.graphics.arc("fill",200,300,100,0, printableVolume[1]*math.pi*2)
    love.graphics.setColor(0,1,1,volumeOpacity[1])
    if printableVolume[1] < 0.98 then
        love.graphics.arc("line",200,300,100,0, printableVolume[1]*math.pi*2)
    else
        love.graphics.circle("line",200,300,100)
    end
    love.graphics.setColor(0,0.8,0.8,volumeOpacity[1])
    love.graphics.pop()



    love.graphics.print(math.ceil(love.audio.getVolume()*100) .. "%",Inits.GameWidth-200+71,Inits.GameHeight-250+136)
    love.graphics.setColor(1,1,1)


end

function love.resize(w, h)
    Inits.GameWidth = w
    Inits.GameHeight = h
end

function love.quit()

end