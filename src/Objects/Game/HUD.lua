local HUD = Class:extend()
local scoreTween
local accuracyTween

function HUD:new()
    self.printableScore = {score}
    self.printableAccuracy = {0}
end

function HUD:update(dt)
    if scoreTween then Timer.cancel(scoreTween) end
    scoreTween = Timer.tween(0.15, self.printableScore, {score}, "out-quad")
    
    if accuracyTween then Timer.cancel(accuracyTween) end
    accuracyTween = Timer.tween(0.15, self.printableAccuracy, {accuracy}, "out-quad")

    for i, Table in pairs(NPSData) do
        for q = 1,#Table do
            if Table[q] then
                Table[q] = Table[q] - 1000 * love.timer.getDelta()
                if Table[q] <= 0 then table.remove(Table, q) end
            end
        end
    end

    for i, Grade in pairs(Grades) do
        if accuracy >= Grade.accuracy then
            grade = Grade.grade
            break
        end
    end
end

function HUD:draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.setFont(Skin.Fonts["HUD Large"])
    love.graphics.printf(math.ceil(self.printableScore[1]) .. "\n" .. string.format("%.2f", accuracy) .. "%", 0, 0, Inits.GameWidth, "left")
    love.graphics.printf(grade .. "\n" .. #NPSData.NPS .. "/" .. #NPSData.HPS, 0, 0, Inits.GameWidth, "right")
    love.graphics.setFont(defaultFont)
end

function HUD:release()

end

return HUD