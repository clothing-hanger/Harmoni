---@diagnostic disable: need-check-nil
local maniaReceptor = vertSprite:extend("maniaReceptor")

local laneStrings = {
    [4] = {"Left", "Down", "Up", "Right"},
    [7] = {"Left1", "Down", "Left2", "Center", "Right1", "Up", "Right2"}
}

function maniaReceptor:new(mode, lane, inputBind, x, y, parent)
    self.parent = parent
    self.lane = lane
    self.mode = mode
    self.inputBind = inputBind
    self.laneCount = tonumber(self.parent.parent.chart.meta.laneCount)
    self.laneCountString = tostring(self.laneCount) .. "K"
    self.laneString = self:getLaneString()

    self.x, self.y = x, y
    self.size = maniaNoteSize
    self.held = false
    self.debug = false

    self.imageUp = SkinHandler:getImage("Receptors", "Up", self.laneCountString, self.laneString)
    self.imageDown = SkinHandler:getImage("Receptors", "Down", self.laneCountString, self.laneString)

    vertSprite.new(self, self.x, self.y, 0)
end

function maniaReceptor:getLaneString()
    local laneList = laneStrings[self.laneCount]
    if laneList then
        return laneList[self.lane]
    else
        print("wtf")
        return "wtf"  --wtf
    end
end

function maniaReceptor:update(dt)
    self.held = Input:down(self.inputBind)
end

function maniaReceptor:draw()
    local drawnImage = self.held and self.imageDown or self.imageUp
    local arrowBatch = SkinHandler:getBatch("Arrows")
    local receptorBatch = SkinHandler:getBatch("Receptors")

    local w, h
    if drawnImage.getViewport then
        _, _, w, h = drawnImage:getViewport()
    else
        w, h = drawnImage:getWidth(), drawnImage:getHeight()
    end

    --[[ if arrowBatch then
        arrowBatch:add(drawnImage, self.x, self.y, 0, self.size / w, self.size / h, w / 2, h / 2)
    elseif receptorBatch then
        receptorBatch:add(drawnImage, self.x, self.y, 0, self.size / w, self.size / h, w / 2, h / 2)
    else
        love.graphics.draw(drawnImage, self.x, self.y, 0, self.size / w, self.size / h, w / 2, h / 2)
    end ]]
    self.scale.x = self.size / w
    self.scale.y = self.size / h
    self.origin.x = w / 2
    self.origin.y = h / 2
    self.graphic = drawnImage
    if receptorBatch then
        self.graphic = receptorBatch:getTexture()
    elseif arrowBatch then
        self.graphic = arrowBatch:getTexture()
    end
    vertSprite.setGraphic(self, self.graphic)
    local q
    if drawnImage.getViewport then
        q = drawnImage
    end
    vertSprite.draw(self, q)

    -- draw a line at the center position

    if self.debug then
        love.graphics.setColor(1, 0, 0)
        love.graphics.setLineWidth(10)
        love.graphics.line(self.x - 200, self.y, self.x + 200, self.y)
        love.graphics.setColor(1, 1, 1)
        love.graphics.setLineWidth(1)
    end
end

return maniaReceptor
