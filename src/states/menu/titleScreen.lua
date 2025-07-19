local titleScreen = State("titleScreen")

function titleScreen:enter()
    self.realLogo = love.graphics.newImage("Skins/Default Arrow/TEMP/real logo"..tostring(love.math.random(1,2))..".png")

    self.buttonWidth = 400
    self.buttonHeight = 100 
    self.buttonX = 300 - self.buttonWidth / 2 
    self.buttonLabels = {
        {label = "Play", func = function() State.switch(States.menu.songSelect) end, color1 = {94/255,252/255,141/255,1},color2 = {44/255,251/255,106/255,1}},
        {label = "Jukebox", func = function() State.switch(States.menu.songSelect) end, color1 = {142/255,249/255,243/255,1},color2 = {88/255,246/255,238/255,1}},
        {label = "Settings", func = function() State.switch(States.menu.songSelect) end, color1 = {147/255,190/255,223/255,1},color2 = {106/255,165/255,210/255,1}},
        {label = "Discord", func = function() State.switch(States.menu.songSelect) end, color1 = {131/255,119/255,209/255,1},color2 = {97/255,82/255,196/255,1}},
        {label = "GitHub", func = function() State.switch(States.menu.songSelect) end, color1 = {109/255,90/255,114/255,1},color2 = {93/255,76/255,97/255,1}},
        {label = "Exit", func = function() State.switch(States.menu.songSelect) end, color1 = {1,1,1,1}, color2 = {1,1,1,1}},
    }

    buttonSpacing = 10

    self.buttons = {

    }

    for i = 1,#self.buttonLabels do
        table.insert(self.buttons, buttonSlideOut(self.buttonX, 700 + (i-1) * (self.buttonHeight + buttonSpacing), self.buttonWidth, self.buttonHeight, self.buttonLabels[i].label, self.buttonLabels[i].func, 7, self.buttonLabels[i].color1, self.buttonLabels[i].color2))
    end

    self:setUpThoseLinesThatIHate(10)
end

function titleScreen:setUpThoseLinesThatIHate(numberOfLines)
    self.squiglyLines = {}
    for i = 1,numberOfLines do
        local y = ((baseScreenRatio.y+400)/numberOfLines)*(i-2)
        local x1,x2 = -50, baseScreenRatio.x+50
        table.insert(self.squiglyLines, UIsquiglyLine(x1,y+300,x2,y-300,10,30,1000,1,70,{1,1,1,0.15}))
    end
end


function titleScreen:update(dt)
    if Input:pressed("menuConfirm") then
        State.switch(States.menu.songSelect)
    end

    for i, Button in ipairs(self.buttons) do
        Button:update(dt)
    end
    for i, squiglyLines in ipairs(self.squiglyLines) do
        squiglyLines:update(dt)
    end
end

function titleScreen:draw()
    love.graphics.print("harmoni lol")
 --   love.graphics.draw(self.realLogo, 0, 0, nil, baseScreenRatio.x/self.realLogo:getWidth(), baseScreenRatio.y/self.realLogo:getHeight())

        love.graphics.setColor(1,1,1,0.1)

    for i, squiglyLines in ipairs(self.squiglyLines) do
        squiglyLines:draw()
    end

    for i, Button in ipairs(self.buttons) do
        Button:draw()
    end
    love.graphics.setColor(1,1,1,1)
end

return titleScreen