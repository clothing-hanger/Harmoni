local Note = Class:extend()

local BaseNoteImages = {
    NoteLeftImage,
    NoteDownImage,
    NoteUpImage,
    NoteRightImage
}

-- If nil, will just default to a rectangle
local HoldNoteImages = {
    HoldNoteLeftImage,
    HoldNoteDownImage,
    HoldNoteUpImage,
    HoldNoteRightImage
}

-- if nil, will not draw an end hold
local HoldNoteEndImages = {
    HoldNoteEndLeftImage,
    HoldNoteEndDownImage,
    HoldNoteEndUpImage,
    HoldNoteEndRightImage
}

Note.time = 0
Note.lane = 0
Note.ableToBeHit = false
Note.tooLate = false
Note.wasGoodHit = false

Note.offsetX = 0
Note.offsetY = 0

Note.x = 0
Note.y = 0

Note.image = nil
Note.children = {}
Note.moveWithScroll = true

Note.alpha = 1

Note.visible = true

function Note:new(time, lane, endTime)
    -- x is Inits.GameWidth/2-(LaneWidth*(3-i))
    self.x = Inits.GameWidth/2-(LaneWidth*(3-lane))
    self.y = -2000

    self.time = time
    self.lane = lane
    self.endTime = endTime

    self.image = BaseNoteImages[lane]
    self.children = {}
    Note.alpha = 1
    self.tooLate = false
    self.ableToBeHit = false
    self.wasGoodHit = false
    self.visible = true

    --125/spr:getWidth()
    
    if self.endTime and self.endTime > self.time then
        local holdObj = {}
        holdObj.image = HoldNoteImages[lane]
        holdObj.endTime = endTime
        holdObj.height = 125
        holdObj.scaleY = 1

        table.insert(self.children, holdObj)

        if HoldNoteEndImages[lane] then
            local endObj = {}
            endObj.image = HoldNoteEndImages[lane]
            endObj.endTime = endTime
            endObj.height = 125

            if not downScroll then
                endObj.scaleY = -1
            end

            table.insert(self.children, endObj)
        end
    end

    self.x = self.x + self.offsetX

    if #self.children > 0 then
        for i, v in ipairs(self.children) do
            v.x = self.x + self.offsetX
            v.y = self.y + self.offsetY
        end
    end

    return self
end

function Note:update(dt)
    self.canBeHit = self.time > MusicTime - SafeZoneOffset and self.time < MusicTime + SafeZoneOffset 
    
    if self.time < MusicTime - SafeZoneOffset and not self.tooLate then
        self.tooLate = true
    end

    if self.tooLate then self.alpha = 0.6 end
end

function Note:draw()
    if self.y > Inits.GameHeight or self.y < -2000 then return end
    if not self.visible then return end
    
    love.graphics.setColor(1, 1, 1, self.alpha*0.6)
    if self.children[1] then
        if self.children[1].image then
            love.graphics.draw(self.children[1].image, self.x, self.children[1].y, 0, 125/self.children[1].image:getWidth(), 125/self.children[1].image:getHeight())
        else
            love.graphics.rectangle("fill", self.x, self.y+(125/2), 125, ((self.endY - self.y)))
        end
    end
    love.graphics.setColor(1, 1, 1, self.alpha)
    love.graphics.draw(self.image, self.x, self.y, 0, 125/self.image:getWidth(), 125/self.image:getHeight())
end

return Note