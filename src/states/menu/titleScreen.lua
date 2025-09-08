local titleScreen = State("titleScreen")

function titleScreen:enter()
   -- self.realLogo = love.graphics.newImage("Skins/Default Arrow/TEMP/real logo"..tostring(love.math.random(1,2))..".png")
   self.BG = love.graphics.newImage("Skins/Default Arrow Batched/MENU/TITLEBG/1.png")
    self.wavesY = 0

    self.buttonWidth = 400
    self.buttonHeight = 100 
    self.buttonX = 300 - self.buttonWidth / 2 
    self.buttonLabels = {
        {label = "Play", func = function() self:raiseWaves(); State.transition("waveDissolve", States.menu.songSelect) end, color1 = {94/255,252/255,141/255,1},color2 = {44/255,251/255,106/255,0}},
        {label = "Jukebox", func = function() State.switch(States.menu.jukebox) end, color1 = {142/255,249/255,243/255,1},color2 = {88/255,246/255,238/255,1}},
        {label = "Settings", func = function() State.switch(States.menu.songSelect) end, color1 = {147/255,190/255,223/255,1},color2 = {106/255,165/255,210/255,1}},
        {label = "Discord", func = function() love.system.openURL("https://discord.gg/bBcjrRAeh4") end, color1 = {131/255,119/255,209/255,1},color2 = {97/255,82/255,196/255,1}},
        {label = "GitHub", func = function() love.system.openURL("https://github.com/clothhang/Harmoni") end, color1 = {109/255,90/255,114/255,1},color2 = {93/255,76/255,97/255,1}},
        {label = "Exit", func = function() love.event.quit() end, color1 = {1,1,1,1}, color2 = {1,1,1,1}},
    }

    self.images = {
        ["H"] = {image = SkinHandler:getImage("Menu", "H"), sizeX  = 1, sizeY = 1, x = 0, y = 0},
        ["logo"] = {image = SkinHandler:getImage("Menu", "Main Logo"), sizeX  = 1, sizeY = 1, x = 0, y = 0},
    }

    buttonSpacing = 10

    self.buttons = {

    }

    for i = 1,#self.buttonLabels do
        table.insert(self.buttons, buttonSlideOut(self.buttonX, 600 + (i-1) * (self.buttonHeight + buttonSpacing), self.buttonWidth, self.buttonHeight, self.buttonLabels[i].label, self.buttonLabels[i].func, 7, self.buttonLabels[i].color1, self.buttonLabels[i].color2))
    end

    self:setUpThoseLinesThatIHate(10)
    self:setUpThoseWavesThatIHate(4)


--    self.circcle = UISquigleCircle("fill", 400, 300, 120, 5, 13, 3)



    self:setUpThoseBubblesThatIHate(10)
end


function titleScreen:setUpThoseBubblesThatIHate(numberOfBubbles)
    self.bubbles = {}

    transparency = 0.1
