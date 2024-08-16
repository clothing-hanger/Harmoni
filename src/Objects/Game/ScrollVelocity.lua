local ScrollVelocity = Class:extend()

function ScrollVelocity:new(StartTime, Multiplier)
    local Multiplier = Multiplier or 0

    self.Multiplier = Multiplier
    self.StartTime = StartTime
end

return ScrollVelocity