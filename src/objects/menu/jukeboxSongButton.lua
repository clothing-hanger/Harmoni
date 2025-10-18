local jukeboxSongButton = Class:extend("jukeboxSongButton")

function jukeboxSongButton:new(x,y,width,height,name,artist,audio,path)
    self.x,self.y,self.width,self.height,self.name,self.artist,self.audio,self.path = x,y,width,height,name,artist,audio,path
    print("PATH", self.path)
end

function jukeboxSongButton:update(dt)

end

function jukeboxSongButton:onClick()
    return {name = self.name, audio = self.audio, artist = self.artist, path = self.path}
end

function jukeboxSongButton:draw()
    local font = SkinHandler:getFont("Menu", 50)
    love.graphics.setFont(font)
    love.graphics.rectangle("fill", self.x,self.y,self.width,self.height,20,20)
    love.graphics.setColor(0,0,0)
    local x,y = self.x+10, (self.y+self.height/2)-love.graphics.getFont():getHeight()/2
    love.graphics.printf(self.name, x,y, self.width-20, "left")
    love.graphics.setColor(1,1,1)
end

return jukeboxSongButton