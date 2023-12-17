local TitleState = State()

function TitleState:enter()
    songList = love.filesystem.getDirectoryItems("Music")
    randomSong = love.math.random(1,#songList)
    logo = love.graphics.newImage("Images/TITLE/logo.png")

    H = love.graphics.newImage("Images/TITLE/H.png")
    R = love.graphics.newImage("Images/TITLE/R.png")
    O = love.graphics.newImage("Images/TITLE/O.png")
    I = love.graphics.newImage("Images/TITLE/I.png")

    background = love.graphics.newImage("Music/" .. songList[randomSong] .. "/background.jpg")
    titleSong = love.audio.newSource("Music/" .. songList[randomSong] .. "/audio.mp3", "stream")
    chart = love.filesystem.load("Music/" .. songList[randomSong] .. "/chart.lua")()
    titleSong:play()
    MusicTime = 0
    logoSize = 1
end

function TitleState:update(dt)
    MusicTime = MusicTime + (love.timer.getTime() * 1000) - (previousFrameTime or (love.timer.getTime()*1000))
    previousFrameTime = love.timer.getTime() * 1000

    for i = 1,#chart do
        if -(MusicTime - chart[i][1]) < 10 then
            table.remove(chart, i)
            TitleState:logoBump()
            break
        end
    end

    logoSize = math.max(logoSize - 0.15*dt, 1)

    if Input:pressed("MenuConfirm") then
        titleSongLocation = titleSong:tell()
        titleSong:stop()
        State.switch(States.SongSelectState)
    end
end

function TitleState:logoBump()
    logoSize = math.min(logoSize + 0.01, 1.3)
end
--there was never anything here
function TitleState:draw()
    love.graphics.setColor(1,1,1,0.5)

    love.graphics.draw(background, 0, 0, nil, love.graphics.getWidth()/background:getWidth(),love.graphics.getHeight()/background:getHeight())
    love.graphics.translate(love.graphics.getWidth()/2-logo:getWidth()/2,20)
    love.graphics.setColor(1,1,1,1)
    love.graphics.translate(0,-100)
    for i = 1,#chart do
        if -(MusicTime - chart[i][1]) < love.graphics.getHeight()+100 then
            love.graphics.setColor(1,1,1,0.1)
            if chart[i][2] == 1 then
                love.graphics.draw(H, 0, -(MusicTime - chart[i][1]))
            elseif chart[i][2] == 2 then
                love.graphics.draw(R, 130, -(MusicTime - chart[i][1]))
            elseif chart[i][2] == 3 then
                love.graphics.draw(O, 280, -(MusicTime - chart[i][1]))
            elseif chart[i][2] == 4 then
                love.graphics.draw(I, 400, -(MusicTime - chart[i][1]))
            end
            love.graphics.setColor(1,1,1,1)
        end
    end

    love.graphics.draw(logo, logo:getWidth()/2, love.graphics.getHeight()/2-logo:getHeight()/2+100, nil, logoSize, logoSize, logo:getWidth()/2, logo:getHeight()/2)
end

return TitleState