local colors = {
    {240/255, 323/255, 205/255, transparency},  -- 240/323/205
    {219/255, 213/255, 185/255, transparency},  -- 219/213/185
    {192/255, 186/255, 153/255, transparency},  -- 192/186/153
    {254/255, 235/255, 201/255, transparency},  -- 254/235/201
    {253/255, 203/255, 162/255, transparency},  -- 253/203/162
    {252/255, 169/255, 133/255, transparency},  -- 252/169/133
    {125/255, 255/255, 76/255, transparency},   -- 125/255/76
    {255/255, 250/255, 19/255, transparency},   -- 255/250/19
    {255/255, 237/255, 81/255, transparency},   -- 255/237/81
    {224/255, 243/255, 176/255, transparency},  -- 224/243/176
    {191/255, 228/255, 18/255, transparency},   -- 191/228/18
    {133/255, 202/255, 93/255, transparency},   -- 133/202/93
    {207/255, 236/255, 207/255, transparency},  -- 207/236/207
    {181/255, 235/255, 174/255, transparency},  -- 181/235/174
    {145/255, 210/255, 144/255, transparency},  -- 145/210/144
    {179/255, 226/255, 221/255, transparency},  -- 179/226/221
    {134/255, 207/255, 190/255, transparency},  -- 134/207/190
    {72/255, 181/255, 163/255, transparency},   -- 72/181/163
    {20/255, 173/255, 207/255, transparency},   -- 20/173/207
    {18/255, 225/255, 174/255, transparency},   -- 18/225/174
    {14/255, 210/255, 144/255, transparency},   -- 14/210/144
    {179/255, 226/255, 21/255, transparency},   -- 179/226/21
    {134/255, 207/255, 79/255, transparency},   -- 134/207/79
    {72/255, 181/255, 63/255, transparency},    -- 72/181/63
    {15/255, 106/255, 239/255, transparency},   -- 15/106/239
    {154/255, 206/255, 235/255, transparency},  -- 154/206/235
    {111/255, 183/255, 214/255, transparency},  -- 111/183/214
    {191/255, 213/255, 232/255, transparency},  -- 191/213/232
    {148/255, 168/255, 208/255, transparency},  -- 148/168/208
    {117/255, 137/255, 191/255, transparency},  -- 117/137/191
}

    for i = 1,20 do 
        ::start::
        local x,y = love.math.random(0, baseScreenRatio.x), love.math.random(baseScreenRatio.y, 0)

        if x > 0 and y < baseScreenRatio.y then -- its on the screen, we gotta start over 
         --   goto start
        end

        local color = colors[love.math.random(1,#colors)]
        table.insert(self.bubbles, UISquigleCircle("fill", x, y, 100, 5, 5, 3, color))
    end

end


function titleScreen:setUpThoseWavesThatIHate(numberOfWaves)
    local colors = {
        {1,1,1,0.5},
        {0,1,1,0.5},
        {1,0,1,0.5},
        {0,0,1,0.5}
    }
    local transparency = 0.5
    local colors = {
        {240/255, 323/255, 205/255, transparency},  -- 240/323/205
        {219/255, 213/255, 185/255, transparency},  -- 219/213/185
        {192/255, 186/255, 153/255, transparency},  -- 192/186/153
        {254/255, 235/255, 201/255, transparency},  -- 254/235/201
        {253/255, 203/255, 162/255, transparency},  -- 253/203/162
        {252/255, 169/255, 133/255, transparency},  -- 252/169/133
        {125/255, 255/255, 76/255, transparency},   -- 125/255/76
        {255/255, 250/255, 19/255, transparency},   -- 255/250/19
        {255/255, 237/255, 81/255, transparency},   -- 255/237/81
        {224/255, 243/255, 176/255, transparency},  -- 224/243/176
        {191/255, 228/255, 18/255, transparency},   -- 191/228/18
        {133/255, 202/255, 93/255, transparency},   -- 133/202/93
        {207/255, 236/255, 207/255, transparency},  -- 207/236/207
        {181/255, 235/255, 174/255, transparency},  -- 181/235/174
        {145/255, 210/255, 144/255, transparency},  -- 145/210/144
        {179/255, 226/255, 221/255, transparency},  -- 179/226/221
        {134/255, 207/255, 190/255, transparency},  -- 134/207/190
        {72/255, 181/255, 163/255, transparency},   -- 72/181/163
        {20/255, 173/255, 207/255, transparency},   -- 20/173/207
        {18/255, 225/255, 174/255, transparency},   -- 18/225/174
        {14/255, 210/255, 144/255, transparency},   -- 14/210/144
        {179/255, 226/255, 21/255, transparency},   -- 179/226/21
        {134/255, 207/255, 79/255, transparency},   -- 134/207/79
        {72/255, 181/255, 63/255, transparency},    -- 72/181/63
        {15/255, 106/255, 239/255, transparency},   -- 15/106/239
        {154/255, 206/255, 235/255, transparency},  -- 154/206/235
        {111/255, 183/255, 214/255, transparency},  -- 111/183/214
        {191/255, 213/255, 232/255, transparency},  -- 191/213/232
        {148/255, 168/255, 208/255, transparency},  -- 148/168/208
        {117/255, 137/255, 191/255, transparency},  -- 117/137/191

    }
    colorsREAL = {}

    -- we need to randomly choose numberOfWaves amount of these colors 

    for i = 1,numberOfWaves do 
        table.insert(colorsREAL, colors[love.math.random(1,#colors)])
    end
    self.layerWaves = UILayerWave(0,baseScreenRatio.y+50,baseScreenRatio.x,500,#colorsREAL,300, 30, 50, colorsREAL)
end


function titleScreen:setUpThoseLinesThatIHate(numberOfLines)
    self.squiglyLines = {}
    for i = 1,numberOfLines do
        local y = ((baseScreenRatio.y+400)/numberOfLines)*(i-2)
        local x1,x2 = -50, baseScreenRatio.x+50
        table.insert(self.squiglyLines, UIsquiglyLine(x1,y+300,x2,y-300,10,30,1000,1,70,{1,1,1,0.15}))
    end
end

function titleScreen:switchState(state)
    if state == "H" then

    elseif state == "logo" then
        
    end
end

function titleScreen:raiseWaves()
    Timer.tween(0.5, self, {wavesY = -500}, "in-quad")
end


function titleScreen:update(dt)
    for i, Button in ipairs(self.buttons) do
        Button:update(dt)
    end
    for i, squiglyLines in ipairs(self.squiglyLines) do
        squiglyLines:update(dt)
    end

    self.layerWaves:update(dt)

    self:updateBubbles(dt) 
end

function titleScreen:updateBubbles(dt)
    for i, Bubble in ipairs(self.bubbles) do
        Bubble:update(dt)
        Bubble.x, Bubble.y = Bubble.x + math.sin(love.timer.getTime() * 0.5 + i) * 30 * dt, Bubble.y - 50 * dt
        Bubble.y = Bubble.y + math.cos(love.timer.getTime() * 0.5 + i) * 30 * dt
        if Bubble.x > baseScreenRatio.x + 100 then Bubble.x = -100 elseif Bubble.x < -100 then Bubble.x = baseScreenRatio.x + 100 end
        if Bubble.y < -100 then Bubble.y = baseScreenRatio.y + 100 end
    end
end
function titleScreen:draw()
    love.graphics.draw(self.BG) -- TEMP 
       for i, Bubble in ipairs(self.bubbles) do
    Bubble:draw()
   end
    love.graphics.print("harmoni lol")

    love.graphics.setColor(1,1,1,0.1)
    love.graphics.push()
        love.graphics.translate(0, self.wavesY)
        self.layerWaves:draw()
    love.graphics.pop()
    love.graphics.setColor(1,1,1,0.05)
    for i, squiglyLines in ipairs(self.squiglyLines) do
        squiglyLines:draw()
    end

    for i, Button in ipairs(self.buttons) do
        Button:draw()
    end
    love.graphics.setColor(1,1,1,1)

    self:drawLogo()
   -- self.circcle:draw(0)

end


function titleScreen:drawLogo()
    
    -- the logo drawing is complex so we move it to its own function
    local fullLogoFinalX, fullLogoFinalY = baseScreenRatio.x/2, 300
    local HOnlyFinalX, HOnlyFinalY = 0,0 -- ill figure it out later 
    local HOnlyStartingX, HOnlyStartingY = 0,0

    local HOnlyX, HOnlyY = HOnlyStartingX, HOnlyStartingY

  
  --  love.graphics.draw(self.images["H"], )

    -- we need to draw the full logo first 

    -- logo variables 
    local fullLogo = self.images["logo"].image
    local fullLogoSizeX, fullLogoSizeY, fullLogoX, fullLogoY = 1.5, 1.5, baseScreenRatio.x/2, baseScreenRatio.y/2
    local fullLogoCenterX, fullLogoCenterY = fullLogo:getWidth()/2, fullLogo:getHeight()/2

    love.graphics.draw(fullLogo, baseScreenRatio.x/2, baseScreenRatio.y/2-350, 0, fullLogoSizeX, fullLogoSizeY, fullLogoCenterX, fullLogoCenterY)
end

return titleScreen