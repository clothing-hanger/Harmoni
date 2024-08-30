---@diagnostic disable: duplicate-set-field
local o_loveGraphicsRectangle = love.graphics.rectangle
local o_loveGraphicsGetStats = love.graphics.getStats

local rectangleCallCount = 0
function love.graphics.rectangle(...)
    rectangleCallCount = plusEq(rectangleCallCount)

    o_loveGraphicsRectangle(...)
end

local o_loveUpdate = love.update
function love.update(dt)
    o_loveUpdate(dt)
    rectangleCallCount = 0
end

function love.graphics.getStats()
    local stats = o_loveGraphicsGetStats()
    stats.rectCalls = rectangleCallCount
    return stats
end

---See [love.graphics.print](lua://love.graphics.print)
function love.graphics.borderPrint(...)
    local args = {...}

    love.graphics.setColor(0, 0, 0)
    for x = -1, 1 do
        for y = -1, 1 do
            love.graphics.print(args[1], args[2] + x, args[3] + y, select(4, unpack(args)))
        end
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.print(...)
end

---See [love.graphics.printf](lua://love.graphics.printf)
function love.graphics.borderPrintf(...)
    local args = {...}

    love.graphics.setColor(0, 0, 0)
    for x = -1, 1 do
        for y = -1, 1 do
            love.graphics.printf(args[1], args[2] + x, args[3] + y, select(4, unpack(args)))
        end
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.printf(...)
end