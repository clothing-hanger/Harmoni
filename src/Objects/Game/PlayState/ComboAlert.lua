---@class ComboAlert
local ComboAlert = Class:extend()
local tween

function ComboAlert:new()
    self.x, self.y = {Inits.GameWidth+150}, {Inits.GameHeight/2}
    self.alpha = {0}
    self.text = ""
    self.color = {1,1,1,0}
end

function ComboAlert:update(dt)

end

---@param num number The combo to display
---Does the combo alert with the given combo
function ComboAlert:doComboAlert(num)
    Objects.Game.ComboAlertParticle:emit()
    self.text = tostring(num) .. " Combo!"
    self.color[4] = 1
    self.x, self.y = {Inits.GameWidth+150}, {Inits.GameHeight/2}
    if tween then Timer.cancel(tween) end
    tween = Timer.tween(0.3, self.x, {Inits.GameWidth - 500}, "out-quad", function()
        Timer.after(0.2, function()
            Timer.tween(0.4, self.y, {Inits.GameHeight/2+50}, "out-quad")
            Timer.tween(0.3, self.color, {[4] = 0}, "out-quad")
        end)
    end)
end

function ComboAlert:draw()
    love.graphics.setFont(Skin.Fonts["HUD Large"])
    love.graphics.setColor(self.color)
    love.graphics.printf(self.text, self.x[1], self.y[1], 1000, "left")
    love.graphics.setFont(defaultFont)
    love.graphics.setColor(1,1,1)
end

function ComboAlert:release()

end

return ComboAlert