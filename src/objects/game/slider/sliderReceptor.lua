local sliderReceptor = Class:extend("sliderReceptor")

function sliderReceptor:new(lane, inputBind, x, y, parent)
    self.parent = parent
    self.lane = lane
    self.inputBind = inputBind

    self.x, self.y = x, y
    self.size = sliderNoteSize
    self.debug = false
end

function sliderReceptor:update(dt)
end

function sliderReceptor:draw()
    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.rectangle("fill", self.x - self.size / 2, self.y - self.size / 2, self.size, self.size)
    love.graphics.setColor(1, 1, 1, 1)
end

return sliderReceptor