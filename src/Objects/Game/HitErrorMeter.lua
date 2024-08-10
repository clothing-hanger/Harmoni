local HitErrorMeter = Class:extend()

function HitErrorMeter:new()
    self.x, self.y = Skin.Params["Hit Error Meter X"], Skin.Params["Hit Error Meter Y"]
    self.width, self.height = Skin.Params["Hit Error Meter Width"], Skin.Params["Hit Error Meter Height"]
    self.solid = Skin.Params["Hit Error Meter Solid"]
    self.fadeTime = Skin.Params["Hit Error Meter Fade"]
    self.hits = {}
end

function HitErrorMeter:update(dt)
    local i = 1
    while i <= #self.hits do
        local hit = self.hits[i]
        if hit then
            hit[5] = hit[5] - 1000 * love.timer.getDelta()
            if hit[5] <= 0 then
                table.remove(self.hits, i)
            else
                i = i + 1
            end
        else
            i = i + 1
        end
    end
end


function HitErrorMeter:addHit(noteTime)
    local color = {1, 1, 1, 1}
    local hitTable = {}
    table.insert(hitTable, noteTime)
    for _, Judgement in ipairs(JudgementNames) do
        if math.abs(noteTime) <= Judgements[Judgement].Timing then
            color = Judgements[Judgement].Color
            table.insert(hitTable, color[1])
            table.insert(hitTable, color[2])
            table.insert(hitTable, color[3])
            break
        end
    end
    if #hitTable < 2 then -- colors were not added
        color = Judgements.Miss.Color
        table.insert(hitTable, color[1])
        table.insert(hitTable, color[2])
        table.insert(hitTable, color[3])
    end
    table.insert(hitTable, self.fadeTime)
    table.insert(self.hits, hitTable)
end

--hitTable = {noteTime, r, g, b, fadeTime}      the format of a a hit in the hitTable

function HitErrorMeter:draw()
    love.graphics.translate(Inits.GameWidth/2, Inits.GameHeight/2)
    love.graphics.setColor(1,1,1)
    for i = 1,#self.hits do
        love.graphics.setColor(self.hits[i][2], self.hits[i][3],self.hits[i][4], self.hits[i][5]/self.fadeTime)
        love.graphics.rectangle("fill", self.hits[i][1], self.y, 5, self.height)
    end

    love.graphics.rectangle("fill", -1, 0, 2, 10)

    love.graphics.translate(-Inits.GameWidth/2, -Inits.GameHeight/2)
end

function HitErrorMeter:release()

end

return HitErrorMeter