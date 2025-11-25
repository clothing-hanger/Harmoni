local toggleSetting = Class:extend("toggleSetting")

function toggleSetting:new(x,y,width,height,default,setValue)
    self.x,self.y,self.width,self.height,self.default,self.setValue = x,y,width,height,default,setValue

    self.pillLineWidth = 0
    self.pillFillAlpha = 0
    self.pillCircleRadius = 0
    self.pillCircleColor = 0
    self.toggle = setValue
end

function toggleSetting:update(dt)
    self.pillLineWidthTarget = (self.toggle and 0) or 5
    self.pillLineWidth = self.pillLineWidth + (self.pillLineWidthTarget - self.pillLineWidth) * 10 *dt

    self.pillFillAlphaTarget = (self.toggle and 1) or 0
    self.pillFillAlpha = self.pillFillAlpha + (self.pillFillAlphaTarget - self.pillFillAlpha) * 10 *dt

    self.pillCircleRadiusTarget = (self.toggle and (self.height/3)/2) or ((self.height/3)/2)/2
    self.pillCircleRadius = self.pillCircleRadius + (self.pillCircleRadiusTarget - self.pillCircleRadius) * 10 *dt

    self.pillCircleColorTarget = (self.toggle and 1) or 0
    self.pillCircleColor = self.pillCircleColor + (self.pillCircleColorTarget - self.pillCircleColor) * 10 *dt

    print(self.pillFillAlpha)
end
function toggleSetting:onClick()
    self:toggleFunction()
end

function toggleSetting:toggleFunction()
    print("HIIIIIII")
    self.toggle = not self.toggle

    print(self.toggle)
end

function toggleSetting:getValue(str)
    if str == "set" then
        return self.toggle
    elseif str == "default" then
        return self.default
    end
end


function toggleSetting:draw()

        local pillWidth  = self.width/10
    local pillHeight = self.height/3
    local pillX      = self.x + self.width - pillWidth * 1.5
    local pillY      = self.y + self.height/2 - pillHeight/2
    local pillCornerRadius = pillHeight/2
    
    -- backdrop
        local circleRadius = pillHeight/2 - 4


    love.graphics.setColor(194/255,194/255,194/255,0.7)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, pillCornerRadius, pillCornerRadius)

    -- draw pill
  --  love.graphics.setColor(0,0,0)
  --  love.graphics.rectangle("line", pillX, pillY, pillWidth, pillHeight, pillCornerRadius, pillCornerRadius)

    -- we are going to just steal Android's design for this lol

  --  self.pillLineWidthTarget = (self.toggle and 0) or 10
    --self.pillLineWidth = self.pillLineWidth + (self.pillLineWidthTarget - self.pillLineWidth) * 10 --* love.timer.getDelta()
    love.graphics.setLineWidth(self.pillLineWidth)
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("line", pillX, pillY, pillWidth, pillHeight, pillCornerRadius, pillCornerRadius)

    
    --now we draw the fill
    love.graphics.setColor(46/255,47/255,49/255, self.pillFillAlpha)  -- thank you Google Maps settings page for having such a stealable color palette
    love.graphics.rectangle("fill", pillX, pillY, pillWidth, pillHeight, pillCornerRadius, pillCornerRadius)



    -- circle
    love.graphics.setColor(self.pillCircleColor,self.pillCircleColor,self.pillCircleColor)

    local circleX = not self.toggle  and (pillX + circleRadius + 2) or  (pillX + pillWidth - circleRadius - 2)

    local circleY = pillY + pillHeight/2

    love.graphics.circle("fill", circleX, circleY, self.pillCircleRadius)

    -- reset
    love.graphics.setColor(1,1,1)
end

return toggleSetting