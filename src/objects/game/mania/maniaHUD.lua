local maniaHUD = Class:extend("maniaHUD")

function maniaHUD:new()
    self.score = 0

    self.debug = true
    self.fontLarge = SkinHandler:getFont("HUD Large")
    self.fontSmall = SkinHandler:getFont("HUD Small")
    self.fontExtraSmall = SkinHandler:getFont("HUD Extra Small")
end

function maniaHUD:update(dt)

end

function maniaHUD:sendValues(score)  -- will be called every frame (obviously) to pass shit to the hud 
    self.score = score
end

function maniaHUD:draw()
    if self.debug then self:debugDraw() end

    -- top left
    love.graphics.setFont(self.fontLarge)
    love.graphics.printf(self.score, 10, 10, baseScreenRatio.x, "left")

end

function maniaHUD:debugDraw()
        love.graphics.print("DEBUG SHIT" .. "\n"
                        .. "SCORE: " .. self.score,
                    100,100)
end

return maniaHUD