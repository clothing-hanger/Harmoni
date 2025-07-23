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
    chart = ChartParse.harmc(chart) -- yep we are just gonna parse the whole chart here lol,, why not
    print(image)
    timebar = {0}
    background = sharedBackground(image)

    background:changeDimness(0.8, time*0.1, function() self:startTimer(time*0.8) end)
    self:startTimeRemaining()


    songInfo = {
        songName = chart.meta.title or "Unknown",
        diffName = chart.meta.difficultyName or "Unknown",
        mode = chart.meta.gameMode or "Unknown",
        artist = chart.meta.artist or "Unknown",
        charter = chart.meta.creator or "Unknown",
        mods = "the game doesnt even have mods..",
        notes = "if its not obvious enough, this is a placeholder",
    }
end

function transition:startTimer(timeToStart)
    Timer.after(timeToStart, function()
        background:changeDimness(gameplayBackgroundDim, timeToStart * 0.1, function()
            self:switchToGame(uhmmode, uhmchart)
        end)
    end)
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
    local infoText = string.format(
        "Song: %s\nDifficulty: %s\nMode: %s\nProduced by: %s\nCharted by: %s\nActive Modifiers: %s\n%s",
        songInfo.songName,
        songInfo.diffName,
        songInfo.mode,
        songInfo.artist,
        songInfo.charter,
        songInfo.mods,
        songInfo.notes or "No notes available"
    )
    love.graphics.printf(infoText, 0, baseScreenRatio.y / 2 - 235, baseScreenRatio.x, "center")

    love.graphics.rectangle("fill",0,baseScreenRatio.y-100,timebar[1],50)
end

return transition