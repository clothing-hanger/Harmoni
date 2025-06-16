local maniaReceptor = Class:extend("maniaReceptor")

local fourkLanes = {"Left", "Down", "Up", "Right"}
local sevenkLanes = {"Left1", "Down", "Left2", "Center", "Right1", "Up", "Right2"}

local laneStrings = {
    {"Left", "Down", "Up", "Right"},
    {"Left1", "Down", "Left2", "Center", "Right1", "Up", "Right2"}
}

function maniaReceptor:new(lane, input, parent)
    self.parent = parent
    self.lane = lane
    self.inputBind = input
    self.laneCount = self.parent.parent.chart.meta.laneCount  -- horrid, awful, disgusting, terrible, gross, icky, bad, i ran out of synonyms but i hate this
    self.laneString = self:getLaneString()
    self.imageUp = Skin.Receptors.Up[self.laneString]
    self.imageDown = Skin.Receptors.Down[self.laneString]

    self.size = maniaNoteSize
    self.held = false
end

function maniaReceptor:getLaneString()
    local string
    local laneCount = tostring(self.laneCount) -- idfk if this is a number or string but im too lazy to find out
    for i = 1,#laneStrings do
        if laneCount == #laneStrings[i] then
            string = laneString[i][self.lane]  -- remember to replace the version of this in maniaNote with this this is so much better
        end
    end
    return string
end

function maniaReceptor:update(dt)
    self.held = Input:down(self.inputBind)
end

function maniaReceptor:draw()
    local drawnImage = (self.held and self.imageDown) or self.imageUp
    love.graphics.draw(drawnImage, self.x, self.y, nil, self.size/drawnImage:getWidth(), self.size/drawnImage:getHeight(), drawnImage:getWidth()/2, drawnImage:getHeight()/2)
end

return maniaReceptor