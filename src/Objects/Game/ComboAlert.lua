local ComboAlert = Class:extend()
local tween

function ComboAlert:new()
    self.x, self.y = {Inits.GameWidth+150}, {Inits.GameHeight/2}
    self.alpha = {0}
    self.text = ""
    self.color = {}
end

function ComboAlert:update(dt)

end

function ComboAlert:doComboAlert(num)
    self.text = tostring(num) .. "Combo!"
    if tween then Timer.cancel(tween) end
    tween = Timer.tween(1.2, self.x, {Inits.GameWidth - 200}, "out-quad", function()
        Timer.tween(0.4, self.y, {Inits.GameHeight/2+25} "out-quad")
        Timer.tween(0.3, self.alpha, {0} "out-quad")
    end)
end

function ComboAlert:draw()
    love.graphics.setFont(Skin.Fonts["HUD Large"])
    love.graphics.printf(self.text, self.x, self.y, 1000, "left")
    love.graphics.setFont(defaultFont)
end

function ComboAlert:release()

end

return ComboAlert