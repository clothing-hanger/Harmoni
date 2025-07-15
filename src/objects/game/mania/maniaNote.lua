local maniaNote = Class:extend("maniaNote")

local fourkLanes = {"Left", "Down", "Up", "Right"}
local sevenkLanes = {"Left1", "Down", "Left2", "Center", "Right1", "Up", "Right2"}

function maniaNote:new(startTime, holdLength, lane, mode, initialSVTime, parent)
    self.size = maniaNoteSize
    self.startTime = startTime
    self.holdLength = holdLength
    self.lane = lane
    self.mode = mode

    self.parent = parent

    self.laneCount = self.parent.parent.chart.meta.laneCount  -- horrid but if it works it works
    self.laneCountString = tostring(self.laneCount .. "K")
    self.laneString = self:getLaneString()

    self.image = SkinHandler:getImage("Notes", self.laneCountString, self.laneString)

    self.x, self.y = maniaLanePositions[self.laneCountString][self.lane], self.startTime + (MusicTime or 0)
    self.initialSVTime = initialSVTime

    self.visible = true

    self.debug = false
end

function maniaNote:getLaneString()       --its crazy how bad this already is
    local string

    if tonumber(self.laneCount) == 4 then
        string = fourkLanes[self.lane]
    elseif tonumber(self.laneCount) == 7 then
        string = sevenkLanes[self.lane]
    end

    return string
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

function maniaNote:getNotePosition(time, moveWithScroll) -- moveWithScroll is unused until hold notes are implemented
    if Settings:getValue("Game", "Mania", "Scroll Direction") == "Up" then
        return self.parent.y - (self.parent.parent.currentTime - time) * msToMulti(Settings:getValue("Game", "Mania", "Scroll Speed"))
    else
        return self.parent.y + (self.parent.parent.currentTime - time) * msToMulti(Settings:getValue("Game", "Mania", "Scroll Speed"))
    end
end

function maniaNote:hit()
    print("hit i guess idk")
end

function maniaNote:draw()
    -- check if on screen
    if not self.visible then return end

    -- check if in view
    local w, h = baseScreenRatio.x, baseScreenRatio.y
    if self.x < -300 or self.x > w+300 or self.y < -300 or
         self.y > h+300 then return end

    local arrowBatch = SkinHandler:getBatch("Arrows")
    local noteBatch = SkinHandler:getBatch("Notes")

    if arrowBatch then
        local _, _, w, h = self.image:getViewport()
        arrowBatch:add(self.image, self.x, self.y, nil, self.size/w, self.size/h, w/2, h/2)
    elseif noteBatch then
        local _, _, w, h = self.image:getViewport()
        noteBatch:add(self.image, self.x, self.y, nil, self.size/w, self.size/h, w/2, h/2)
    else
        love.graphics.draw(self.image, self.x, self.y, nil, self.size/self.image:getWidth(), self.size/self.image:getHeight(), self.image:getWidth()/2, self.image:getHeight()/2)
    end

    if self.debug then
        love.graphics.setColor(1,0,0)
        love.graphics.setLineWidth(10)
        love.graphics.line(self.x-200, self.y, self.x+200, self.y)
        love.graphics.setColor(1,1,1)
        love.graphics.setLineWidth(1)
    end
    
end

return maniaNote