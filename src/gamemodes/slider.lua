local slider = Class:extend("slider")
local videoFade = 0
local played = false

function slider:new(chart, parent, fullChart)
        error("dont play this fucking mode")

    videoFade = 0
    played = false
    self.parent = parent
    self.videoBackground = nil
    self.chartPath = getDirectory(chart)

    self.debug = false
    self.songStarted = false

    self.chart = self:setUpChart(chart, fullChart)
    self.scoreHandler = ScoreHandler

    --score shit 
    ScoreHandler:resetScore()

    self.scoresPerJudgements = ScoreHandler:getScorePerJudgment(self.totalNotes)

    self.laneSpacing = 30
    self.laneYOffset = 30
    self.song = love.audio.newSource(self.chartPath .. "/" .. self.chart.meta.audioFile, "static")
    self.song:setLooping(false)
    self.playField = {sliderField(self.chart, self)}

    slider.judgements = require("modules.gamemodes.mania.maniaJudgements")

    self:setUpObjects()
end


function slider:countdownhandler()

end

function slider:startSong(countdown)
    self.songStarted = true
    self.parent:startSong(countdown)
end

function slider:setUpObjects()
    local backgroundPath = self.chartPath .. self.chart.meta.backgroundFile
    self.background = sharedBackground(backgroundPath, gameplayBackgroundDim, 1)
    self.HUD = maniaHUD()

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

function slider:setUpChart(chartpath, chart)
    local songPath = getDirectory(chartpath)
    local parsed = chart
    self.totalNotes = #parsed.hitObjects

    local sliderChart = {
        meta = parsed.meta,
        hitObjects = {},
        scrollVelocities = {}
    }

    -- Setup video background if valid
    if parsed.meta.backgroundVideo and getFileExtension(parsed.meta.backgroundVideo) == "mp4" then
        self.videoBackground = video(
            songPath .. "/" .. parsed.meta.backgroundVideo,
            baseScreenRatio.x / 2,
            baseScreenRatio.y / 2
        )
        self.videoBackground.scaleX = baseScreenRatio.x / self.videoBackground.image:getWidth()
        self.videoBackground.scaleY = baseScreenRatio.y / self.videoBackground.image:getHeight()
    end

    for _, BpmChange in ipairs(parsed.bpm) do

    end

    for _, obj in ipairs(parsed.hitObjects) do
        table.insert(sliderChart.hitObjects, {
            type = obj.type,
            time = obj.time,
            knockback = obj.knockback
        })
    end

    return sliderChart
end

function slider:update(dt)
    self:updateObjects(dt)

    for _, playField in ipairs(self.playField) do
        playField:update(dt)
    end

    if self.song and self.playField[1].finished then
        print("SONG END 1")
        if not self.song:isPlaying() then print("SONG END 2"); self:endSong() end
    end

    if self.song and MusicTime >= 0 and not self.song:isPlaying() and not played then
        self.song:play()
        if self.videoBackground then self.videoBackground:play() end
        played = true
    else
        videoFade = videoFade + dt * 1
    end

    if thething then
        thething = false
        self:endSong()
    end
end

function slider:endSong()
    if self.song then self.song:stop();print("SONG END 3") end
    self.song = nil
    self.chart = nil
    self.playField = {}
    State.switch(States.menu.songSelect)
end

function slider:updateObjects(dt)
    if self.videoBackground then self.videoBackground:update(dt) end
    self.background:update(dt)
    self.countdownBar:update(dt)
    if self.countdownBar.complete and not self.songStarted then self:startSong(1) end
    self.judgementObject:update(dt)
    self.timeRemaingBar:update(dt, self.song:tell()/self.song:getDuration())
    self.comboCount:update(dt)
    self.healthBar:update(dt)

    self.HUD:update(dt) -- we also gotta send values to the hud
    self.HUD:sendValues(ScoreHandler:getScore("printable"))

    if self.healthBar.health <= 0 then
        --self:endSong()
    end
end

function slider:draw()
    self.background:draw()
    if self.videoBackground then 
        self.videoBackground.alpha = math.min(videoFade, 1)
        self.videoBackground:draw() 
    end

    for _, playField in ipairs(self.playField) do
        playField:draw()
    end

    self.judgementObject:draw()
    ---@diagnostic disable-next-line: undefined-global
    if judgementBatch then love.graphics.draw(judgementBatch) end

    self.comboCount:draw()
    self.HUD:draw()
    self.timeRemaingBar:draw()
    self.healthBar:draw()

    self.countdownBar:draw()

    if self.debug then
        love.graphics.print(MusicTime, 250, 400)
    end
end

return slider
