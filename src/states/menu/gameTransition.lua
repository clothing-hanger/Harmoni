local transition = State("transition")
local BGImage
local background
local uhmmode, uhmchart, fullchart
local songInfo
local timebar
local time
function transition:enter(parent,mode,chart,image,logoH, backgroundDim, audio, mods)
    self.mods = mods
    self.audio = audio
    self.audio.audio:seek(self.audio.time)
    self.audio.audio:setVolume(self.audio.volume)
    self.audio.audio:play()
    self.logoH = logoH
    time = 2
    uhmmode, uhmchart = mode, chart
    fullchart = ChartParse.harmc(chart, "get", true) -- yep we are just gonna parse the whole chart here lol,, why not
                                            -- This is actually a good way to do it im ngl you thought good
                                                       --it was to prevent any weirdly long frame while gamemodemanager or mania parses the chart. all modes use harmc files so they can all be parsed here

    print("DIFFICULTY:", fullchart.meta.difficulty)
    timebar = {0}
    background = sharedBackground(image)
    background.dimness = backgroundDim
    self.textAlpha = 0
    background:changeDimness(0.8, time*0.1, function() end) 
    Timer.after(0.15, function () self:raiseH()end)

    self.initiatedSwitch = false

    self.countdownBar = countdownBar(baseScreenRatio.x/2, baseScreenRatio.y/2-50, 500, 20, time)
    self.quickSettings = quickSettings(baseScreenRatio.x-500,0,10000,baseScreenRatio.y, baseScreenRatio.x-1000)
    self.quickSettings.baseX = self.quickSettings.x
    self.quickSettings.x = self.quickSettings.baseX+self.quickSettings.width
    local modList = ""
    for i, Modifier in pairs(self.mods) do
        if Modifier then modList = modList.. i  .. "," end
    end
    if modList == "" then modList = "None" end
    songInfo = {
        songName = fullchart.meta.title or "Unknown",
        diffName = fullchart.meta.difficultyName or "Unknown",
        mode = fullchart.meta.gameMode or "Unknown",
        artist = fullchart.meta.artist or "Unknown",
        charter = fullchart.meta.creator or "Unknown",
        mods = modList,
        notes = "",
    }

    self.font = SkinHandler:getFont("Menu", 35)

    
end

function transition:raiseH()
    Timer.tween(0.5, self.logoH, {y = self.logoH.y - 250}, "in-out-quad", function()    
    end)

    Timer.tween(0.3, self, {textAlpha = 1})
end

function transition:update(dt)
    background:update(dt)
    self.quickSettings:update(dt)
    self.audio.audio:setVolume(self.audio.volume)

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
    ---@diagnostic disable-next-line: redefined-local
    local time = 0.1
    background:changeDimness(gameplayBackgroundDim, time)
        Timer.tween(time, self.audio, {volume = 0}, "linear", function() love.audio.stop() end)

    Timer.tween(time, self, {textAlpha = 0})
        Timer.tween(time, self.quickSettings, {x = baseScreenRatio.x}, "linear",
        function()
            State.switch(States.game.gameModeManager, uhmmode, uhmchart, fullchart, self.mods)
        end
    )

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

        love.graphics.setFont(self.font)

        local song,difficulty,mode,produced,charted,mods = LocaleHandler:getText("Transition", "Song"), LocaleHandler:getText("Transition", "Difficulty"), LocaleHandler:getText("Transition", "Mode"), LocaleHandler:getText("Transition", "Produced"), LocaleHandler:getText("Transition", "Charted"), LocaleHandler:getText("Transition", "Mods")
        local infoText = string.format(
            song .. "%s\n" ..difficulty .. "%s\n" .. mode .. "%s\n" .. produced .. "%s\n" .. charted .. "%s\n" .. mods .. "%s",
            songInfo.songName,
            songInfo.diffName,
            songInfo.mode,
            songInfo.artist,
            songInfo.charter,
            songInfo.mods
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