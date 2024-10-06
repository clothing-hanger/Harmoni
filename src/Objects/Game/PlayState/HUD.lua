---@class HUD
local HUD = Class:extend()
local scoreTween
local accuracyTween

function HUD:new()
    self.printableScore = {score}
    self.printableAccuracy = {accuracy}
    self.printablePerformance = {performance}
end

function HUD:update(dt)
    if scoreTween then Timer.cancel(scoreTween) end
    scoreTween = Timer.tween(0.15, self.printableScore, {score}, "out-quad")
    
    if accuracyTween then Timer.cancel(accuracyTween) end
    accuracyTween = Timer.tween(0.15, self.printableAccuracy, {accuracy}, "out-quad")

    if performanceTween then Timer.cancel(performanceTween) end
    performanceTween = Timer.tween(0.15, self.printablePerformance, {performance}, "out-quad")

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
    love.graphics.setFont(Skin.Fonts["HUD Large"])
    

    local leftText = math.ceil(self.printableScore[1]) .. "\n" .. string.format("%.2f", self.printableAccuracy[1]) .. "%"
    local leftTextWidth = Skin.Fonts["HUD Large"]:getWidth(leftText)
    local leftTextHeight = Skin.Fonts["HUD Large"]:getHeight() * 2


    love.graphics.setColor(0, 0, 0, 0.8)
    love.graphics.rectangle("fill", 0, 0, leftTextWidth+15, leftTextHeight)
    gradient(0, leftTextHeight, leftTextWidth+15, 15, {0,0,0,0.8}, {0,0,0,0}, "vertical")

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(leftText, 0, 0, Inits.GameWidth, "left")

    local rightText = string.format("%.2f", self.printablePerformance[1]) .. " | " .. grade .. "\n" .. #NPSData.NPS .. "/" .. #NPSData.HPS
    local rightTextWidth = Skin.Fonts["HUD Large"]:getWidth(rightText)
    local rightTextHeight = Skin.Fonts["HUD Large"]:getHeight() * 2

    local rightAlignX = Inits.GameWidth - rightTextWidth

    love.graphics.setColor(0, 0, 0, 0.8)
    love.graphics.rectangle("fill", rightAlignX-15, 0, rightTextWidth+15, rightTextHeight)
    gradient(rightAlignX-15, rightTextHeight, rightTextWidth+15, 15, {0,0,0,0.8}, {0,0,0,0}, "vertical")

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(rightText, 0, 0, Inits.GameWidth, "right")

    love.graphics.setFont(defaultFont)
end

function HUD:release()

end

return HUD