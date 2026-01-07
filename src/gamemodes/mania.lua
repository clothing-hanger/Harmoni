local mania = Class:extend("mania")
local videoFade = 0
local played = false

function mania:new(chart, parent, fullChart, mods)
    videoFade = 0
    played = false
    self.mods = mods


    print(fullChart.meta.difficulty)
    self.parent = parent
    self.videoBackground = nil
    self.chartPath = getDirectory(chart)

    self.debug = false
    self.songStarted = false

    self.chart = self:setUpChart(chart, fullChart)
    self.scoreHandler = ScoreHandler

    self.endSongTimer = 0

    --score shit 
    self.scoreHandler:resetScore({difficulty = (fullChart.meta.difficulty) or 0})
    --ScoreHandler:setupPerformanceRating()

    self.scoresPerJudgements = self.scoreHandler:getScorePerJudgment(self.totalNotes)

    self.HUDBeatSize = 1
    printToConsole("FJIDFJOFI",self.scoresPerJudgements.perfect)
    printToConsole(self.chart)
    self.laneSpacing = 30
    self.laneYOffset = 30
    self.song = love.audio.newSource(self.chartPath .. "/" .. self.chart.meta.audioFile, "static")
    self.song:setLooping(false)
    self.playField = {maniaPlayField(self.chart, self)}

    mania.judgements = require("modules.maniaJudgements")

    self.inputsPerSecond = {}
    self.notesPerSecond = {}

    self:setUpObjects()
end


function mania:countdownhandler()

end


function mania:startSong(countdown)
    self.songStarted = true
    self.parent:startSong(countdown)
end

function mania:resetBpmShit(newBpm)
    self.bpmHandler:init()
    self.bpmHandler:setBpm(newBpm)
end

function mania:setUpObjects()
    local backgroundPath = self.chartPath .. self.chart.meta.backgroundFile
    self.background = sharedBackground(backgroundPath, gameplayBackgroundDim, 1)
    self.HUD = maniaHUD(self)
    self.bpmHandler = require("modules.bpm")
    self:resetBpmShit(0)

    self.comboAlert = maniaComboAlert()

    self.HUD:sendScoreHandlerScores(self.scoreHandler.Scores)

    
    

    self.judgementCount = maniaJudgmentCount()
    self.judgementCount:sendJudgements(self.judgements)

    self.countdownBar = countdownBar(baseScreenRatio.x/2, baseScreenRatio.y/2-50, 500, 20, 1.5)

    local songLength = self.song and self.song:getDuration("seconds") or 0
    self.timeRemaingBar = UITimeRemaing(
        0, songLength,
        0, baseScreenRatio.y - 50,
        baseScreenRatio.x,
        self,
        5, -5, 5, 30
    )

    self.judgementObject = maniaJudgement(
        SkinHandler:getParam("Judgement X Offset"),
        SkinHandler:getParam("Judgement Y Offset"),
        SkinHandler:getParam("Judgement Size"),
        self.judgements,
        self
    )

    self.comboCount = maniaComboCount(
        SkinHandler:getParam("Combo X Offset"),
        SkinHandler:getParam("Combo Y Offset")
    )

    self.healthBar = maniaHealthBar(
        SkinHandler:getParam("Health Bar X Offset"),
        SkinHandler:getParam("Health Bar Y Offset"),
        SkinHandler:getParam("Health Bar Width"),
        SkinHandler:getParam("Health Bar Height")
    )
end

