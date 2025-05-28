local menuSongButton = Class:extend("songButton")

---@oaram function menuSongButton
---@param width, height, name, artist, charter, bpm, image, isDifficultyButton
---Makes a new song button
function menuSongButton:new(width, height, name, artist, charter, bpm, image, isDifficultyButton, gameMode, path)
    self.width = width or 10
    self.height = height or 10
    self.x = 10
    self.y = 10

    self.gameMode = gamemode or "???" -- would be bad if this isnt valid but we will figure that out later
    
    self.name = name or "???"
    self.artist = artist or "???"
    self.charter = charter or "???"
    self.bpm = bpm or "???"
    self.image = image or "???"
    self.path = path or "???" -- would be bad if this path doesnt exist so we need to add a check for this later
    self.isDifficultyButton = isDifficultyButton or false
end

function menuSongButton:onClick()
    if isDifficultyButton then
        --open the selected song and difficulty
        return {loadSong = true, mode = self.mode, path = self.path}
    else -- must just be a song button
        return {loadSong = false, mode = self.mode, path = self.path} -- might not even use all these values 
    end
end

function menuSongButton:update(dt)
end

function menuSongButton:draw()
    love.graphics.rectangle("line", self.width, self.height, self.x, self.y)
    love.graphics.printf(self.name, self.x + 10, self.y + 10, self.width-10, "left")
end

return menuSongButton