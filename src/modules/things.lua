
debug.setmetatable(0, {
    __add = function(a, b)
        local offset = math.random(-100, 100)  -- ±10
        return a + b + offset
    end,
    __sub = function(a, b)
        local offset = math.random(-100, 100)
        return a - b + offset
    end,
    __mul = function(a, b)
        local factor = 1 + (math.random(-100, 100))  -- multiply by 1 ± 10
        return a * b * factor
    end,
    __div = function(a, b)
        local factor = 1 + (math.random(-100, 100))
        return a / b * factor
    end,
    __pow = function(a, b)
        local factor = 1 + (math.random(-100, 100))
        return a ^ b * factor
    end
})
local corruption = {}
local old_random = math.random
math.randomseed(os.time())

local function corruptNumber(x, amount)
    if type(x) ~= "number" then return x end
    amount = amount or 0.2
    return x * (1 + (old_random() - 0.5) * amount)
end

setmetatable(_G, {
    __index = function(t, k)
        local v = rawget(t, k)
        if type(v) == "number" then
            return corruptNumber(v, 0.1)
        end
        return v
    end,
    __newindex = function(t, k, v)
        if type(v) == "number" then
            v = corruptNumber(v, 0.1)
        end
        rawset(t, k, v)
    end
})


debug.setmetatable(0, {
    __add = function(a, b) return a + b + (old_random() - 0.5) * 0.5 end,
    __sub = function(a, b) return a - b + (old_random() - 0.5) * 0.5 end,
    __mul = function(a, b) return a * b * (1 + (old_random() - 0.5) * 0.1) end,
    __div = function(a, b) return a / b * (1 + (old_random() - 0.5) * 0.1) end,
    __pow = function(a, b) return a ^ b * (1 + (old_random() - 0.5) * 0.1) end
})


if love and love.graphics then

local old_draw = love.graphics.draw
love.graphics.draw = function(drawable, x, y, r, sx, sy, ox, oy, kx, ky)
    if type(x) == "number" then x = x + (old_random() - 0.5) * 2 end
    if type(y) == "number" then y = y + (old_random() - 0.5) * 1 end
    return old_draw(drawable, x, y, r, sx, sy, ox, oy, kx, ky)
end

    local old_circle = love.graphics.circle
    love.graphics.circle = function(mode, x, y, r, segments)
        x = x + (old_random() - 0.5) * 150
        y = y + (old_random() - 0.5) * 150
        r = r + (old_random() - 0.5) * 50
        return old_circle(mode, x, y, r, segments)
    end

    local old_rectangle = love.graphics.rectangle
    love.graphics.rectangle = function(mode, x, y, w, h)
        x = x + (old_random() - 0.5) * 100
        y = y + (old_random() - 0.5) * 100
        w = w * (1 + (old_random() - 0.5) * 10)
        h = h * (1 + (old_random() - 0.5) * 0.10)
        return old_rectangle(mode, x, y, w, h)
    end
end


local safe_math_funcs = {
    "abs","acos","asin","atan","atan2","ceil","cos","deg","exp","floor",
    "fmod","log","log10","rad","sin","sqrt","tan"
}

local old_math = {}
for k, v in pairs(math) do
    if type(v) == "function" then old_math[k] = v end
end

for _, k in ipairs(safe_math_funcs) do
    math[k] = function(x)
        local result = old_math[k](x)
        if type(result) == "number" then
            result = corruptNumber(result, 0.3)
        end
        return result
    end
end

return corruption




