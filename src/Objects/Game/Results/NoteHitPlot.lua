local NoteHitPlot = Class:extend()

function NoteHitPlot:new()
    self.x = 35
    self.y = 500
    self.width = 1000
    self.height = 200 
    self.hits = noteHits
end

function NoteHitPlot:update()
end

function NoteHitPlot:draw()
    love.graphics.setColor(0, 0, 0, 0.8)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.rectangle("fill", self.x, self.y, self.width, -self.height)

    local maxTiming = Judgements["Miss"].Timing

    for Judgement = 1, #JudgementNames do
        local judgement = Judgements[JudgementNames[Judgement]]
        local scaledTiming = (judgement.Timing / maxTiming) * self.height / 2

        love.graphics.setColor(judgement.Color)
        love.graphics.line(self.x, self.y + scaledTiming, self.x + self.width, self.y + scaledTiming)
        love.graphics.line(self.x, self.y - scaledTiming, self.x + self.width, self.y - scaledTiming)
    end

    for _, Note in ipairs(self.hits) do
        if not Note.wasMiss then
            for Judgement = 1, #JudgementNames do
                local judgement = Judgements[JudgementNames[Judgement]]
                if math.abs(Note.noteTime) < judgement.Timing then
                    love.graphics.setColor(judgement.Color)
                    break
                end
            end
            local scaledNoteTime = (Note.noteTime / maxTiming) * self.height / 2
            local songLength = metaData.songLengthToLastNote * 1000
            local x = ((Note.musicTime / songLength) * self.width) + self.x
            local y = self.y + scaledNoteTime
            love.graphics.circle("fill", x, y, 2)
        else -- loser lmao
            local songLength = metaData.songLengthToLastNote * 1000
            local x = ((Note.musicTime / songLength) * self.width) + self.x
            local y = self.y
            love.graphics.setColor(Judgements["Miss"].Color)
            love.graphics.line(x,y+self.height,x,self.y-self.height)
            love.graphics.circle("fill", x, y, 2)
        end
    end
end

return NoteHitPlot
