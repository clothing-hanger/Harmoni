local tutorialState = State()

function tutorialState:enter(p,tutorial)
    print(tutorial)
    self:setupTutorial(love.filesystem.load(tutorial)())
    self:switchPage(1)
end

function tutorialState:setupTutorial(t)
    
    self.tutorialData = t
    -- first we get the metadata
    self.metaData = t.metadata
     -- now we make the pagesssssssssss :3
    self.pages = {}
    for jamie, Paige in ipairs(t.pages) do  --omg jamie paige what are u doing here!!! :3   (for legal reasons i should say jamie paige is not involved with this stupid fucking chud game)
        table.insert(self.pages,{image = Paige.image, title = Paige.title, text = Paige.text})
    end
end

function tutorialState:switchPage(page)
    self.currentText = self.pages[page].text
    self.currentImage = self.pages[page].image
    self.currentTitle = self.pages[page].title

end

function tutorialState:update(dt)
end

function tutorialState:draw()
    if self.currentText then
        love.graphics.printf(self.currentText,0, baseScreenRatio.y-100, baseScreenRatio.x, "center")
    end
    if self.currentImage then
        love.graphics.draw(self.image, 0, 0, sx, sy, self.image:getWidth()/2, self.image:getHeight()/2)
    end
    if self.currentTitle then
        love.graphics.printf(self.currentTitle, 0, 100, baseScreenRatio.x, "center")
    end
end

return tutorialState