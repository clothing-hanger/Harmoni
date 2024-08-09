local Combo = Class:extend()

function Combo:new()
    self.x, self.y = Skin.Params["Combo X Offset"], Skin.Params["Combo Y Offset"]
    self.width = 1000 -- shouldnt ever need to be edited, just to ensure the combo never wraps
end

function Combo:update(dt)

end

function Combo:draw()
    love.graphics.translate(Inits.GameWidth/2, Inits.GameHeight/2)

  --  if combo == 0 then return end
    love.graphics.setFont(Skin.Fonts["Combo"])
    love.graphics.printf(combo, self.x-(self.width/2), self.y, self.width, "center")
    love.graphics.translate(-Inits.GameWidth/2, -Inits.GameHeight/2)

end

function Combo:release()

end

return Combo