function mania:setUpChart(chartpath, chart)
    local songPath = getDirectory(chartpath)
    local parsed = chart
    self.totalNotes = #parsed.hitObjects

    local maniaChart = {
        meta = parsed.meta,
        bpm = {},
        hitObjects = {},
        scrollVelocities = {}
    }

    -- Setup video background if valid
    if parsed.meta.backgroundVideo and getFileExtension(parsed.meta.backgroundVideo) == "mp4" then
        self.videoBackground = video(
            songPath .. "/" .. parsed.meta.backgroundVideo,
            baseScreenRatio.x / 2,
            baseScreenRatio.y / 2,
            nil,
            nil,
            gameplayBackgroundDim
        )
        if not self.videoBackground.image then
            self.videoBackground = nil
        else
            self.videoBackground.scaleX = baseScreenRatio.x / self.videoBackground.image:getWidth()
            self.videoBackground.scaleY = baseScreenRatio.y / self.videoBackground.image:getHeight()
        end
    end

    for _, BpmChange in ipairs(parsed.bpm) do
        table.insert(maniaChart.bpm, {startTime = BpmChange.startTime, bpm = BpmChange.bpm})
    end

    for _, SliderVelocity in ipairs(parsed.sliderVelocities) do
        table.insert(maniaChart.scrollVelocities, {
            startTime = SliderVelocity.startTime,
            multiplier = SliderVelocity.multiplier
        })
    end
    if self.mods["NSV"] then maniaChart.scrollVelocities = {} end
    for _, obj in ipairs(parsed.hitObjects) do
        if self.mods["NLN"] then obj.endTime = nil end
        table.insert(maniaChart.hitObjects, {
            type = obj.type,
            startTime = obj.startTime,
            endTime = obj.endTime,
            lane = obj.lane
        })
    end

    maniaChart.scrollSpeedFactors = parsed.scrollSpeedFactors or {}

    if self.mods["NVB"] then
        self.videoBackground = nil
    end


        -- look for the lyrics file

    local validTypes = {
        "srt",
        "vtt",
        "sbv",
        "stl",
        "ass",
        "lua"
    }

    local type = ""
    local path = songPath .. "/lyrics."
    for _, t in ipairs(validTypes) do
        if love.filesystem.getInfo(path .. t, "file") then
            type = t
            break
        end
    end

    local lyrics
    if type ~= "lua" and type ~= "" then
        lyrics = CaptionParser.parse(love.filesystem.read(path .. type), type)
    elseif type == "lua" then
        lyrics = CaptionParser.parse(path .. type, type)
    end
    self.lyricsRenderer = lyricsRenderer(baseScreenRatio.x-570,30,540,baseScreenRatio.y-200, lyrics)

    print(type)

    return maniaChart
end

function mania:update(dt)
    Profiler:start("GAMEMODE:UPDATE")
    self:updateObjects(dt)

    for _, playField in ipairs(self.playField) do
        playField:update(dt)
    end

    if self.song and self.playField[1].finished then
        printToConsole("SONG END 1")
        if not self.song:isPlaying() then printToConsole("SONG END 2"); self:endSong() end
    end

    if self.song and MusicTime >= 0 and not self.song:isPlaying() and not played then
        self.song:play()
        self:resetBpmShit(self.chart.meta.bpm)

        if self.videoBackground then self.videoBackground:play() end
        played = true
    else
        if self.videoBackground and played then
            videoFade = math.min(videoFade + dt*5, 1)
        end
    end

    if thething then
        thething = false
        self:endSong()
    end

    for i = 1,#self.inputsPerSecond do
        self.inputsPerSecond[i] = self.inputsPerSecond[i]-1000*dt
        if self.inputsPerSecond[i] <= 0 then table.remove(self.inputsPerSecond, i) break end
    end

    for i = 1,#self.notesPerSecond do
        self.notesPerSecond[i] = self.notesPerSecond[i]-1000*dt
        if self.notesPerSecond[i] <= 0 then table.remove(self.notesPerSecond, i) break end
    end    
    
    self.endSongTimer = math.max(self.endSongTimer + (Input:down("menuBack") and 1200 or -3000) * dt,0)
    if self.endSongTimer>=1000 then self:endSong() end


    if self.chart and self.chart.bpm then
        for i, BpmChange in ipairs(self.chart.bpm) do
            if MusicTime >= BpmChange.startTime and not BpmChange.wasHit then
                self:resetBpmShit(BpmChange.bpm)
                BpmChange.wasHit = true
            end
        end
    end
    Profiler:stop("GAMEMODE:UPDATE")

    --local avg, last = Profiler:getAverage("GAMEMODE:UPDATE"), Profiler:getLastTime("GAMEMODE:UPDATE")
    --print("Time to update MANIA GAMEMODE: ", last, "\nAverage: ", avg)
end

function mania:endSong()
    print("mania:endSong()")
    if self.song then self.song:stop();printToConsole("SONG END 3") end
  --  love.audio.stop()
    self.song = nil
    self.chart = nil
    self.playField = {}
    State.switch(States.menu.songSelect, self)  -- fuck that unfinished ass results screen, we will just skip it for now
end


function mania:updateObjects(dt)
    if self.videoBackground then self.videoBackground:update(dt) end
    self.background:update(dt)
    self.countdownBar:update(dt)
    if self.countdownBar.complete and not self.songStarted then self:startSong(1) end
    self.judgementObject:update(dt)
    if self.song then self.timeRemaingBar:update(dt, self.song:tell()/self.song:getDuration()) end
    self.comboCount:update(dt)
    self.healthBar:update(dt)
    self.HUD:sendScoreHandlerScores(self.scoreHandler.Scores)
    self.bpmHandler:update(dt)

    if self.lyricsRenderer then
        self.lyricsRenderer:update(dt, MusicTime/1000)
    end

    self.HUD:update(dt) -- we also gotta send values to the hud
    self.HUD:sendValues(self.scoreHandler:getScore("printable"), self.scoreHandler:getAccuracy("printable"))

    if self.healthBar.health <= 0 and not self.mods["NF"] then
        self:gameOver()
    end

    if self.bpmHandler:wasBeatHit() then
        self:onBeat()
    end
