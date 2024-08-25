---@diagnostic disable: duplicate-set-field
local o_loveGraphicsRectangle = love.graphics.rectangle

rectangleCallCount = 0
function love.graphics.rectangle(...)
    rectangleCallCount = plusEq(rectangleCallCount)

    o_loveGraphicsRectangle(...)
end