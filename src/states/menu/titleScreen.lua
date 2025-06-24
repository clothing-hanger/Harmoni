local titleScreen = State("titleScreen")

function titleScreen:enter()
    self.realLogo = love.graphics.newImage("Skins/Default Arrow/TEMP/real logo.png")
    self.audio = love.audio.newSource("test.mp3", "stream") -- to test syncing with the video
    
    self.video = video("test.mp4", 10, 10, 1, 1)

    
    self.audio:play()

    self.video:play()
end

function titleScreen:update(dt)
    if Input:pressed("menuConfirm") then
        State.switch(States.menu.songSelect)
    end
    self.video:update(dt)
    --print("test")
end

function titleScreen:draw()
    love.graphics.print("harmoni lol")
    love.graphics.draw(self.realLogo, 0, 0, nil, baseScreenRatio.x/self.realLogo:getWidth(), baseScreenRatio.y/self.realLogo:getHeight())
    self.video:draw()
end

return titleScreen