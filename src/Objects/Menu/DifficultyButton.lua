local DifficultyButton = Class:extend()

function DifficultyButton:new(diffName, charterName, difficulty, id)
    self.x, self.y = 700, 250
    self.width, self.height = 400, 50
    self.diffName = diffName or "Song Name not found!"
    self.charterName = charterName or ""  -- no need for error text for these since they arent that important
    self.difficulty = difficulty or "Difficulty not found!"
    self.hovered = false
    self.id = id
    return self -- game crashes without this but it isnt needed for any other object (including the song buttons) :skull:
end

function DifficultyButton:update(dt)
    self.hovered =  ((cursorX > self.x and cursorX < self.x + self.width) and (cursorY > self.y and cursorY < self.y + self.height)) 

    if self.hovered and Input:pressed("menuClickLeft") then
        self:click()
    end
end

function DifficultyButton:click()
    print(self.diffName .. " Clicked")
    SelectedDifficulty = 1
   -- States.Menu.SongSelect:enterPlayState()
end

function DifficultyButton:draw()
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    love.graphics.print(self.diffName, self.x, self.y)
    --print(self.diffName)

end

function DifficultyButton:release()

end

return DifficultyButton