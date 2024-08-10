function plusEq(value)
    return value + 1
end

function minusEq(value)
    return value - 1
end

function clamp(value, min, max)
    return math.max(min, math.min(max, value))
end
