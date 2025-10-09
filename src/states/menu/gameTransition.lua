local transition = State("transition")
local BGImage
local background
local uhmmode, uhmchart
local songInfo
local timebar
local time
function transition:enter(parent,mode,chart,image,logoH, backgroundDim)
    self.logoH = logoH
    time = 2
    uhmmode, uhmchart = mode, chart
    chart = ChartParse.harmc(chart) -- yep we are just gonna parse the whole chart here lol,, why not
   printToConsole(image)
    timebar = {0}
    background = sharedBackground(image)
    background.dimness = backgroundDim
    self.textAlpha = 0
    background:changeDimness(0.8, time*0.1, function() end) 
    Timer.after(0.15, function () self:raiseH()end)
    --self:raiseH()

    self.initiatedSwitch = false

    self.countdownBar = countdownBar(baseScreenRatio.x/2, baseScreenRatio.y/2-50, 500, 20, time)
    self.quickSettings = quickSettings(baseScreenRatio.x-500,0,10000,baseScreenRatio.y, baseScreenRatio.x-1000)
    self.quickSettings.baseX = self.quickSettings.x
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



function transition:raiseH()
    Timer.tween(0.5, self.logoH, {y = self.logoH.y - 250}, "in-out-quad", function()    
    end)

    Timer.tween(0.3, self, {textAlpha = 1})
end




function transition:update(dt)
    background:update(dt)
    self.quickSettings:update(dt)

    self:checkForQuickSettingsHover()

    self.countdownBar:update(dt)
    
    if self.countdownBar.complete and not self.initiatedSwitch then self:switchToGame() end 

    if Input:pressed("menuBack") then State.switch(States.menu.songSelect) end
end

function transition:checkForQuickSettingsHover()
    -- since its attached to the right side of the screen, and it takes up the entire height of the screen, 
    --we only have to check that the cursor's X is larger than the quick settings menu X
    local cursorX,cursorY = cursor:getPosition()
    self.quickSettings.hovered = (cursorX >= self.quickSettings.x and not self.initiatedSwitch)
    self.countdownBar.paused = self.quickSettings.hovered
end

function transition:switchToGame(mode,chart)
    self.initiatedSwitch = true
    self.quickSettings.freezeX = true
    local time = 0.1
    background:changeDimness(gameplayBackgroundDim, 0.1)
    --State.switch(States.game.gameModeManager, uhmmode, uhmchart)
    Timer.tween(time, self, {textAlpha = 0})
        Timer.tween(time, self.quickSettings, {x = baseScreenRatio.x}, "linear", function() State.switch(States.game.gameModeManager, uhmmode, uhmchart) end)

end

function transition:draw()
        background:draw()
            local progress = (self.quickSettings.x - self.quickSettings.closedX) /(self.quickSettings.openX - self.quickSettings.closedX)
                     
    if progress > 0 then
        love.graphics.setColor(0, 0, 0, 0.5 * progress) 
        love.graphics.rectangle("fill", 0, 0, baseScreenRatio.x, baseScreenRatio.y)
        love.graphics.setColor(1, 1, 1)
    end

    local offsetX = self.quickSettings.x - self.quickSettings.closedX

    love.graphics.push()
    love.graphics.translate(offsetX, self.logoH.y - 500)

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
    love.graphics.printf(infoText, 0, baseScreenRatio.y / 2 , baseScreenRatio.x, "center")
    love.graphics.setColor(1,1,1)
    self.countdownBar:draw()
    love.graphics.pop()

    love.graphics.push()
    love.graphics.translate(offsetX, 0)
   self.logoH:draw()
    love.graphics.pop()
    self.quickSettings:draw()



end


function transition:draw()
    background:draw()

    -- clamp offset to max distance
    local offsetX = math.min(self.quickSettings.x - self.quickSettings.closedX,
                             self.quickSettings.baseX - self.quickSettings.closedX)

    local progress = offsetX / (self.quickSettings.openX - self.quickSettings.closedX)

    if progress > 0 then
        love.graphics.setColor(0, 0, 0, 0.5 * progress) 
        love.graphics.rectangle("fill", 0, 0, baseScreenRatio.x, baseScreenRatio.y)
        love.graphics.setColor(1, 1, 1)
    end

    -- info text + countdown
    love.graphics.push()
    love.graphics.translate(offsetX, self.logoH.y - 500)

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
    love.graphics.printf(infoText, 0, baseScreenRatio.y / 2 , baseScreenRatio.x, "center")
    love.graphics.setColor(1,1,1)
    self.countdownBar:draw()
    love.graphics.pop()

    -- logo follows offsetX but keeps its own Y
    love.graphics.push()
    love.graphics.translate(offsetX, 0)
    self.logoH:draw()
    love.graphics.pop()

    -- quick settings menu still moves with its own x
    self.quickSettings:draw()
end





return transition