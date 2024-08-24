local Background = Class:extend()

function Background:new(bg)
    self.x, self.y = 0,0
    self.image = bg
    self.w, self.h = 1,1
    self.dimness = {0}

end

function Background:update(dt)

end

function Background:setDimness(dimness, tween, time, tweenType)
    if not dimness then return end
    if tween then

        tweenType = tweenType or "linear"
        time = time or 1
        Timer.tween(time, self.dimness, {dimness}, tweenType)
    else
        self.dimness[1] = dimness
    end
end

function Background:draw()
    if not (self.image and type(self.image) == "userdata") then return end
    love.graphics.translate(Inits.GameWidth/2, Inits.GameHeight/2)

    love.graphics.setColor(1,1,1,1)

    love.graphics.draw(self.image, 0, 0, 0, (Inits.GameWidth/self.image:getWidth())*self.w, (Inits.GameHeight/self.image:getHeight())*self.h, self.image:getWidth()/2, self.image:getHeight()/2) -- self.w, self.h, 0, self.image:getWidth()/2, self.image:getHeight()/2)
    love.graphics.setColor(0,0,0,self.dimness[1])

    love.graphics.rectangle("fill", 0-Inits.GameWidth/2, 0-Inits.GameHeight/2, Inits.GameWidth, Inits.GameHeight)

    love.graphics.setColor(1,0,0,((health > 0.25) and 0) or (0.25-health)*2)
    love.graphics.rectangle("fill", 0-Inits.GameWidth/2, 0-Inits.GameHeight/2, Inits.GameWidth, Inits.GameHeight)

    love.graphics.translate(-Inits.GameWidth/2, -Inits.GameHeight/2)
    love.graphics.setColor(1,1,1,1)

end

function Background:release()

end

return Background