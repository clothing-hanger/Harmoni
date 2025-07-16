local video = Class:extend("video")

function video:new(videoPath, x, y, width, height, fr)
    self.path = videoPath
    self.visible = true
    self.x, self.y = x or 0, y or 0
    self.width, self.height = width, height
    self.checkPerFrame = fr or 60 -- checks per second
    self.checkTimer = 0

    if not DLL_Video then
        error("Video not supported on this platform")
        return
    end

    if not videoPath then
        error("Video path not provided")
        return
    end

    local filedata = love.filesystem.newFileData(videoPath)
    if not filedata then
        error("Video file not found: " .. tostring(videoPath))
        return
    end

    local vid = DLL_Video.open(filedata:getPointer(), filedata:getSize())
    if not vid then
        error("Video failed to load: " .. tostring(videoPath))
        return
    end

    self.video = vid
    self.filedata = filedata
    self.imageData = love.image.newImageData(self.video:getDimensions())
    self.image = love.graphics.newImage(self.imageData)

    self.baseWidth = self.image:getWidth()
    self.baseHeight = self.image:getHeight()

    self.playing = false
    self.time = 0

    self.angle = 0
    self.origin = {x = 0, y = 0}
    self.windowScale = {x = 1, y = 1}
    self.scale = {x = 1, y = 1}
    self.colour = {1, 1, 1}
    self.alpha = 1
    self.debug = false

    self.blendMode = "alpha"
    self.blendModeAlpha = "alphamultiply"
end

function video:update(dt)
    if self.playing and self.video then
        self.checkTimer = self.checkTimer + dt
        local interval = 1 / self.checkPerFrame

        if self.checkTimer >= interval then
            self.checkTimer = self.checkTimer - interval
            if tryExcept then
                tryExcept(function()
                    while self.time >= self.video:tell() do
                        if not self.video:read(self.imageData:getPointer()) then
                            self.playing = false
                            break
                        end
                    end
                    self.image:replacePixels(self.imageData)
                end)
            else
                while self.time >= self.video:tell() do
                    if not self.video:read(self.imageData:getPointer()) then
                        self.playing = false
                        break
                    end
                end
                self.image:replacePixels(self.imageData)
            end
        end

        self.time = self.time + dt
    end
end

function video:play()
    if not self.playing and self.video then
        self.playing = true
    end
end

function video:pause()
    self.playing = false
end

function video:seek(time)
    if self.video then
        self.video:seek(time)
        self.time = time or 0
    end
end

function video:draw()
    if not self.video or not self.visible or not self.image then return end

    love.graphics.push()
    love.graphics.setBlendMode(self.blendMode, self.blendModeAlpha)
    love.graphics.setColor(self.colour[1], self.colour[2], self.colour[3], self.alpha)

    local sx = (self.width or baseScreenRatio.x) / self.image:getWidth()
    local sy = (self.height or baseScreenRatio.y) / self.image:getHeight()
    local ox, oy = self.image:getWidth() / 2, self.image:getHeight() / 2

    if not dontShowBG then
        love.graphics.draw(self.image, self.x, self.y, math.rad(self.angle), sx, sy, ox, oy)
    end

    love.graphics.pop()
end

return video
