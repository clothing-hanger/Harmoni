local mania = Class:extend("mania")

function mania:new(chart, parent)
    self.parent = parent
    self.videoBackground = false
    self.chartPath = getDirectory(chart)
    print("with file", chart, "without file", self.chartPath)
    self.chart = mania:setUpChart(chart)
    self.laneSpacing = 30
    self.laneYOffset = 30
    self.playField = {maniaPlayField(self.chart, self)}
    self.song = love.audio.newSource(self.chartPath .. "/" .. self.chart.meta.audioFile,"stream")

    mania.judgements = require("Modules.maniaJudgements")

    self:setUpObjects()

    local songCountDown = 2

    Timer.after(0.15, function() self:startSong(songCountDown) end)
end

function mania:startSong(countdown)
    self.parent:startSong(countdown)
end

function mania:setUpObjects()

    local backgroundPath = self.chartPath .. self.chart.meta.backgroundFile
    self.background = sharedBackground(backgroundPath, gameplayBackgroundDim, 1)
    local songLengthInSeconds = self.song:getDuration("seconds")

    self.timeRemaingBar = UITimeRemaing(0, songLengthInSeconds, 0, baseScreenRatio.y-50, baseScreenRatio.x, self,5,-5,5,30)

    self.judgementObject = maniaJudgement(Skin.Params["Judgement X Offset"], Skin.Params["Judgement Y Offset"], Skin.Params["Judgement Size"], self.judgements, self)

    self.comboCount = maniaComboCount(Skin.Params["Combo X Offset"], Skin.Params["Combo Y Offset"])

    self.healthBar = maniaHealthBar(Skin.Params["Health Bar X Offset"], Skin.Params["Health Bar Y Offset"], Skin.Params["Health Bar Width"], Skin.Params["Health Bar Height"], 1)
end

function mania:setUpChart(chart)
    local songPath = getDirectory(chart)
    local chart = ChartParse.harmc(chart)
    local maniaChart = {}
    maniaChart.meta = chart.meta
    maniaChart.hitObjects = {}
    maniaChart.scrollVelocities = {}
    if chart.meta.backgroundVideo then
        if getFileExtension(chart.meta.backgroundVideo) == "mp4" then
            self.videoBackground = video(songPath .. "/" .. chart.meta.backgroundVideo, baseScreenRatio.x/2, baseScreenRatio.y/2, 1, 1)
        end
    end

    for i, BpmChange in ipairs(chart.bpm) do
    
       -- print(i, BpmChange.startTime, BpmChange.bpm)
    end
    for i, SliderVeloticy in ipairs(chart.sliderVelocities) do
       -- print(i, SliderVeloticy.startTime, SliderVeloticy.multiplier)
       --[[
        table.insert(maniaChart.scrollVelocities, {
                startTime = SliderVeloticy.startTime,             GUGLIOO PLEASSEEE
                multiplier = SliderVeloticy.multiplier
        })
        --]]
    end
    for i, HitObject in ipairs(chart.hitObjects) do
       -- print(i, HitObject.type, HitObject.startTime, HitObject.length)
        table.insert(maniaChart.hitObjects, {
            type = HitObject.type,
            startTime = HitObject.startTime,
            length = HitObject.length,
            lane = HitObject.lane
        })
    end
    return maniaChart
end

--[[
function mania:input()
    for p,PlayField in ipairs(self.playField) do
        for l,Lane in ipairs(PlayField.lanes) do
            for h,HitObject in ipairs(Lane.hitObjects) do
                if Input:pressed(allInputs[l]) then
                    for j,Judgement in ipairs(self.judgements) do
                        print(Judgement.timing)
                        if math.abs(HitObject.startTime - MusicTime) > Judgement.timing then
                           -- HitObject:hit()
                            --table.remove(Lane.hitObjects, h)
                            break
                        end
                    end
                end
            end
        end
    end
end
--]]


function mania:update(dt)
    self:updateObjects(dt)
    for i,PlayFeild in ipairs(self.playField) do
        PlayFeild:update(dt)
    end
    if self.song then if MusicTime >=0 and not self.song:isPlaying() then self.song:play(); if self.videoBackground then self.videoBackground:play() end end end

    if self.song then if self.playField[1].empty or debugShitIdk then self:endSong() end end   -- i could not tell you why the if self.song needs to be there but without it the game dies
                                                                                                         -- fucking tf2 coconut




    if thething then
        thething = false
        self:endSong()
    end
end

function mania:endSong()
    self.song:stop()
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
    if self.healthBar.health <= 0 then self:endSong() end
end

function mania:draw()
    self.background:draw()
    if self.videoBackground then self.videoBackground:draw() end

    for i,PlayFeild in ipairs(self.playField) do
        PlayFeild:draw()
    end
    self.judgementObject:draw()
    --TEMP
    love.graphics.setFont(songButtonFontLarge)


    self.comboCount:draw()
    self.timeRemaingBar:draw()

    self.healthBar:draw()
end

return mania