local t = {}

local width = baseScreenRatio.x
local offset = {0}

function t:enter(from, to, ...)
    width = baseScreenRatio.x
    offset = {width}

    Timer.tween(0.5, offset, {0}, "in-out-cubic", function()
        State.completeTransition()
    end)
end

function t:update(dt)
end

function t:draw()
    love.graphics.push()
    love.graphics.translate(offset[1] - baseScreenRatio.x, 0)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, width, baseScreenRatio.y)
    love.graphics.pop()
end

return t
