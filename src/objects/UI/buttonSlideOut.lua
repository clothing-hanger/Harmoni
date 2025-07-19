local buttonSlideOut = Class:extend("buttonSlideOut")

function buttonSlideOut:new(x, y, width, height, text, func, cornerRadius, color1, color2)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.text = text
    self.func = func or function() end  -- use an empty function so we dont gotta deal with error handling cuz im fucking lazy 
    self.hovered = false

    self.color1 = color1 or {1,1,1}
    self.color2 = color2 or {1,1,1}

    self.cornerRadius = cornerRadius or 7

    self.debug = false

    self.slideInitialWidth = self.width * 0.05 -- 5% of the width
    self.slideWidth = self.slideInitialWidth
end

function buttonSlideOut:update(dt)
    self.hovered = mouseOver(self)

    local width = (self.hovered and self.width) or self.slideInitialWidth

    if self.hovered and Input:pressed("menuClickLeft") then self:onClick() end

    if self.tween then Timer.cancel(self.tween) end
    self.tween = Timer.tween(0.1, self, {slideWidth = width}, "out-bounce")
end


function buttonSlideOut:onClick()
    self.func()
end


function buttonSlideOut:draw()
    if self.debug then
        love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
        love.graphics.print(tostring(self.hovered),self.x + 5, self.y + 5)
    end

    -- we need to set up the stencil shape 
    local function stencilShape()
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, self.cornerRadius, self.cornerRadius)
    end
    love.graphics.stencil(stencilShape, "replace", 1)
    love.graphics.setStencilTest("greater", 0)

    -- now we need to draw the background of the button 


    -- we gotta draw a rectangle if the width is nearrly exactly the initial slider width and a gradient otherwise
    if math.abs(self.slideWidth - self.slideInitialWidth) < 5 then  -- magic number 🥀 but we need it, it hides the transition from gradient to rectangle very well
        love.graphics.setColor(self.color1)
        love.graphics.rectangle("fill", self.x, self.y, self.slideWidth, self.height,self.cornerRadius, self.cornerRadius)
    else
        drawGradientRect(
            self.x, self.y, self.slideWidth, self.height,
            {self.color1[1], self.color1[2], self.color1[3], 1},
            {self.color2[1], self.color2[2], self.color2[3], 1},
            false)
    end

   -- draw the text 
   -- we need to transition the color from the normal color while not hovered to black while hovered (i am horrible at explaining but you see what i mean)
   local textColor = {}
   local textColorPercent = self.slideWidth / self.width  
    textColor[1] = self.color1[1] + (0 - self.color1[1]) * textColorPercent
    textColor[2] = self.color1[2] + (0 - self.color1[2]) * textColorPercent
    textColor[3] = self.color1[3] + (0 - self.color1[3]) * textColorPercent 
    love.graphics.setColor(textColor)
      love.graphics.setFont(SkinHandler:getFont("Menu Extra Large"))

   local textX, textY = self.x + self.slideInitialWidth*2, self.y + self.height / 2 - love.graphics.getFont():getHeight() / 2
   love.graphics.printf(self.text, textX, textY, self.width, "left")
   love.graphics.setStencilTest()

end

return buttonSlideOut