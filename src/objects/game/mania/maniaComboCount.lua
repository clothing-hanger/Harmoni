local maniaComboCount = Class:extend("maniaComboCount")

function maniaComboCount:new(x, y)
    self.combo = 0
    self.drawnCombos = {}
    self.fullTimeLimit = 200
    self.x, self.y, self.limit = x or 0, y or 0, 400

    self.removeComboStack = SkinHandler:getParam("Remove Combo Stack") or false
    self.activeTweens = {}
    self.debug = false
end

function maniaComboCount:update(dt)
    for i = #self.activeTweens, 1, -1 do
        if self.activeTweens[i].update(dt) then
            table.remove(self.activeTweens, i)
        end
    end

    for i = #self.drawnCombos, 1, -1 do
        local Combo = self.drawnCombos[i]
        if not self.removeComboStack then
            Combo.time = Combo.time - dt * 1000
        end
        if Combo.time <= 0 then
            table.remove(self.drawnCombos, i)
        end
    end
end

function maniaComboCount:incrementCombo()
    self.combo = self.combo + 1
    self:addDrawableCombo()
end

function maniaComboCount:breakCombo()
    self.combo = 0
end

function maniaComboCount:addDrawableCombo()
    if self.removeComboStack then
        self.drawnCombos = {}
    end

    local comboObj = {
        combo = self.combo,
        time = self.fullTimeLimit,
        x = self.x,
        y = self.y,
        hasTweened = false
    }

    table.insert(self.drawnCombos, comboObj)
    self:startTween(comboObj)
end

function maniaComboCount:startTween(combo)
    if combo.hasTweened then return end
    combo.hasTweened = true

    local duration = SkinHandler:getParam("Judgement Bump Time")
    local amount = SkinHandler:getParam("Judgement Bump Amount")
    local tweenType = SkinHandler:getParam("Judgement Bump Tween Type")
    local easing = Ease[tweenType] or Ease.linear

    local startY = combo.y
    local endY = startY + amount
    local time = 0

    table.insert(self.activeTweens, {
        target = combo,
        update = function(dt)
            time = time + dt
            local t = math.min(time / duration, 1)
            combo.y = startY + (endY - startY) * easing(t)
            return t >= 1
        end
    })
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
        love.graphics.print("Combo: " .. self.combo .. "\nCombo Table: " .. #self.drawnCombos, self.x, self.y + 30)
    end

    love.graphics.setColor(1, 1, 1)
end

return maniaComboCount