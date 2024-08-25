---@class SongButton
local SongButton = Class:extend()

---@param songName string The song name
---@param charterName string The name of the charter
---@param artistName string  The name of the song artist
---@param id number The id of the song
function SongButton:new(songName, charterName, artistName, id)
    self.x, self.y = 0, 0
    self.width, self.height = 1000, 50
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

    if self.id == PlayingSong then 
        States.Menu.SongSelect:SwitchMenuState("Difficulty")
    else
        SelectedSong = self.id
        PlayingSong = self.id
    end
end

function SongButton:draw()
    if self.id == SelectedSong then love.graphics.setColor(0,1,1) end
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    love.graphics.setColor(0,0,0)
    love.graphics.print(self.songName, self.x, self.y)
    love.graphics.setColor(1,1,1)
end

function SongButton:release()

end

return SongButton