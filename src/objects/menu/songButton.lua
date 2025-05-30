local menuSongButton = Class:extend("songButton")

---@oaram function menuSongButton
---@param width, height, name, artist, charter, bpm, image, isDifficultyButton
---Makes a new song button
function menuSongButton:new(width, height, x, y, name, artist, charter, bpm, image, isDifficultyButton, gameMode, path, cornerRadius)
        print(width, height, name, artist, charter, bpm, image, isDifficultyButton, gameMode, path)

    self.width = width or 10
    self.height = height or 10
    self.x = x or 10
    self.y = y or 10
    print(self.width, self.height)

    self.mode = gameMode or "???" -- would be bad if this isnt valid but we will figure that out later
    
    self.name = name or "???"
    self.artist = artist or "???"
    self.charter = charter or "???"
    self.bpm = bpm or "???"
    self.image = image or nil
    self.path = path or "???" -- would be bad if this path doesnt exist so we need to add a check for this later
    self.isDifficultyButton = isDifficultyButton or false
    self.color = {1,1,1}
    self.cornerRadius = cornerRadius or 7
    self.fontLarge = love.graphics.newFont("fonts/astonpoliz.regular.ttf", 30)
    self.fontSmall = love.graphics.newFont("fonts/astonpoliz.regular.ttf", 18)



end

function menuSongButton:onClick()
    if self.isDifficultyButton then
        --open the selected song and difficulty
        return {loadSong = true, mode = self.mode, path = self.path}
    else -- must just be a song button
        return {loadSong = false, mode = self.mode, path = self.path} -- might not even use all these values 
    end
end

function menuSongButton:loadImage()
    self.attemptedToLoadImage = true -- this is fucking awful
    if not self.image then self.failedToLoadImage = true; return end
    if love.filesystem.getInfo(self.image, "file") then
        local imgData = love.image.newImageData(self.image)
        self.color = getAverageColor(imgData)
        self.image = love.graphics.newImage(imgData)
        print(self.color[1], self.color[2], self.color[3])
        self.imageLoaded = true

    end
end

function menuSongButton:update(dt)
end

function menuSongButton:draw()

    -- set up stencil 
    local function stencilShape()
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, self.cornerRadius, self.cornerRadius)
    end
    love.graphics.stencil(stencilShape, "replace", 1)
    love.graphics.setStencilTest("greater", 0)

    -- draw image (if its loaded)
    local imageScale
    if self.imageLoaded then 
        imageScale = self.width /self.image:getWidth()
    end
    if self.imageLoaded then love.graphics.draw(self.image, self.x, self.y-(self.image:getHeight()*imageScale)/2, nil, imageScale, imageScale) end


    -- draw gradient and filler rectangle
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill",self.x, self.y, self.width/7, self.height)
    drawGradientRect(self.x+self.width/7, self.y, self.width, self.height, {self.color[1], self.color[2], self.color[3], 1}, {self.color[1], self.color[2], self.color[3], 0}, false)

    -- draw song info
    love.graphics.setFont(self.fontLarge)
    local textColor = getTextColor(self.color[1], self.color[2], self.color[3])
    love.graphics.setColor(textColor)
    love.graphics.print(self.name, self.x+3, self.y+3)
    love.graphics.setFont(self.fontSmall)
    love.graphics.print("By: " .. self.artist .. "Charted by: " .. self.charter .. "BPM: " .. self.bpm, self.x+3, self.y + self.height/2)


    love.graphics.setColor(1,1,1)
    love.graphics.setStencilTest()
end

return menuSongButton