local SongButton = Class:extend()

function SongButton:new(songName, charterName, artistName)
    self.x, self.y = 700, 250
    self.width, self.height = 50, 400
    self.songName = songName or "Song Name not found!"
    self.charterName = charterName or ""  -- no need for error text for these since they arent that important
    self.artistName = artistName or ""
end

function SongButton:update(dt)

end

function SongButton:draw()
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    love.graphics.print(self.songName, self.x, self.y)
end

function SongButton:release()

end

return SongButton