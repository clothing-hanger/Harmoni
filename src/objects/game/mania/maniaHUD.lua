local maniaHUD = Class:extend("maniaHUD")

function maniaHUD:new()
    self.score = 0

    self.debug = true
end

function maniaHUD:update(dt)

end

function maniaHUD:sendValues(score)  -- will be called every frame (obviously) to pass shit to the hud 
    self.score = score
end

function maniaHUD:draw()
    if self.debug then self:debugDraw() end

end

function maniaHUD:debugDraw()
        love.graphics.print("DEBUG SHIT" .. "\n"
                        .. "SCORE: " .. self.score,
                    100,100)
end

return maniaHUD