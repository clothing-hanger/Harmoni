local toggleSetting = Class:extend("toggleSetting")

function toggleSetting:new(x,y,width,height,default,setValue)
    
    self.x,self.y,self.width,self.height,self.default,self.setValue = x,y,width,height,default,setValue
    self.pillWidth  = self.width/10  -- i really need to move the rest of the pill stuff here,, idk why i put it all in Draw

    self.handleCount = 10
    self.handles = {}

    self.pillHeight = self.height/3
    self.pillX      = self.x + self.width - self.pillWidth * 1.5
    self.pillY      = self.y + self.height/2 - self.pillHeight/2
    self.pillCornerRadius = self.pillHeight/2
    self.circleRadius = self.pillHeight/2 - 4

    for i = 1,self.handleCount do
        local circleX = self.pillX + self.circleRadius + 2
        local circleY = self.pillY + self.pillHeight/2
        table.insert(self.handles, {x = circleX, y = circleY, radius = self.circleRadius})
    end

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


    -- i dont know a great way to do what im trying to do,,,, so we just do this instead lol

        local targetX = not self.toggle  and (self.pillX + self.circleRadius + 2) or  (self.pillX + self.pillWidth - self.circleRadius - 2)
        -- now we lerp them to the target, but we like change the speed depending on i, i think this will sorta look like its stretching,, maybe

   -- end
end
function toggleSetting:onClick()
    self:toggleFunction()
    self:tweenHandle()
end

function toggleSetting:tweenHandle()
    for i, Handle in ipairs(self.handles) do
        local delay = (i * 0.1)
        local time = 0
        local shortTime = 0.3
        local longTime = 1

        local type = ""
        if i == 1 then type = "out-expo"; time = shortTime else type = "in-expo"; time = time+i*0.02 end
        local x = not self.toggle  and (self.pillX + self.circleRadius + 2) or  (self.pillX + self.pillWidth - self.circleRadius - 2)
        Timer.tween(time, Handle, {x = x}, type)
    end
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

--[
    
    -- backdrop


    love.graphics.setColor(194/255,194/255,194/255,0.7)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, self.pillCornerRadius, self.pillCornerRadius)

    -- draw pill
  --  love.graphics.setColor(0,0,0)
  --  love.graphics.rectangle("line", pillX, pillY, pillWidth, pillHeight, pillCornerRadius, pillCornerRadius)

    -- we are going to just steal Android's design for this lol

  --  self.pillLineWidthTarget = (self.toggle and 0) or 10
    --self.pillLineWidth = self.pillLineWidth + (self.pillLineWidthTarget - self.pillLineWidth) * 10 --* love.timer.getDelta()
    love.graphics.setLineWidth(self.pillLineWidth)
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("line", self.pillX, self.pillY, self.pillWidth, self.pillHeight, self.pillCornerRadius, self.pillCornerRadius)

    
    --now we draw the fill
    love.graphics.setColor(46/255,47/255,49/255, self.pillFillAlpha)  -- thank you Google Maps settings page for having such a stealable color palette
    love.graphics.rectangle("fill", self.pillX, self.pillY, self.pillWidth, self.pillHeight, self.pillCornerRadius, self.pillCornerRadius)



    -- handle
    love.graphics.setColor(self.pillCircleColor,self.pillCircleColor,self.pillCircleColor)

    --local circleX = not self.toggle  and (self.pillX + circleRadius + 2) or  (self.pillX + self.pillWidth - circleRadius - 2)

    --local circleY = self.pillY + self.pillHeight/2

    --love.graphics.circle("fill", circleX, circleY, self.pillCircleRadius)
    for i, Handle in ipairs(self.handles) do
        love.graphics.circle("fill", Handle.x,Handle.y, self.pillCircleRadius)
    end

    -- reset
    love.graphics.setColor(1,1,1)
    --]]
end

return toggleSetting