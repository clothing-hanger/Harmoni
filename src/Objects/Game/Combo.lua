local Combo = Class:extend()

local Tweens = {}
function Combo:new()
    self.x, self.y = Skin.Params["Combo X Offset"], Skin.Params["Combo Y Offset"]
    self.width = {1}
    self.height = {1}
    self.limit = Inits.GameWidth -- shouldnt need to be changed, just to ensure combo doesnt wrap
    self.alpha = {0}
end

function Combo:update(dt)

end

function Combo:incrementCombo(reset)
  local tween
  if reset then
      combo = 0 -- fuckin loser
  else
      combo = plusEq(combo)
      if combo % 100 == 0 then
        Objects.Game.ComboAlert:doComboAlert(combo)
      end
  end
  if tween then Timer.cancel(tween) end

  self.height = {0.5}
  self.alpha = {1}

  for i = 1,#Tweens do if Tweens[i] then Timer.cancel(Tweens[i]) end end
    

  Tweens[1] = Timer.tween(0.25, self.height, {1}, "out-back", function()
    Timer.tween(0.15, self.alpha, {0})
  end)
  

  
end

function Combo:draw()
    love.graphics.translate(Inits.GameWidth/2, Inits.GameHeight/2)

    if combo == 0 then love.graphics.translate(-Inits.GameWidth/2, -Inits.GameHeight/2) return end
    love.graphics.setFont(Skin.Fonts["Combo"])
    love.graphics.setColor(1,1,1,(self.alpha[1] or 0))
    love.graphics.printf(combo, self.x-(self.limit/2), self.y, self.limit, "center", 0, self.width[1], self.height[1])
    love.graphics.translate(-Inits.GameWidth/2, -Inits.GameHeight/2)

end

function Combo:release()

end

return Combo