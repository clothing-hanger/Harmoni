---Basically value = value + 1, but small
---@param value number
---@return number
function plusEq(value)
    return value + 1
end

---Basically value = value - 1, but small
---@param value number
---@return number
function minusEq(value)
    return value - 1
end

---Clamps a value between the min and max value given
---@param value number
---@param min number
---@param max number
---@return number
function clamp(value, min, max)
    return math.max(min, math.min(value, max))
end

---Scales a sinewave between 0.8-1.2
---@param t number The number
---@return number
function scaledSineWave(t)
    -- Sine wave oscillates between -1 and 1
    local sineValue = math.sin(t)
    -- Scale it to oscillate between 0.8 and 1.2
    local scaledValue = 1 + 0.2 * sineValue
    return scaledValue
end