local maniaComboCount = Class:extend("maniaComboCount")

function maniaComboCount:new(x,y)
    self.combo = 0
    self.drawnCombos = {}
    self.fullTimeLimit = 200
    self.x, self.y, self.limit = x or 0, y or 0, 400

    self.removeComboStack = SkinHandler:getParam("Remove Combo Stack") or false

    self.debug = false
end

function maniaComboCount:update(dt)
    for i, Combo in ipairs(self.drawnCombos) do
        if not Combo.hasTweened then self:tweenCombo(Combo) end
        if not self.removeComboStack then Combo.time = Combo.time-1000*dt end
        if Combo.time <= 0 then table.remove(self.drawnCombos, i); break end
    end
end

function maniaComboCount:incrementCombo()
    self.combo = self.combo+1
    self:addDrawableCombo()
end

function maniaComboCount:tweenCombo(combo)
    combo.hasTweened = true
    Timer.tween(SkinHandler:getParam("Judgement Bump Time"), combo, {y = combo.y+SkinHandler:getParam("Judgement Bump Amount")}, SkinHandler:getParam("Judgement Bump Tween Type"))
end

function maniaComboCount:breakCombo()
    local prevCombo = self.combo
    self.combo = 0
   -- if prevCombo ~= 0 then self:addDrawableCombo() end -- dont want 0s piling up thats just sad
end

function maniaComboCount:addDrawableCombo()
    if self.removeComboStack then self.drawnCombos = {} end
        table.insert(self.drawnCombos, {combo = self.combo, time = self.fullTimeLimit,x = self.x, y = self.y, hasTweened = false})
end

function maniaComboCount:draw()
    love.graphics.setFont(SkinHandler:getFont("Combo"))
    for i, Combo in ipairs(self.drawnCombos) do
        local alpha = self.removeComboStack and 1 or (Combo.time / self.fullTimeLimit)
        alpha = math.min(math.max(alpha, 0), 1)

        love.graphics.setColor(1, 1, 1, alpha)

        local formattedCombo
        local param = SkinHandler:getParam("Combo Format") or "Full"
        if param == "Short" then
            formattedCombo = string.format("%d", Combo.combo)
        else
            formattedCombo = string.format("%03d", Combo.combo)
        end
        love.graphics.printf(formattedCombo, Combo.x - self.limit / 2, Combo.y, self.limit, "center")
    end

    if self.debug then
        love.graphics.rectangle("line", self.x - self.limit / 2, self.y, self.limit, 50)
        love.graphics.print("Combo: " .. self.combo .. "\n" .. "Combo Table: " .. #self.drawnCombos, self.x, self.y + 30)
    end
end


return maniaComboCount