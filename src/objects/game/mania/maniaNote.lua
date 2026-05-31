local maniaNote = vertSprite:extend("maniaNote")

local fourkLanes = { "Left", "Down", "Up", "Right" }
local sevenkLanes = { "Left1", "Down", "Left2", "Center", "Right1", "Up", "Right2" }

local stealthShader = love.graphics.newShader [[
uniform Image MainTex;
uniform float white;
uniform float opacity;
void effect() {
    // this time NO xyz, its just normal 
    vec4 col = Texel(MainTex, VaryingTexCoord.xy) * VaryingColor;
    col.rgb = mix(col.rgb, vec3(1.0), white);
    col.a *= opacity;
    love_PixelColor = col;
}
]]

function maniaNote:new(startTime, endTime, lane, mode, initialSVTime, initialSVEndTime, parent)
    self.size = maniaNoteSize
    self.startTime = startTime
    self.endTime = endTime or startTime
    self.lane = lane
    self.mode = mode
    self.parent = parent

    self.laneCount = tonumber(self.parent.parent.chart.meta.laneCount) or 4
    self.laneCountString = tostring(self.laneCount) .. "K"
    self.laneString = self:getLaneString()

    self.image = SkinHandler:getImage("Notes", self.laneCountString, self.laneString)

    self.x = maniaLanePositions[self.laneCountString][self.lane]
    self.y = self.startTime + (MusicTime or 0)
    self.endY = self.endTime + (MusicTime or 0)

    self.initialSVTime = initialSVTime
    self.initialSVEndTime = initialSVEndTime

    if self.endTime <= self.startTime then
        self.holdLength = nil
    else
        self.holdLength = self.endTime - self.startTime
    end

    if self.holdLength then
        self.endTime = self.startTime + self.holdLength
        self.holdAsset = SkinHandler:getImage("HoldNotes", self.laneCountString, self.laneString)
        self.holdEndAsset = SkinHandler:getImage("HoldEndNotes", self.laneCountString, self.laneString)

        self.holdPixelHeight = 1
        self.endY = self.startTime + self.holdLength + (MusicTime or 0)
    end


    self.gameOverX, self.gameOverY = 0,0
    self.rotation = 0
    self.gameOverBool = false
    self.held = false
    self.released = false

    self.debug = false

    vertSprite.new(self, self.x, self.y, 0)
end

function maniaNote:getLaneString()
    if self.laneCount == 4 then
        return fourkLanes[self.lane]
    elseif self.laneCount == 7 then
        return sevenkLanes[self.lane]
    else
        return nil
    end
end

function maniaNote:update(dt)
    self:updatePosition()
end

function maniaNote:updatePosition()
    self.y = self:getNotePosition(self.initialSVTime, not self.held) + self.gameOverY
    if self.holdLength then
        self.endY = self:getNotePosition(self.initialSVEndTime, true)
    end

end

local function msToMulti(speed)
    return baseScreenRatio.y / speed
end

function maniaNote:getNotePosition(time, moveWithScroll)
    self.moveWithScroll = moveWithScroll
    local scrollDir = Settings:getValue("Game", "Mania", "Scroll Direction")
    if States.game.gameModeManager.gameMode.ableToModscript then scrollDir = "Up" end
    local scrollSpeed = Settings:getValue("Game", "Mania", "Scroll Speed")
    local multiplier = msToMulti(scrollSpeed)
    local sfMult = self.parent.parent:getScrollSpeedFactorFromTime(self.parent.parent.currentTime)
    local currentTime = self.parent.parent.currentTime

    if moveWithScroll then
        local offset = (time - currentTime) * multiplier * sfMult + self.gameOverY
        if scrollDir == "Up" then
            return self.parent.y + offset
        else
            return self.parent.y - offset
        end
    else
        return self.parent.y - 35
    end
end

function maniaNote:gameOver()
    self.gameOverBool = true

    local shit = 100


    Timer.tween(
        love.math.random(0.4,0.6),
        self,
        {x = self.x+love.math.random(-shit,shit), gameOverY = love.math.random(-shit,shit)},
        "out-quad"
    )
end

function maniaNote:hit()
    print("Note hit at time: ", self.startTime)
end

function maniaNote:release()
    print("Note released at time: ", self.startTime)
end

