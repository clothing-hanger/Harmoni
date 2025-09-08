local mania = Class:extend("mania")

function mania:new(chart, parent)
    self.parent = parent
    self.videoBackground = nil
    self.chartPath = getDirectory(chart)


    self.debug = false

    

    self.chart = self:setUpChart(chart)
    self.scoreHandler = ScoreHandler

    --score shit 
    ScoreHandler:resetScore()

    self.scoresPerJudgements = ScoreHandler:getScorePerJudgment(self.totalNotes)


   printToConsole("FJIDFJOFI",self.scoresPerJudgements.perfect)
   printToConsole(self.chart)
    self.laneSpacing = 30
    self.laneYOffset = 30
    self.playField = {maniaPlayField(self.chart, self)}
    self.song = love.audio.newSource(self.chartPath .. "/" .. self.chart.meta.audioFile, "stream")
    self.song:setLooping(false)

    mania.judgements = require("Modules.maniaJudgements")

    self:setUpObjects()

    Timer.after(0.15, function() self:startSong(2) end)
end

function mania:startSong(countdown)
    self.parent:startSong(countdown)
end

function mania:setUpObjects()
    local backgroundPath = self.chartPath .. self.chart.meta.backgroundFile
    self.background = sharedBackground(backgroundPath, gameplayBackgroundDim, 1)
    self.HUD = maniaHUD()

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
        SkinHandler:getParam("Health Bar Height"),
        1
    )
end

function mania:setUpChart(chart)
    local songPath = getDirectory(chart)
    local parsed = ChartParse.harmc(chart)
    self.totalNotes = #parsed.hitObjects

    local maniaChart = {
        meta = parsed.meta,
        hitObjects = {},
        scrollVelocities = {}
    }

    -- Setup video background if valid
    if parsed.meta.backgroundVideo and getFileExtension(parsed.meta.backgroundVideo) == "mp4" then
        self.videoBackground = video(
            songPath .. "/" .. parsed.meta.backgroundVideo,
            baseScreenRatio.x / 2,
            baseScreenRatio.y / 2,
            1, 1
        )
    end

    for i, BpmChange in ipairs(parsed.bpm) do

    end
    for i, SliderVelocity in ipairs(parsed.sliderVelocities) do
        
    end
    for _, obj in ipairs(parsed.hitObjects) do

        table.insert(maniaChart.hitObjects, {
            type = obj.type,
            startTime = obj.startTime,
            endTime = obj.endTime,
            lane = obj.lane
        })
    end

    return maniaChart
end

function mania:update(dt)
    
    self:updateObjects(dt)

    for _, playField in ipairs(self.playField) do
        playField:update(dt)
    end

    if self.song and MusicTime >= 0 and not self.song:isPlaying() then
        self.song:play()
        if self.videoBackground then self.videoBackground:play() end
    end

    if self.song and self.playField[1].finished then
       printToConsole("SONG END 1")
        if not self.song:isPlaying() then printToConsole("SONG END 2"); self:endSong() end
    end

    if thething then
        thething = false
        self:endSong()
    end
end

function mania:endSong()
   printToConsole("mania:endSong()")
    if self.song then self.song:stop();printToConsole("SONG END 3") end
    self.song = nil
    self.chart = nil
    self.playField = {}
    State.switch(States.menu.songSelect)
end

function mania:updateObjects(dt)
    if self.videoBackground then self.videoBackground:update(dt) end
    self.background:update(dt)
    self.judgementObject:update(dt)
    self.timeRemaingBar:update(dt)
    self.comboCount:update(dt)
    self.healthBar:update(dt)

    self.HUD:update(dt) -- we also gotta send values to the hud
    self.HUD:sendValues(ScoreHandler:getScore("printable"))

    if self.healthBar.health <= 0 then
        self:endSong()
    end
end

function mania:draw()
    self.background:draw()
    if self.videoBackground then self.videoBackground:draw() end

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
    self.HUD:draw()
    self.timeRemaingBar:draw()
    self.healthBar:draw()



    if self.debug then 
        love.graphics.print(MusicTime, 250, 400)
    end
end

return mania
