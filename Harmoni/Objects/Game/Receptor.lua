local Receptor = Class:extend()

local ReceptorImages = {
    ReceptorLeftImage,
    ReceptorDownImage,
    ReceptorUpImage,
    ReceptorRightImage
}

local PressedReceptorImages = {
    ReceptorPressedLeftImage,
    ReceptorPressedDownImage,
    ReceptorPressedUpImage,
    ReceptorPressedRightImage
}

function Receptor:new(lane, x, y)
    self.x = Inits.GameWidth/2-(LaneWidth*(3-lane)) --- FIX THIS ITS TERRIBLE (im leaving it here for now so i can replace all occurances of it at once)
    self.y = verticalNoteOffset

    self.lane = lane
    self.image = ReceptorImages[lane]
    self.imagePressed = PressedReceptorImages[lane]

    self.alpha = 1
   
    return self
end

function Receptor:update(dt)
    -- nothing happens here yet

end

function Receptor:draw()    
    love.graphics.setColor(1, 1, 1)

    love.graphics.setColor(1, 1, 1, self.alpha)
    if Input:down(allInputs[lane]) then
        love.graphics.draw(self.imagePressed, self.x, self.y, 0, 125/self.imagePressed:getWidth(), 125/self.imagePressed:getHeight())
    else
        love.graphics.draw(self.image, self.x, self.y, 0, 125/self.image:getWidth(), 125/self.image:getHeight())
    end

end

return Receptor