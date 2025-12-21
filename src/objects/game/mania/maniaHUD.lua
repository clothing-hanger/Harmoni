local maniaHUD = Class:extend("maniaHUD")

function maniaHUD:new()
    self.score = 0
    self.accuracy = 0

    self.debug = true
    self.fontLarge = SkinHandler:getFontLegacy("HUD Large")
    self.fontSmall = SkinHandler:getFontLegacy("HUD Small")
    self.fontExtraSmall = SkinHandler:getFontLegacy("HUD Extra Small")
end

function maniaHUD:update(dt)

end

function maniaHUD:sendValues(score,accuracy)  -- will be called every frame (obviously) to pass shit to the hud 
   -- self.score = (score)                               -- why did i ever do it this way? that was dumb lol
   -- self.accuracy = accuracy
end

function maniaHUD:sendScoreHandlerScores(scoreHandlerScores)
    self.scores = scoreHandlerScores
end

function maniaHUD:draw()
    if self.debug then self:debugDraw() end

    love.graphics.setFont(SkinHandler:getFontLegacy("HUD Large"))
    love.graphics.printf(self.score, 10, 10, baseScreenRatio.x, "left")
   -- love.graphics.printf
end

function maniaHUD:debugDraw()
    love.graphics.print("DEBUG SHIT" .. "\n"
                    .. "SCORE: " .. self.scores.trueScore .. "\n"
                    .. "ACCURACY: " .. self.scores.trueAccuracy .. "\n"
                    .. "PERFORMANCE RATING: " .. self.scores.truePerformanceRating .. "\n"
                    .. "DIFFICULTY RATING: " .. self.scores.difficultyRating,
                    100,100
    )
end

return maniaHUD