function maniaNote:draw()
    local arrowBatch = SkinHandler:getBatch("Arrows")
    local noteBatch = SkinHandler:getBatch("Notes")
    local scrollDir = Settings:getValue("Game", "Mania", "Scroll Direction")

    local canBatch = not States.game.gameModeManager.gameMode.ableToModscript
    local curBatch = arrowBatch or noteBatch

    if canBatch and curBatch then
        if self.holdLength and self.holdAsset and self.holdAsset.getViewport then
            local _, _, hw, hh = self.holdAsset:getViewport()
            local _, _, tailW, tailH = self.holdEndAsset:getViewport()

            local noteY = self.y
            if scrollDir == "Up" then
                noteY = noteY - 70
            else
                noteY = noteY + 70
            end

            local midY = (noteY + self.endY) / 2
            local bodyHeight = math.abs(self.endY - noteY)
            bodyHeight = bodyHeight - tailH / 2

            local passed = (
                (scrollDir == "Down" and midY > self.parent.y)
                or
                (scrollDir == "Up" and midY < self.parent.y)
            )

            if not passed then
                curBatch:add(
                    self.holdAsset,
                    self.x,
                    midY,
                    0,
                    self.size / hw,
                    bodyHeight / hh,
                    hw / 2,
                    hh / 2
                )

                local flipsY = scrollDir == "Down"

                curBatch:add(
                    self.holdEndAsset,
                    self.x,
                    self.endY,
                    0,
                    self.size / tailW,
                    (self.size / tailH) * (flipsY and -1 or 1),
                    tailW / 2,
                    tailH / 2
                )
            end
        end

        if self.image and self.image.getViewport then
            local _, _, w, h = self.image:getViewport()

            curBatch:add(
                self.image,
                self.x + self.gameOverX,
                self.y + self.gameOverY,
                0,
                self.size / w,
                self.size / h,
                w / 2,
                h / 2
            )
        end

        if self.debug then
            love.graphics.setColor(1, 0, 0)
            love.graphics.setLineWidth(2)
            love.graphics.line(self.x - 200, self.y, self.x + 200, self.y)
            love.graphics.setColor(1, 1, 1)
            love.graphics.setLineWidth(1)
        end

        return
    end

    local ogX, ogY = self.x, self.y
    local graphic

    if arrowBatch then
        graphic = arrowBatch:getTexture()
    elseif noteBatch then
        graphic = noteBatch:getTexture()
    else
        graphic = self.holdAsset
    end

    love.graphics.setColor(1, 1, 1, self.alpha * self.stealthOpacity)

    if self.holdLength then
        local _, _, hw, hh = self.holdAsset:getViewport()
        local _, _, tailW, tailH = self.holdEndAsset:getViewport()

        if scrollDir == "Up" then
            ogY = ogY - 70
        else
            ogY = ogY + 70
        end

        local midY = (self.y + self.endY) / 2
        local bodyHeight = math.abs(self.endY - self.y)
        bodyHeight = bodyHeight - tailH / 2

        local passed = (
            scrollDir == "Down" and midY > self.parent.y
            or
            scrollDir == "Up" and midY < self.parent.y
        )

        if not passed then
            local lastShader = love.graphics.getShader()

            love.graphics.setShader(stealthShader)
            stealthShader:send("white", self.stealthWhite)

            love.graphics.draw(
                graphic,
                self.holdAsset,
                self.x,
                midY,
                0,
                self.size / hw,
                bodyHeight / hh,
                hw / 2,
                hh / 2
            )

            local flipsY = scrollDir == "Down"

            love.graphics.draw(
                graphic,
                self.holdEndAsset,
                self.x,
                self.endY,
                0,
                self.size / tailW,
                (self.size / tailH) * (flipsY and -1 or 1),
                tailW / 2,
                tailH / 2
            )

            love.graphics.setShader(lastShader)
        end

        if scrollDir == "Up" then
            ogY = ogY + 70
        else
            ogY = ogY - 70
        end
    end

    local _, _, w, h = self.image:getViewport()

    self.scale.x = self.size / w
    self.scale.y = self.size / h
    self.origin.x = w / 2
    self.origin.y = h / 2

    local q
    if self.image.getViewport then
        q = self.image
    end

    vertSprite.setGraphic(self, graphic)
    vertSprite.draw(self, q)

    self.x = ogX
    self.y = ogY

    if self.debug then
        love.graphics.setColor(1, 0, 0)
        love.graphics.setLineWidth(2)
        love.graphics.line(self.x - 200, self.y, self.x + 200, self.y)
        love.graphics.setColor(1, 1, 1)
        love.graphics.setLineWidth(1)
    end
end

return maniaNote