end

function mania:onBeat()
    if self.beatFuckThingyIdk == nil then self.beatFuckThingyIdk = false end
            self.beatFuckThingyIdk = not self.beatFuckThingyIdk
    if self.timeBarBeatTween then Timer.cancel(self.timeBarBeatTween) end
    local timeBarTime = 1
    local timeBarAmplitude = 5
    if self.beatFuckThingyIdk then 
        self.timeRemaingBar.squiglyLine.amplitude = timeBarAmplitude
        self.timeBarBeatTween = Timer.tween(0.5, self.timeRemaingBar.squiglyLine, {time = self.timeRemaingBar.squiglyLine.time-1, amplitude = 0}, "out-quad")
    end
    if self.healthBarBeatTween then Timer.cancel(self.healthBarBeatTween) end
    self.healthBar.line.amplitude = 5
    self.healthBarBeatTween = Timer.tween(0.5, self.healthBar.line, {time = self.healthBar.line.time-5, amplitude = 0}, "out-quad")    -- FAKE liquid ass!!

    self.HUDBeatSize = 1.01
    if self.HUDSizeTween then Timer.cancel(self.HUDSizeTween) end   -- OOH EMM GEE ITS EFF ENN EFF !!!!!
    self.HUDSizeTween = Timer.tween(0.5, self, {HUDBeatSize = 1}, "out-quad")

end

function mania:gameOver()
    self:endSong()  -- remove this to see the gameover, but youll be softlocked

    if self.parent.gameOver then return end
    self.parent.gameOver = true
    for _, playField in ipairs(self.playField) do
        playField:gameOver()
    end

end


function mania:draw()
    Profiler:start("GAMEMODE:DRAW")
    self.background:draw()
    if self.videoBackground then
        self.videoBackground.alpha = videoFade
        self.videoBackground:draw()
    end

    -- Prepare batches
    local arrowBatch = SkinHandler:getBatch("Arrows")
    local receptorBatch = SkinHandler:getBatch("Receptors")
    local noteBatch = SkinHandler:getBatch("Notes")
    local judgementBatch = SkinHandler:getBatch("Judgements")

    if arrowBatch then arrowBatch:clear() end
    if receptorBatch then receptorBatch:clear() end
    if noteBatch then noteBatch:clear() end
    if judgementBatch then judgementBatch:clear() end

    for _, playField in ipairs(self.playField) do
        playField:draw()
    end

    if arrowBatch then love.graphics.draw(arrowBatch) end
    if receptorBatch then love.graphics.draw(receptorBatch) end
    if noteBatch then love.graphics.draw(noteBatch) end

    self.judgementObject:draw()
    if judgementBatch then love.graphics.draw(judgementBatch) end

    self.comboCount:draw()
    self.timeRemaingBar:draw()
    self.healthBar:draw()

    self.countdownBar:draw()
    love.graphics.translate(baseScreenRatio.x/2, baseScreenRatio.y/2)
    love.graphics.scale(self.HUDBeatSize)
    love.graphics.translate(-baseScreenRatio.x/2, -baseScreenRatio.y/2)

    self.HUD:draw()

    self.comboAlert:draw()
    --love.graphics.scale(-self.HUDBeatSize)


    self.judgementCount:draw()

    if self.lyricsRenderer then
        self.lyricsRenderer:draw(self.song:tell())
    end

    -- draw the pause fade over everything else
    love.graphics.setColor(0,0,0,(self.endSongTimer/1000)*0.8)
    love.graphics.rectangle("fill", 0, 0, baseScreenRatio.x, baseScreenRatio.y)

    love.graphics.setColor(1,1,1,1)

    if self.debug then 
        love.graphics.print(MusicTime, 250, 400)
    end

    Profiler:stop("GAMEMODE:DRAW")
    --[[ local avg, last = Profiler:getAverage("GAMEMODE:DRAW"), Profiler:getLastTime("GAMEMODE:DRAW")
    print("Time to draw MANIA GAMEMODE: ", last, "\nAverage: ", avg) ]]
end

return mania
