local menuSongButton = Class:extend("songButton")

---@oaram function menuSongButton
---@param width, height, name, artist, charter, bpm, image, isDifficultyButton
---Makes a new song button
function menuSongButton:new(width, height, name, artist, charter, bpm, image, isDifficultyButton)
    self.width = width or 10
    self.height = height or 10
    self.x = 10
    self.y = 10
    
    self.name = name or "???"
    self.artist = artist or "???"
    self.charter = charter or "???"
    self.bpm = bpm or "???"
    self.image = image or "???"
    self.isDifficultyButton = isDifficultyButton or false
end

function menuSongButton:onClick()
end

function menuSongButton:update(dt)
end

function menuSongButton:draw()
    love.graphics.rectangle("line", self.width, self.height, self.x, self.y)
    love.graphics.printf(self.name, self.x + 10, self.y + 10, self.width-10, "left")
end

return menuSongButton