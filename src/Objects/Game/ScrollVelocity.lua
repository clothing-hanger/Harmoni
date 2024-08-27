---@class ScrollVelocity
local ScrollVelocity = Class:extend()

---@param StartTime number
---@param Multiplier? number
function ScrollVelocity:new(StartTime, Multiplier)
    self.Multiplier = Multiplier or 0
    self.StartTime = StartTime
end

return ScrollVelocity