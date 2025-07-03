local maniaCombo = Class:extend("maniaCombo")

function maniaCombo:new(x,y,width,height,size)
    self.comboCount = 0
    self.x,self.y = x or baseScreenRatio.x/2,y or baseScreenRatio.y/2
    self.width,self.height = 1,1
    self.size = 1
    self.font = Skin.fonts["Combo"]
end

function maniaCombo:update()
end

function maniaCombo:breakCombo()
    self.comboCount = 0 -- there will be more shit here later 
end

function maniaCombo:incrementCombo()
    self.comboCount = self.comboCount + 1 -- there will also be more here later
end

function maniaCombo:draw()
    love.graphics.setFont(self.font)
    love.graphics.printf(self.combo, self.x, self.y, self.width, "center")
end

return maniaCombo