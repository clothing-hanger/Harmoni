local loadingAprilFools = State("loadingAprilFools")
local msg
function loadingAprilFools:enter()


    self.images = {
        ["H"] = {image = SkinHandler:getImage("Menu", "H"), sizeX  = 1, sizeY = 1, x = 0, y = 0},
        ["logo"] = {image = SkinHandler:getImage("Menu", "Main Logo"), sizeX  = 1, sizeY = 1, x = 0, y = 0},
    }

    self.alpha = 0 
    self.squiglyLine = UIsquiglyLine(0,100,baseScreenRatio.x,100,4,5,50,1,self.width)
    self.throbbert = throbbert({{1,1,1,1}, {1,1,1,1}, {1,1,1,1}})
    self.loadingAudio = love.audio.newSource("aprilfools/sounds/loading.mp3", "stream")
    self.video = video("aprilfools/videos/loading.mp4", baseScreenRatio.x/2, baseScreenRatio.y/2, 2.7, 2.7)

    self.videoCoverAlpha = 1
    self.videoVolume = 0

    self.percent = 0
 --   self.video:play()
    self:increasePercent()
   -- self:startVideo()
end

function loadingAprilFools:update(dt)
    self.video:update(dt)
    self.loadingAudio:setVolume(self.videoVolume)

    if self.percent > 10 and not self.loadingAudio:isPlaying() then self:startVideo() end


end

function loadingAprilFools:startVideo()
    Timer.tween(20, self, {videoCoverAlpha = 0, videoVolume = 1})
    self.video:play()
    self.loadingAudio:play()

end

function loadingAprilFools:increasePercent()
    Timer.after(love.math.random(1, 3), function() 
        self.percent = self.percent + love.math.random(1,6)
        if self.percent >= 100 and not self.finished then self:done() end
        self:increasePercent()
    end)
end

function loadingAprilFools:done()
    msg = "Loaded! :3"
    self.finished = true
    Timer.tween(1, self, {alpha = 1}, "linear", function() 
        self.video = nil
        self.loadingAudio:stop()
        self.loadingAudio = nil
        State.switch(States.menu.splash)

    end)

end

function loadingAprilFools:draw()
    
    local w, h = baseScreenRatio.x, baseScreenRatio.y
    love.graphics.setColor(1,1,1,1)
        
    love.graphics.setFont(SkinHandler:getFontLegacy("Menu Extra Large"))

    if not self.finished then msg = self.percent .. "%" end

    self.video:draw()

    love.graphics.setColor(0,0,0,self.videoCoverAlpha)
    love.graphics.rectangle("fill", 0, 0, baseScreenRatio.x, baseScreenRatio.y)
    love.graphics.setColor(1,1,1,1)
    love.graphics.printf(msg, 0, h*0.5, w, "center")



    love.graphics.setLineWidth(15)
    love.graphics.setColor(1,1,1,0.10)

    


    love.graphics.setColor(1,1,1,0.85)
    

    love.graphics.setColor(1,1,1,1)

    States.menu.titleScreen.drawLogo(self)

    love.graphics.setColor(0,0,0,self.alpha)
    love.graphics.rectangle("fill", 0, 0, baseScreenRatio.x, baseScreenRatio.y)
    love.graphics.setColor(1,1,1,1)


    
end

return loadingAprilFools