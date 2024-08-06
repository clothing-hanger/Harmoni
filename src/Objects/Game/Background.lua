local Background = Class:extend()

function Background:new(bg)
    self.x, self.y = 0,0
    self.image = bg
    self.w, self.h = 1,1
    self.brightness = {1}

    Background:setBrightness(0.5, true)
end

function Background:update(dt)

end

function Background:setBrightness(brightness, tween, time, tweenType)
    if not brightness then return end
    if tween then
        tweenType = tweenType or "linear"
        time = time or 1
        Timer.tween(time, self.brightness, {brightness}, tweenType)
    else
        self.brightness[1] = brightness
    end
end

function Background:draw()
    love.graphics.translate(Inits.WindowWidth/2, Inits.WindowHeight/2)
    love.graphics.setColor(1,1,1,self.brightness[1])
    love.graphics.draw(self.image, 0, 0, 0, (Inits.GameWidth/self.image:getWidth())*self.w, (Inits.GameHeight/self.image:getHeight())*self.h, self.image:getWidth()/2, self.image:getHeight()/2) -- self.w, self.h, 0, self.image:getWidth()/2, self.image:getHeight()/2)
    love.graphics.translate(-Inits.WindowWidth/2, -Inits.WindowHeight/2)
    love.graphics.setColor(1,1,1,1)

end

function Background:release()

end

return Background