local maniaNote = Class:extend("maniaNote")

local fourkLanes = { "Left", "Down", "Up", "Right" }
local sevenkLanes = { "Left1", "Down", "Left2", "Center", "Right1", "Up", "Right2" }

function maniaNote:new(startTime, holdLength, lane, mode, initialSVTime, parent)
    self.size = maniaNoteSize
    self.startTime = startTime
    self.holdLength = holdLength
    self.lane = lane
    self.mode = mode
    self.parent = parent

    self.laneCount = tonumber(self.parent.parent.chart.meta.laneCount) or 4
    self.laneCountString = tostring(self.laneCount) .. "K"
    self.laneString = self:getLaneString()

    self.image = SkinHandler:getImage("Notes", self.laneCountString, self.laneString)

    self.x = maniaLanePositions[self.laneCountString][self.lane]
    self.y = self.startTime + (MusicTime or 0)

    self.initialSVTime = initialSVTime

    self.visible = true
    self.debug = false
end

function maniaNote:getLaneString()
    if self.laneCount == 4 then
        return fourkLanes[self.lane]
    elseif self.laneCount == 7 then
        return sevenkLanes[self.lane]
    else
        return nil
    end
end

function maniaNote:update(dt)
    self:updatePosition()
end

function maniaNote:updatePosition()
    self.y = self:getNotePosition(self.initialSVTime, true)
end

local function msToMulti(speed)
    return baseScreenRatio.y / speed
end

function maniaNote:getNotePosition(time, moveWithScroll)
    local scrollDir = Settings:getValue("Game", "Mania", "Scroll Direction")
    local scrollSpeed = Settings:getValue("Game", "Mania", "Scroll Speed")
    local multiplier = msToMulti(scrollSpeed)
    local currentTime = self.parent.parent.currentTime

    if scrollDir == "Up" then
        return self.parent.y - (currentTime - time) * multiplier
    else
        return self.parent.y + (currentTime - time) * multiplier
    end
end

function maniaNote:hit()
    print("Note hit at time: ", self.startTime)
end

function maniaNote:draw()
    if not self.visible then return end

    local screenW, screenH = baseScreenRatio.x, baseScreenRatio.y

    if self.x < -300 or self.x > screenW + 300 or self.y < -300 or self.y > screenH + 300 then
        return
    end

    local arrowBatch = SkinHandler:getBatch("Arrows")
    local noteBatch = SkinHandler:getBatch("Notes")

    if arrowBatch then
        local _, _, w, h = self.image:getViewport()
        arrowBatch:add(self.image, self.x, self.y, 0, self.size / w, self.size / h, w / 2, h / 2)
    elseif noteBatch then
        local _, _, w, h = self.image:getViewport()
        noteBatch:add(self.image, self.x, self.y, 0, self.size / w, self.size / h, w / 2, h / 2)
    else
        love.graphics.draw(self.image, self.x, self.y, 0, self.size / self.image:getWidth(), self.size / self.image:getHeight(), self.image:getWidth() / 2, self.image:getHeight() / 2)
    end

    if self.debug then
        love.graphics.setColor(1, 0, 0)
        love.graphics.setLineWidth(2)
        love.graphics.line(self.x - 200, self.y, self.x + 200, self.y)
        love.graphics.setColor(1, 1, 1)
        love.graphics.setLineWidth(1)
    end
end

return maniaNote
