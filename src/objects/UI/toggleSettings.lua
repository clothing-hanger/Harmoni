local toggleSetting = Class:extend("toggleSetting")

function toggleSetting:new(x,y,width,height,default,setValue)
    self.x, self.y = x, y
    self.width, self.height = width, height
    self.default, self.setValue = default, setValue
    self.pillWidth = self.width/10  -- i really need to move the rest of the pill stuff here,, idk why i put it all in Draw

    self.handleCount = 2
    self.handles = {}
    self.handletween = {}

    self.pillHeight = self.height/3
    self.pillX      = self.x + self.width - self.pillWidth * 1.5
    self.pillY      = self.y + self.height/2 - self.pillHeight/2
    self.pillCornerRadius = self.pillHeight/2
    self.circleRadius = self.pillHeight/2 - 4

    for _ = 1,self.handleCount do
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

end
function toggleSetting:onClick()
    self:toggleFunction()
    self:tweenHandle()
end

function toggleSetting:tweenHandle()
    for i, Handle in ipairs(self.handles) do
        local delay = (i * 1)
        local time = 1
        local x = not self.toggle and (self.pillX + self.circleRadius + 2) or (self.pillX + self.pillWidth - self.circleRadius - 2)
        if self.handletween[i] then Timer.cancel(self.handletween[i]) end
        self.handletween[i] = Timer.tween(time + delay, Handle, { x = x }, "out-elastic")
    end
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
    love.graphics.push()
    love.graphics.translate(self.x, 0)
    -- backdrop
    love.graphics.setColor(194/255,194/255,194/255,0.7)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, self.pillCornerRadius, self.pillCornerRadius)

    -- we are going to just steal Android's design for this lol

    love.graphics.setLineWidth(self.pillLineWidth)
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("line", self.pillX, self.pillY, self.pillWidth, self.pillHeight, self.pillCornerRadius, self.pillCornerRadius)

    --now we draw the fill
    love.graphics.setColor(46/255,47/255,49/255, self.pillFillAlpha)  -- thank you Google Maps settings page for having such a stealable color palette
    love.graphics.rectangle("fill", self.pillX, self.pillY, self.pillWidth, self.pillHeight, self.pillCornerRadius, self.pillCornerRadius)

    -- handle
    love.graphics.setColor(self.pillCircleColor,self.pillCircleColor,self.pillCircleColor)

    local leftX  = math.min(self.handles[1].x, self.handles[2].x)
    local rightX = math.max(self.handles[1].x, self.handles[2].x)

    local pillCircleLeftEdge = leftX - self.pillCircleRadius
    local width = (rightX - leftX) + self.pillCircleRadius * 2

    love.graphics.rectangle("fill", pillCircleLeftEdge, self.handles[1].y - self.pillCircleRadius,
                            width,self.pillCircleRadius * 2, self.pillCircleRadius, self.pillCircleRadius
    )

    love.graphics.setColor(1,1,1)
    love.graphics.pop()
end

return toggleSetting