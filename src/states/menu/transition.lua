local transition = State("transition")
local BGImage
local background
local uhmmode, uhmchart
local songInfo
local timebar
local time 
function transition:enter(previous,mode,chart,image)
    time = 0.5
    uhmmode, uhmchart = mode, chart
    local chart = ChartParse.harmc(chart) -- yep we are just gonna parse the whole chart here lol,, why not
    print(image)
    timebar = {0}
    background = sharedBackground(image)

    background:changeDimness(0.8, time*0.1, function() self:startTimer(time*0.8) end)
    self:startTimeRemaining()


    songInfo = {
        songName = chart.meta.title,
        diffName = chart.meta.difficultyName,
        mode = chart.meta.gameMode,
        artist = chart.meta.artist,
        charter = chart.meta.creator,
        mods = "the game doesnt even have mods..",
        notes = "if its not obvious enough, this is a placeholder",
    }
end

function transition:startTimer(time)
    print("hi?")
    local function uhhDoShit()
        background:changeDimness(gameplayBackgroundDim, time*0.1, function() self:switchToGame(uhmmode, uhmchart) end)
    end

    Timer.after(time, function() uhhDoShit() end)
end

function transition:startTimeRemaining()
    Timer.tween(time, timebar, {baseScreenRatio.x})
end

function transition:update(dt)
    background:update(dt)
end

function transition:switchToGame(mode,chart)
    State.switch(States.game.gameModeManager, uhmmode, uhmchart)
end

function transition:draw()
    background:draw()
    love.graphics.setFont(songButtonFontLarge)
    love.graphics.printf(
        "Song: " .. songInfo.songName .. "\n" .. 
        "Difficulty: " .. songInfo.diffName .. "\n" ..
        "Mode: " .. songInfo.mode .. "\n" ..
        "Produced by: " .. songInfo.artist .. "\n" ..
        "Charted by: " .. songInfo.charter .. "\n" ..
        "Active Modifiers: " .. songInfo.mods .. "\n" ..
        songInfo.notes,
        0,baseScreenRatio.y/2-235,baseScreenRatio.x,"center"
    )

    love.graphics.rectangle("fill",0,baseScreenRatio.y-100,timebar[1],50)
end

return transition