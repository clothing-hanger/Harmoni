local resultsState = State("resultsState")

function resultsState:enter(parent, accuracy, image) -- acc and image will just be used for testing, for the real results we will just use parent
    self.parent = parent
    self.x,self.y = baseScreenRatio.x/2, baseScreenRatio.y/2 -- it will draw centered to this
    self.width,self.height = 700, 1100 -- im fucking guessing 
    
    self.rectX, self.rectY = self.x - (self.width/2), self.y - (self.height/2)
    self.rectRC = 90
    print(self.parent)
    self.background = self.parent.BG
end

function resultsState:update(dt)

end

function resultsState:draw()
    love.graphics.draw(self.image)
    love.graphics.rectangle("fill", self.rectX, self.rectY, self.width, self.height, self.rectRC, self.rectRC)
end

return resultsState