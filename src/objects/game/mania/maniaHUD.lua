local maniaHUD = Class:extend("maniaHUD")

function maniaHUD:new(parent)
    self.parent = parent
    self.debug = false
    self.fontLarge = SkinHandler:getFontLegacy("HUD Large")
    self.fontSmall = SkinHandler:getFontLegacy("HUD Small")
    self.fontExtraSmall = SkinHandler:getFontLegacy("HUD Extra Small")

    self.font = SkinHandler:getFont("HUD", 160)
    self.debugFont = SkinHandler:getFont("HUD", 70)
    self.grade = "N/A"
end

function maniaHUD:update(dt)
    self.grade = maniaGrades.getGrade(self.scores.trueAccuracy)
end

function maniaHUD:sendValues()  -- will be called every frame (obviously) to pass shit to the hud 

end

function maniaHUD:sendScoreHandlerScores(scoreHandlerScores)
    self.scores = scoreHandlerScores
end

function maniaHUD:draw()

    if self.debug then self:debugDraw() end
        love.graphics.setFont(self.font)

    local score = string.format("%.0f", self.scores.printableScore)
    local accuracy = string.format("%.2f", self.scores.printableAccuracy) .. "%"
    local grade = self.grade 
    local prOverDr = string.format("%.2f", self.scores.printablePerformanceRating) .. "/" .. string.format("%.2f", self.scores.difficultyRating)   -- this was a bad idea what was i thinking
    local pr = string.format("%.2f", self.scores.truePerformanceRating)  -- use true for now because printable isnt implemented yet and i am very tired and lazy right now

    local IPSoverNPS = string.format("%02d",#self.parent.inputsPerSecond) .. "/" .. string.format("%02d",#self.parent.notesPerSecond)

    if self.parent.mods["BP"] then IPSoverNPS = string.format("%02d",#self.parent.notesPerSecond) .. "/" .. string.format("%02d",#self.parent.notesPerSecond) end -- shitty hack but i dont care lol!

    love.graphics.printf(score .. "\n" .. IPSoverNPS, 10, 10, baseScreenRatio.x, "left")

    love.graphics.printf(pr .. "\n" .. accuracy .. "\n" .. grade, baseScreenRatio.x-1000, 10, 990, "right")


   -- love.graphics.printf
end

function maniaHUD:debugDraw()
    love.graphics.setFont(self.debugFont)
    love.graphics.setColor(1,1,0)
    love.graphics.print("DEBUG SHIT" .. "\n"
                    .. "SCORE: " .. self.scores.trueScore .. "\n"
                    .. "ACCURACY: " .. self.scores.trueAccuracy .. "\n"
                    .. "PERFORMANCE RATING: " .. self.scores.truePerformanceRating .. "\n"
                    .. "DIFFICULTY RATING: " .. self.scores.difficultyRating,
                    100,100
    )
        love.graphics.setColor(1,1,1)

end

return maniaHUD