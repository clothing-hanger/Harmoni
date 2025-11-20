local button = Class:extend()

function button:new(args)  -- im trying out doing args this way cuz it seems better
    if not args then GlobalNotificationsHandler("Button creaeted with no arguments table", "error") end
    if type(args) ~= "table" then GlobalNotificationsHandler("Button created with non table argument", "error") end

    self.x = args.x or 0
    self.y = args.y or 0
    self.width = args.width or 10
    self.height = args.height or 10 

    self.hasImage = args.hasImage or false 
    self.image = args.image or nil
    self.func = args.func or function() end   
    
    self.colorAlpha = 0
    
    
end

function button:update()
    local mx,my = cursor:getPosition()
    if mx >= self.x and mx <= self.x+self.width and my >= self.y and my<= self.y+self.height then
        self.hovered = true
    else self.hovered = false end


    if self.colorTimer then Timer.cancel(self.colorTimer) end 
    self.colorTimer = Timer.tween(1, self, {colorAlpha = (self.hovered and 1) or 0})
end

function button:onClick()
end

function button:draw()



    if self.hasImage then
    --define stencil mask
            local scaleX,scaleY = self.width/self.image:getWidth(), self.height/self.image:getHeight()

        local function maskShape()
            if self.image then love.graphics.draw(self.image, self.x,self.y ,nil,scaleX,scaleY) end
        end
        
        love.graphics.stencil(maskShape, "replace", 1)
        love.graphics.setStencilTest("greater", 0)
        if self.image then love.graphics.draw(self.image, self.x,self.y ,nil,scaleX,scaleY) end

        -- draw the color 
        love.graphics.rectangle("fill", self.x, self.y, )
    end

    love.graphics.setStencilTest()
    
end

return button