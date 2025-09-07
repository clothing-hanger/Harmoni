local video = Class:extend("video")

function video:new(video,x,y,scaleX,scaleY,fr)
    self.path = video
    self.visible = true
    self.x, self.y = x,y
    self.scaleX, self.scaleY = scaleX or 1,scaleY or 1
    self.checkPerFrame = fr or 60 -- only <num> checks per second
    self.checkTimer = 0
    if not DLL_Video then
        error("Video not supported on this platform") --temp until logging is added

        return self
    end

    if not video then return self, error("Video path not provided") end -- temp
   printToConsole("Loading video: " .. tostring(video))
    video = love.filesystem.newFileData(video)
    if not video then return self, error("Video file not found") end -- again, temp
    local vid = DLL_Video.open(video:getPointer(), video:getSize())
    if not vid then return self, error("Video not loaded") end -- yet again

    self.video = vid
    self.filedata = video
    self.imageData = love.image.newImageData(self.video:getDimensions())
    self.image = love.graphics.newImage(self.imageData)

    self.baseWidth = self.image:getWidth()
    self.baseHeight = self.image:getHeight()

    self.playing = false
    self.time = 0
    self.previousFrameTime = 0

    self.angle = 0  -- i guess this was handled by the sprite thingy in rit?? idk
    self.origin = {x = 0, y = 0}
    self.windowScale = {x = 1, y = 1}
    self.scale = {x = 1, y = 1}
    self.colour = {1, 1, 1}
    self.alpha = 1
    self.debug = true
    self.drawX, self.drawY = self.x, self.y
    self.blendMode = "alpha"
    self.blendModeAlpha = "alphamultiply"

end

function video:update(dt)

    if self.playing and self.video then
        self.checkTimer = self.checkTimer + dt
        local interval = 1 / self.checkPerFrame
        if self.checkTimer >= interval then
            self.checkTimer = self.checkTimer - interval
            tryExcept(function()
                while self.time >= self.video:tell() do
                    if not self.video:read(self.imageData:getPointer()) then
                        self.playing = false
                        break
                    end
                end
                self.image:replacePixels(self.imageData)
            end)
            self.previousFrameTime = love.timer.getTime()
        end
        self.time = self.time + dt
    end
end

function video:play()
    if not self.playing and self.video then
        self.playing = true
        self.previousFrameTime = love.timer.getTime()
    end
end

function video:pause()
    if self.playing then
        self.playing = false
    end
end

function video:seek(time)
    if self.video then
        self.video:seek(time)
        self.time = time
        self.previousFrameTime = love.timer.getTime()
    end
end

function video:draw()
    if not self.video or not self.visible or not self.image then return end
   printToConsole("hiiii")

    love.graphics.push()
        love.graphics.setBlendMode(self.blendMode, self.blendModeAlpha)
        local sx = (baseScreenRatio.x / self.image:getWidth()) * self.scaleX
        local sy = (baseScreenRatio.y / self.image:getHeight()) * self.scaleY
        local ox, oy = self.image:getWidth() / 2, self.image:getHeight() / 2
        local dontShowBG = false

        if not dontShowBG then love.graphics.draw(self.image, self.x, self.y, math.rad(self.angle), sx, sy, ox, oy) end


    love.graphics.pop()
end

return video