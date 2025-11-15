local sliderField = Class:extend("sliderField")

local positions = {
    {x = 200, y = baseScreenRatio.y/2},
    {x = baseScreenRatio.x - 200, y = baseScreenRatio.y/2}
}

local function smoothstep(t)
    return t * t * (3 - 2 * t)
end

function sliderField:new(chart, parent)
    self.parent = parent
    self.chart = chart

    self.receptors = {} -- only 2
    self.notes = {}

    self.noteStartTime = nil -- only one note is ever on screen
    self.goingLeft = false
    self.currentIndex = 1
    self.curNoteX = nil
    self.startX, self.targetX = nil, nil
    self.knockbackX, self.actualTravelTime = nil, nil
    self.knockback = nil

    self.finished = false

    self.endNoteTime = 0
    self.totalNotes = 0

    for i = 1, 2 do
        self.receptors[i] = sliderReceptor(i, self, positions[i].x, positions[i].y)
    end
end

function sliderField:update(dt)
    if not self.noteStartTime and self.currentIndex <= #self.chart.hitObjects then
        local notedata = self.chart.hitObjects[self.currentIndex]
        self.knockback = notedata.knockback

        if self.goingLeft then
            self.startX = self.receptors[1].x
            self.targetX = self.receptors[2].x
        else
            self.startX = self.receptors[2].x
            self.targetX = self.receptors[1].x
        end

        if self.knockback then
            local otherX = (self.startX == self.receptors[1].x) and self.receptors[2].x or self.receptors[1].x
            self.knockbackX = self.startX + (otherX - self.startX) * 0.3333
            self.targetX = self.startX
        end

        if self.currentIndex == 1 then
            self.noteStartTime = notedata.time - 1000
        else
            self.noteStartTime = self.chart.hitObjects[self.currentIndex - 1].time
        end

        self.actualTravelTime = notedata.time - self.noteStartTime
        if self.actualTravelTime < 1 then self.actualTravelTime = 1 end
    end

    if self.noteStartTime then
        if not self.chart.hitObjects[self.currentIndex] then
            return
        end
        local cur = self.chart.hitObjects[self.currentIndex]
        if not cur.time then self.currentIndex = self.currentIndex + 1 return end
        local noteTime = cur.time
        local timeRemaining = noteTime - MusicTime

        local t = 1 - (timeRemaining / self.actualTravelTime)
        t = math.max(0, math.min(1, t))

        if self.knockback then
            if t < 0.25 then
                local phaseT = t / 0.25
                phaseT = smoothstep(phaseT)
                self.curNoteX = self.startX + (self.knockbackX - self.startX) * phaseT
            else
                local phaseT = (t - 0.25) / 0.75
                self.curNoteX = self.knockbackX + (self.startX - self.knockbackX) * phaseT
            end
        else
            self.curNoteX = self.startX + (self.targetX - self.startX) * t
        end

        if MusicTime >= noteTime then
            self.currentIndex = self.currentIndex + 1
            if not self.knockback then
                self.goingLeft = not self.goingLeft
            end
            self.noteStartTime = nil
        end
    end
end

function sliderField:draw()
    for _, receptor in ipairs(self.receptors) do
        print("Drawing slider receptor at position:", receptor.x, receptor.y)
        receptor:draw()
    end

    if self.curNoteX then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.rectangle("fill", self.curNoteX - sliderNoteSize/2, self.receptors[1].y - sliderNoteSize/2, sliderNoteSize, sliderNoteSize)
    end
end

return sliderField