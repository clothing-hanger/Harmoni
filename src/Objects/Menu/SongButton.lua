local SongButton = Class:extend()

function SongButton:new(songName, charterName, artistName)
    self.x, self.y = 700, 250
    self.width, self.height = 400, 50
    self.songName = songName or "Song Name not found!"
    self.charterName = charterName or ""  -- no need for error text for these since they arent that important
    self.artistName = artistName or ""
    self.hovered = false
end

function SongButton:update(dt)
    if cursorX > self.x and cursorX < self.x + self.width then
        if cursorY > self.y and cursorY < self.y + self.height then
            self.hovered = true
        end
    end
    if self.hovered and Input:pressed("menuClickLeft") then
        SongButton:click()
    end
end

function SongButton:click()
    if self.hovered then
        print("o" .. "clicked")
    end
end



function SongButton:draw()
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    love.graphics.print(self.songName, self.x, self.y)
end

function SongButton:release()

end

return SongButton