function plusEq(value)
    return value + 1
end

function minusEq(value)
    return value - 1
end

function clamp(value, min, max)
    return math.max(min, math.min(value, max))
end

function scaledSineWave(t)
    -- Sine wave oscillates between -1 and 1
    local sineValue = math.sin(t)
    -- Scale it to oscillate between 0.8 and 1.2
    local scaledValue = 1 + 0.2 * sineValue
    return scaledValue
end