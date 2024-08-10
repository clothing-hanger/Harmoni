local SongButton = Class:extend()

function SongButton:new(songName, charterName, artistName, id)
    self.x, self.y = 700, 250
    self.width, self.height = 400, 50
    self.songName = songName or "Song Name not found!"
    self.charterName = charterName or ""  -- no need for error text for these since they arent that important
    self.artistName = artistName or ""
    self.hovered = false
    self.id = id
end

function SongButton:update(dt)
    self.hovered =  ((cursorX > self.x and cursorX < self.x + self.width) and (cursorY > self.y and cursorY < self.y + self.height)) 

    if self.hovered and Input:pressed("menuClickLeft") then
        self:click()
    end
end

function SongButton:click()
    print(self.songName .. " Clicked")
    SelectedSong = self.id
    States.Menu.SongSelect:SwitchMenuState("Difficulty")
end

function SongButton:draw()
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    love.graphics.print(self.songName, self.x, self.y)
end

function SongButton:release()

end

return SongButton