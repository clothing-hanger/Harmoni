local tutorialState = State()

function tutorialState:enter(tutorial)
    self:setupTutorial(love.filesystem.load(tutorial))
end

function tutorialState:setupTutorial(t)
    self.tutorialData = t
    -- first we get the metadata
    self.metaData = t.metadata
     -- now we make the pagesssssssssss :3
    self.pages = {}
    for jamie, Paige in ipairs(t.pages) do  --omg jamie paige what are u doing here!!! :3   (for legal reasons i should say jamie paige is not involved with this stupid fucking chud game)
        table.insert({image = Paige.image, title = Paige.title, text = Paige.text})
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
        love.graphics.printf()
end

return tutorialState