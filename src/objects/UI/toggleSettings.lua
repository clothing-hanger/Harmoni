local toggleSetting = Class:extend("toggleSetting")

function toggleSetting:new(x,y,width,height,default,setValue)
    self.x,self.y,self.width,self.height,self.default,self.setValue = x,y,width,height,default,setValue

    
    self.toggle = setValue
end

function toggleSetting:update(dt)
end

function toggleSetting:onClick()
    self:toggleFunction()
end

function toggleSetting:toggleFunction()
    self.toggle = not self.toggle
end

function toggleSetting:getValue(str)
    if str == "set" then
        return self.toggle
    elseif str == "default" then
        return self.default
    end
end

function toggleSetting:draw()
    -- first we draw the backdrop thingy
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)   -- add skinable corner radius


    -- next we draw the pill for the switch 
    love.graphics.setColor(0,0,0)
    local pillWidth,pillHeight = self.width/10,self.height/3
    local pillX,pillY = self.x+self.width-pillWidth*1.5, (self.y+(self.height/2)) - pillHeight/2
    local pillCornerRadius = pillHeight/2
    love.graphics.rectangle("line", pillX,pillY,pillWidth,pillHeight,pillCornerRadius,pillCornerRadius)

    love.graphics.setColor(1,0,0)
    -- then we draw the circle inside the pill
    local circleRadius = pillHeight/2-4  -- me when hardcoded value 
    local circleX = (self.toggle and pillX) or (pillX+pillWidth)
    local circleY = pillHeight+circleRadius*2
    love.graphics.circle("fill", circleX, circleY, circleRadius)

    love.graphics.setColor(1,1,1)

end

return toggleSetting