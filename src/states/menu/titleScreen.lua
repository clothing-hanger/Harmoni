local titleScreen = State("titleScreen")

function titleScreen:enter()
    self.realLogo = love.graphics.newImage("Skins/Default Arrow/TEMP/real logo"..tostring(love.math.random(1,2))..".png")

end

function titleScreen:update(dt)
    if Input:pressed("menuConfirm") then
        State.switch(States.menu.songSelect)
    end
    --print("test")
end

function titleScreen:draw()
    love.graphics.print("harmoni lol")
    love.graphics.draw(self.realLogo, 0, 0, nil, baseScreenRatio.x/self.realLogo:getWidth(), baseScreenRatio.y/self.realLogo:getHeight())
end

return titleScreen