local video = Class:extend("video")

function video:new(video,x,y,width,height)
    self.path = video
    self.visible = true
    self.x, self.y = x,y
    self.width, self.height = width,height
    if not DLL_Video then
        error("Video not supported on this platform") --temp until logging is added

        return self
    end

    if not video then return self, error("Video path not provided") end -- temp
    print("Loading video: " .. tostring(video))
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




    self.angle = 0  -- i guess this was handled by the sprite thingy in tit?? idk
    self.origin = {x = 0, y = 0}
    self.windowScale = {x = 1, y = 1}
    self.scale = {x = 1, y = 1}
    self.colour = {1, 1, 1}
    self.alpha = 1
    self.debug = false
    self.drawX, self.drawY = self.x, self.y
    self.blendMode = "alpha"
    self.blendModeAlpha = "alphamultiply"

end

function video:update(dt)
    if self.playing and self.video then
        self.time = self.time + dt
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
    if not self.video then return end
    if not self.visible or not self.image then return end
    love.graphics.push()
        love.graphics.setBlendMode(self.blendMode, self.blendModeAlpha)
        --love.graphics.setColor(self.colour[1], self.colour[2], self.colour[3], self.alpha)

        -- determine new scale
        local sx, sy = self.width,self.height


        love.graphics.draw(self.image, self.x, self.y, math.rad(self.angle), sx, sy)


    love.graphics.pop()
end

return video