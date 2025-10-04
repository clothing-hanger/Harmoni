local transition = State("transition")
local BGImage
local background
local uhmmode, uhmchart
local songInfo
local timebar
local time
function transition:enter(parent,mode,chart,image,logoH, backgroundDim)
    self.logoH = logoH
    time = 0.5
    uhmmode, uhmchart = mode, chart
    chart = ChartParse.harmc(chart) -- yep we are just gonna parse the whole chart here lol,, why not
   printToConsole(image)
    timebar = {0}
    background = sharedBackground(image)
    background.dimness = backgroundDim
    self.textAlpha = 0
    background:changeDimness(0.8, time*0.1, function() end) --self:startTimer(time*0.8) end)
    Timer.after(0.15, function () self:raiseH()end)
    --self:raiseH()



    self.quickSettings = quickSettings(baseScreenRatio.x-500,0,10000,baseScreenRatio.y, baseScreenRatio.x-1000)
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

function transition:raiseH()
    Timer.tween(0.5, self.logoH, {y = self.logoH.y - 250}, "in-out-quad", function()     self:startTimer(time*0.8)
    end)

    Timer.tween(0.3, self, {textAlpha = 1})
end


function transition:startTimeRemaining()
    Timer.tween(time, timebar, {baseScreenRatio.x})
end

function transition:update(dt)
    background:update(dt)
    self.quickSettings:update(dt)

    self:checkForQuickSettingsHover()
end

function transition:checkForQuickSettingsHover()
    -- since its attached to the right side of the screen, and it takes up the entire height of the screen, 
    --we only have to check that the cursor's X is larger than the quick settings menu X
    local cursorX,cursorY = cursor:getPosition()
    self.quickSettings.hovered = cursorX >= self.quickSettings.x
end

function transition:switchToGame(mode,chart)
    --State.switch(States.game.gameModeManager, uhmmode, uhmchart)
end

function transition:draw()
    background:draw()

    local progress = (self.quickSettings.x - self.quickSettings.closedX) /(self.quickSettings.openX - self.quickSettings.closedX)
                     
    if progress > 0 then
        love.graphics.setColor(0, 0, 0, 0.5 * progress) 
        love.graphics.rectangle("fill", 0, 0, baseScreenRatio.x, baseScreenRatio.y)
                love.graphics.setColor(1, 1, 1)
    end

    love.graphics.push()
    love.graphics.translate(self.quickSettings.x - self.quickSettings.closedX, 0)

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
    love.graphics.setColor(1,1,1,self.textAlpha)
    love.graphics.printf(infoText, 0, baseScreenRatio.y / 2 + self.logoH.y-500, baseScreenRatio.x, "center")
    love.graphics.setColor(1,1,1)
    self.logoH:draw()

    love.graphics.pop()
    self.quickSettings:draw()
end


return transition