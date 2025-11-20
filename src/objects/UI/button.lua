local button = Class:extend()

function button:new(args)  -- im trying out doing args this way cuz it seems better
    if not args then GlobalNotificationsHandler("Button creaeted with no arguments table", "error") end
    if type(args) ~= "table" then GlobalNotificationsHandler("Button created with non table argument", "error") end

    self.x = args.x or 0
    self.y = args.y or 0
    self.width = args.width or 10
    self.height = args.height or 10 

    self.hasImage = args.hasImage or false 
    self.scale = 1
    self.image = args.image or nil
    self.scaleLARGE = args.scaleLARGE or 1.5
    self.scaleSMALL = args.scaleSMALL or 1
    self.func = args.func or function() end   
    
    self.hoverColor = args.hoverColor or {0,0,0}
    self.nonhoverColor = args.nonhoverColor or {1,1,1}
    self.color = {self.nonhoverColor[1],self.nonhoverColor[2],self.nonhoverColor[3]} -- do it this way cuz setting it to self.nonhoverColor wont clone the table
    
end

function button:update()
    local mx,my = cursor:getPosition()
    if mx >= self.x and mx <= self.x+self.width and my >= self.y and my<= self.y+self.height then
        self.hovered = true
    else self.hovered = false end
    if self.hovered and Input:pressed("menuClickLeft") then
        self:onClick()
    end


    if self.scaleTimer then Timer.cancel(self.scaleTimer) end
    if self.colorTimer then Timer.cancel(self.colorTimer) end 
    local r,g,b 
    if self.hovered then
        r,g,b = unpack(self.hoverColor)
        self.colorTimer = Timer.tween(0.01, self.color, {[1] = r, [2] = g, [3] = b})
        self.scaleTimer = Timer.tween(0.05, self, {scale = self.scaleLARGE})
    else
        r,g,b = unpack(self.nonhoverColor)
        self.colorTimer = Timer.tween(0.1, self.color, {[1] = r, [2] = g, [3] = b})
        self.scaleTimer = Timer.tween(0.1, self, {scale = self.scaleSMALL})
    end
end

function button:onClick()
    self.func()
end

function button:draw()
    love.graphics.push()
love.graphics.translate(self.x+self.width/2, self.y+self.height/2)
love.graphics.scale(self.scale)
love.graphics.translate(-(self.x+self.width/2), -(self.y+self.height/2))


    if self.hasImage then
            local scaleX,scaleY = self.width/self.image:getWidth(), self.height/self.image:getHeight()

        love.graphics.setColor(self.color)
        if self.image then love.graphics.draw(self.image, self.x,self.y ,nil,scaleX,scaleY) end

    end

    love.graphics.setColor(1,1,1,1)
    love.graphics.pop()
end



return button