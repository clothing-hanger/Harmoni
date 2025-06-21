local maniaNote = Class:extend("maniaNote")

local fourkLanes = {"Left", "Down", "Up", "Right"}
local sevenkLanes = {"Left1", "Down", "Left2", "Center", "Right1", "Up", "Right2"}

function maniaNote:new(startTime, holdLength, lane, parent)
    self.size = maniaNoteSize
    self.startTime = startTime
    self.holdLength = holdLength
    self.lane = lane

    self.parent = parent

    self.laneCount = self.parent.parent.chart.meta.laneCount  -- horrid but if it works it works
    self.laneCountString = tostring(self.laneCount .. "K")
    self.laneString = self:getLaneString()

    self.image = Skin.Notes[self.laneCountString][self.laneString]

    self.x, self.y = maniaLanePositions[self.lane], self.startTime + (MusicTime or 0)

    self.visible = true



    self.debug = true
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
    self.y = self:getNotePosition(self.startTime, true)
end

function maniaNote:getNotePosition(time, moveWithScroll) -- moveWithScroll is unused until hold notes are implemented
    if not DOWNSCROLL_ENABLED then
        return self.parent.y - (MusicTime - time) * maniaScrollSpeed
    else
        return self.parent.y + (MusicTime - time) * maniaScrollSpeed
    end
end

function maniaNote:hit()
    print("hit i guess idk")
end

function maniaNote:draw()
    if not self.visible then return end
    
    love.graphics.draw(self.image, self.x, self.y, nil, self.size/self.image:getWidth(), self.size/self.image:getHeight(), self.image:getWidth()/2, self.image:getHeight()/2)

    if self.debug then 
        love.graphics.setColor(1,0,0)
        love.graphics.setLineWidth(10)
        love.graphics.line(self.x-200, self.y, self.x+200, self.y)
        love.graphics.setColor(1,1,1)
        love.graphics.setLineWidth(1)
    end
    
end

return maniaNote