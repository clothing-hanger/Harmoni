local preloadState = State("preloadState")

local t = 0
local progress = 0
local step = -10
local totalSteps = 12
local installing = false
local songDifficultiesDone = false

difficultyCalculatorVersionNumber = 1

function preloadState:enter()
    self.BG = SkinHandler:getImage("Menu", "Background")
    self.wavesY = 0
    self.debug = false
    self.skipSafetyTimer = true
    self.songList = SongListManager.getSongList(musicPath)

    States.menu.titleScreen.setUpThoseLinesThatIHate(self, 10)
    States.menu.titleScreen.setUpThoseWavesThatIHate(self, 4)
    States.menu.titleScreen.setUpThoseBubblesThatIHate(self, 20)

    self.images = {
        ["H"] = {image = SkinHandler:getImage("Menu", "H"), sizeX  = 1, sizeY = 1, x = 0, y = 0},
        ["logo"] = {image = SkinHandler:getImage("Menu", "Main Logo"), sizeX  = 1, sizeY = 1, x = 0, y = 0},
    }

    self.throbbert = throbbert({{1,1,1,1}, {1,1,1,1}, {1,1,1,1}})
    if not self.debug then CLibs:setupIfNeeded() end
end

function preloadState:update(dt)

    if self.debug then if Input:pressed("menuConfirm") then CLibs:setupIfNeeded() end end



    t = t + dt
        if step < 0 then
        if not installing then
            installing = true
            step = step + 1
        elseif installing and CLibs:isInstallationDone() then
            step = step + 1
            CLibs:after()
            Timer.after(self.skipSafetyTimer and 1 or 5, function()
                self:doDifficultyShit()
                Timer.after(0.1, function()  
                States.menu.titleScreen.bubbles = self.bubbles
                States.menu.titleScreen.wavesY = self.wavesY
                States.menu.titleScreen.squiglyLines = self.squiglyLines
                States.menu.titleScreen.layerWaves = self.layerWaves
                States.menu.titleScreen.images = self.images
                State.switch(States.menu.splash)
                if AMERICA then PATRIOTIC:play() end
                end)
        
            end)
        end
 
    else step = step + 1 end 
           -- local targetProgress = math.abs(step / totalSteps)       -- i am literally fucking guessing

        --    progress = progress + (targetProgress - math.abs(progress)) * math.min(dt * 10, 1)

end

function preloadState:doDifficultyShit()

    for i, song in ipairs(self.songList) do
        if not song then
            table.remove(self.songList, i)
            goto continue
        end
        local diffList = SongListManager.getDifficultyList(musicPath .. song)
        if not diffList[1] then
            table.remove(self.songList, i)
            goto continue
        end
        if not love.filesystem.getInfo(musicPath .. song .. "/" .. diffList[1], "file") then
            table.remove(self.songList, i)
            goto continue
        end

        -- we check for a difficuly file, if there is one, then we dont do anything, if there isnt, we create it
        for i = 1,#diffList do
            if not love.filesystem.getInfo(musicPath .. song .."/".. diffList[i] .. ".difficulty", "file") then
                -- we need to parse this chart and gets its difficulty rating
                local chart = ChartParse.harmc(musicPath .. song .."/" .. diffList[i], "generate")
                
                if chart.meta.difficulty then
                    love.filesystem.createDirectory(musicPath .. song)
                    local luaString = chart.meta.difficulty .. ":" .. difficultyCalculatorVersionNumber

                    local ok = love.filesystem.write(musicPath .. song .."/".. diffList[i] .. ".difficulty", luaString)
                    if ok then GlobalNotificationsHandler:addNotification("Difficulty Rating File created for " ..song .." " .. diffList[i], "info")
                    else GlobalNotificationsHandler:addNotification("Failed to create diff file for " ..song " " .. diffList[i], "error")
                    end
                end
            end
        end
        ::continue::
    end

    songDifficultiesDone = true
end

function preloadState:draw()
    
    local w, h = baseScreenRatio.x, baseScreenRatio.y
    love.graphics.setColor(1,1,1,1)
        
    love.graphics.setFont(SkinHandler:getFontLegacy("Menu Extra Large"))

    local msg = "loading :3"

    love.graphics.printf(msg, 0, h*0.5, w, "center")




    local barW = w * 0.5
    local barX = w/2 - barW/2
    local barY = h*0.6
    local segments = 300
    local amp = 15
    local speed = 5
    local points = {}

    local lastLineWidth = love.graphics.getLineWidth()
    love.graphics.setLineWidth(15)
    love.graphics.setColor(1,1,1,0.10)
    local lastX, lastY


    points = {}
    love.graphics.setColor(1,1,1,0.85)
    lastX, lastY = nil, nil
    
    for i = 0, segments * progress do
        local x = barX + (i/segments)*barW
        local y = barY + math.sin((i/segments)*math.pi*15 + t*speed) * amp

        points[#points+1] = lastX or x
        points[#points+1] = lastY or y
        points[#points+1] = x
        points[#points+1] = y
        lastX, lastY = x, y
    end
    
    if #points > 2 then
     love.graphics.line(points)
    end

    local r = 6
    for i = 1, 6 do
        local angle = (i/6)*math.pi*2
        local pulse = math.sin(t*4 + i)*2
        local cx = w/2 + math.cos(angle)*(20 + pulse)
        local cy = h*0.7 + math.sin(angle)*(20 + pulse)
        love.graphics.setColor(1,1,1,0.2 + (pulse/4))
        love.graphics.circle("fill", cx, cy, r + pulse)
    end

    love.graphics.setColor(1,1,1,1)

    States.menu.titleScreen.drawLogo(self)
    --self.throbbert:draw()
    
end

return preloadState