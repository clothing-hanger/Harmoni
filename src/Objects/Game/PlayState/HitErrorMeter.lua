---@class HitErrorMeter
local HitErrorMeter = Class:extend()
local tween

function HitErrorMeter:new()
    self.x, self.y = Skin.Params["Hit Error Meter X"], Skin.Params["Hit Error Meter Y"]
    self.width, self.height = Skin.Params["Hit Error Meter Width"], Skin.Params["Hit Error Meter Height"]
    self.solid = Skin.Params["Hit Error Meter Solid"]
    self.fadeTime = Skin.Params["Hit Error Meter Fade"]
    self.hits = {}
    self.pointerX = 0
    self.printablePointerX = {self.pointerX}
    self.currentTime = 0
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
    if tween then Timer.cancel(tween) end
    tween = Timer.tween(0.2, self.printablePointerX, {self.pointerX}, "out-expo")
end

---@param noteTime number The ms of the note hit
---Adds a marker to the meter with a given notetime
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
    self.pointerX = (noteTime / 100) * (self.width / 2)
    self.currentTime = noteTime
end

--hitTable = {noteTime, r, g, b, fadeTime}      the format of a a hit in the hitTable

function HitErrorMeter:draw()
    love.graphics.translate(Inits.GameWidth/2, Inits.GameHeight/2)
    love.graphics.setColor(1, 1, 1)

    if self.solid then
        for i = #JudgementNames, 1, -1 do
            local Judgement = JudgementNames[i]
            local timing = Judgements[Judgement].Timing
            local color = Judgements[Judgement].Color
            local scaledWidth = (timing / 100) * (self.width / 2)
            love.graphics.setColor(color[1], color[2], color[3], 1)
            love.graphics.rectangle("fill", -scaledWidth+4, self.y, scaledWidth * 2, self.height)  -- gotta add 4 to the X to account for width of a hit thingy
        end
    end
    for i = 1, #self.hits do
        local scaledX = (self.hits[i][1] / 100) * (self.width / 2)
        love.graphics.setColor(self.hits[i][2], self.hits[i][3], self.hits[i][4], self.hits[i][5] / self.fadeTime)
        if self.solid then
            love.graphics.setColor(0,0,0,self.hits[i][5] / self.fadeTime)
        end
        love.graphics.rectangle("fill", scaledX, self.y, 5, self.height)
    end
    love.graphics.setColor(1,1,1)

    love.graphics.setFont(defaultFont)
    love.graphics.printf(string.format("%.0f", self.currentTime), (1 + self.printablePointerX[1])-25, self.y-self.height+2, 50, "center")

    love.graphics.translate(-Inits.GameWidth/2, -Inits.GameHeight/2)
end

function HitErrorMeter:release()

end

return HitErrorMeter