local HUDTopLeft = Class:extend()
local scoreTween
local accuracyTween

function HUDTopLeft:new()
    self.x, self.y = 700, 250
    self.printableScore = {score}
    self.printableAccuracy = {0}
end

function HUDTopLeft:update(dt)
    if scoreTween then Timer.cancel(scoreTween) end
    scoreTween = Timer.tween(0.15, self.printableScore, {score}, "out-quad")
    
    if accuracyTween then Timer.cancel(accuracyTween) end
    accuracyTween = Timer.tween(0.15, self.printableAccuracy, {accuracy}, "out-quad")
end

function HUDTopLeft:draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.setFont(Skin.Fonts["HUD Large"])
    love.graphics.printf(math.ceil(self.printableScore[1]) .. "\n" .. math.ceil(accuracy), 0, 0, Inits.GameWidth, "left")
    love.graphics.setFont(defaultFont)
end

function HUDTopLeft:release()

end

return HUDTopLeft