local mania = Class:extend("mania")

function mania:new(chart)
    mania:setUpChart(chart)
    self.laneSpacing = 30
    self.laneYOffset = 30
    self.lanes = {}
    for i = 1,4 do
        table.insert(self.lanes, maniaLane(i, self.laneSpacing, self.laneYOffset))
    end
end

function mania:setUpChart(chart)
    harmcParse(chart)
end

function mania:update(dt)
end

function mania:draw()
    for i,Lane in ipairs(self.lanes) do
        Lane:draw()
    end
end

return mania