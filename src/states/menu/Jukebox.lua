local jukebox = State("jukebox")

function jukebox:enter(parent)
    self.parent = parent
        self.background = self.parent.BG

        GlobalNotificationsHandler:addNotification("HII!")

    local lyrics = require("test.Slapstick.lyrics")
    self.audio = love.audio.newSource("test/Slapstick/Audio.mp3", "stream")

    self.lyricsDisplay = lyricsDisplay(baseScreenRatio.x-800,0,800,baseScreenRatio.y,lyrics)
    self.audio:play()
end

function jukebox:update(dt)
    self.lyricsDisplay:update(dt, self.audio:tell("seconds"))
end

function jukebox:draw()
    love.graphics.draw(self.background)
    self.lyricsDisplay:draw()
end

return jukebox