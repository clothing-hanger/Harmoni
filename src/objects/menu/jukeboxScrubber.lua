local jukeboxScrubber = Class:extend("jukeboxScrubber")

function jukeboxScrubber:new(x,y,width,thickness)
    self.progress = 0

end

function jukeboxScrubber:update(dt)

end

function jukeboxScrubber:onClick()
    local MX,MY = cursor:getPosition()
    -- first we get where on the scrubber the mouse is at
    --we uhhh do shit here or something idk 
    --Px-Ax/Bx-Ax
    local Px = MX
    local Ax = self.x 
    local Bx = self.x+self.width
    local percent = (Px-Ax)/(Bx-Ax)

    -- then we set the progress to be that percent
    self.progress = percent
end

function jukeboxScrubber:getProgress()
    return self.progress
end

function jukeboxScrubber:draw()
    -- draw the line thingy
    love.graphics.line(self.x,self.y,self.x+self.width,self.y)

    --draw the ball thingy 
    --love.graphics.circle("fill", )
end

return jukeboxScrubber