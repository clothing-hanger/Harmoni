local tutorialState = State()

function tutorialState:enter(p,tutorial)
    print(tutorial)
    self:setupTutorial(love.filesystem.load(tutorial)())
    self.currentPage = 1
    self:switchPage(self.currentPage)
    self.titleFont = SkinHandler:getFont("Menu", 50)
    self.subtextFont = SkinHandler:getFont("Menu",35)
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
    if Input:pressed("menuConfirm") or Input:pressed("menuClickLeft") then
        self.currentPage = self.currentPage + 1
        self:switchPage(self.currentPage)
    end
end

function tutorialState:draw()
    local sx,sy = 0.7,0.7
    love.graphics.setFont(self.subtextFont)
    if self.currentText then
        love.graphics.printf(self.currentText,0, baseScreenRatio.y-150, baseScreenRatio.x, "center")
    end
    if self.currentImage then
        love.graphics.draw(self.currentImage, baseScreenRatio.x/2, baseScreenRatio.y/2,0, sx, sy, self.currentImage:getWidth()/2, self.currentImage:getHeight()/2)
    end
    love.graphics.setFont(self.titleFont)
    if self.currentTitle then
        love.graphics.printf(self.currentTitle, 0, 100, baseScreenRatio.x, "center")
    end
end

return tutorialState