local Visualizer = Class:extend()

function Visualizer:new()
    self.barCount = 150 -- how many bars (pretty obvious)
    self.smoothing = 0.03 -- lower is smoother, higher is rougher, until you reach 1
    self.samplesPerBar = 5  -- number of samples checked for each bar

    self.barHeights = {}
    self.averageBarLength = 0
    self.averageBarLengthCounter = 0
    self.color = {0,0,0,0}

    for i = 1, self.barCount do
        self.barHeights[i] = 0
    end
end

function Visualizer:update()
    local curSample = math.floor(Song:tell("samples"))
    local totalSamples = SongData:getSampleCount()
    local count = 0
    self.averageBarLengthCounter = 0

    for i = 1,self.barCount do
        local averageAmplitude = 0
        for j = 1,self.samplesPerBar do
            local sampleNumber = (curSample + i * self.samplesPerBar + j) % totalSamples
            local sampleLeft = SongData:getSample(sampleNumber * 2) or 0
            local sampleRight = SongData:getSample(sampleNumber * 2 + 1) or 0
            averageAmplitude = averageAmplitude + (math.abs(sampleLeft) + math.abs(sampleRight)) / 2
        end
        averageAmplitude = averageAmplitude / self.samplesPerBar
        self.barHeights[i] = (self.barHeights[i] + self.smoothing * (averageAmplitude - self.barHeights[i]))

        local barHeight = self.barHeights[i]
        count = plusEq(count)
        self.averageBarLengthCounter = self.averageBarLengthCounter + barHeight
    end

    self.visualizerAverageBarLength = self.averageBarLengthCounter/count

    if onBeat then Visualizer:bump() end
end

function Visualizer:getAverageBarLength()
    if not self.visualizerAverageBarLength then return 0 end
    return self.visualizerAverageBarLength
end

function Visualizer:bump()
    self.color = {1,1,1,0.3}

    Timer.tween(0.5, self.color, {[2] = 0, [3] = 0, [4] = 0})
end

function Visualizer:draw()
    love.graphics.push()
    love.graphics.setColor(self.color)

    local barWidth = Inits.GameWidth / self.barCount
    local barHeightMultiplier = Inits.GameHeight

    local centerY = Inits.GameHeight / 2

    love.graphics.push()
    love.graphics.translate(0, -centerY)
    for i = 0, self.barCount - 1 do
        local barHeight = self.barHeights[i + 1] * barHeightMultiplier
        love.graphics.rectangle("fill", i * barWidth, Inits.GameHeight - barHeight, barWidth - 1, barHeight)
    end
    love.graphics.pop()

        -- Draw the second visualizer (bars extending downwards)
        love.graphics.push()
        love.graphics.translate(0, centerY)
        for i = 0, self.barCount - 1 do
            local barHeight = self.barHeights[i + 1] * barHeightMultiplier
            love.graphics.rectangle("fill", i * barWidth, 0, barWidth - 1, barHeight)
        end
        love.graphics.pop()

    love.graphics.pop()
    love.graphics.setColor(1, 1, 1, 1)
end



return Visualizer


