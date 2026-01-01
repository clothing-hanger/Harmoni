local maniaComboAlert = Class:extend("maniaComboAlert")

function maniaComboAlert:new()
    self.x,self.y,self.targetX,self.targetY = SkinHandler:getParam("Combo Alert Start X"), SkinHandler:getParam("Combo Alert Start Y"), SkinHandler:getParam("Combo Alert Target X"), SkinHandler:getParam("Combo Alert Target Y")
    self.curX,self.curY = self.x,self.y

    self.images = SkinHandler:getComboAlerts()
    self.curCombo = 0

    self.alpha = 0

    if self.images then
        self.curImage = self.images[1]
    end
    
    self.font = SkinHandler:getFont("Combo Alert", SkinHandler:getParam("Combo Alert Font Size"))
end

function maniaComboAlert:doComboAlert(combo)
    self.alpha = 1

    print(combo)
    self.curX,self.curY = self.x,self.y
    local firstDigit = tonumber(tostring(combo):sub(1,1))
    if self.images then
        if self.images[firstDigit] then
            self.curImage = self.images[firstDigit]
        end
    end
    self.curCombo = combo

    if self.tween then Timer.cancel(self.tween) end
    self.tween = Timer.tween(0.5, self, {curX = self.targetX, curY = self.targetY}, "out-back", function()  -- using out back because liquid ass 🤤🤤🤤
        Timer.after(0.3, function()
            Timer.tween(0.1, self, {curY = self.curY - 100, alpha = 0}, "linear")
        end)
    end)
end

function maniaComboAlert:draw()
    love.graphics.setColor(1,1,1,self.alpha)
    love.graphics.setFont(self.font)
    local printlimit = 1000
    love.graphics.printf(self.curCombo .. "\nCombo!", self.curX-printlimit/2, self.curY, printlimit, "center")
    if self.curImage then
        local x,y,ox,oy,width,height = self.curX, self.curY, self.curImage:getWidth()/2, self.curImage:getHeight()/2, 1, 1
        love.graphics.draw(self.curImage, x, y, 0, width, height, ox, oy)
    end
        love.graphics.setColor(1,1,1)
end

return maniaComboAlert