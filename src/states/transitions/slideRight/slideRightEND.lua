local t = {}

local width = baseScreenRatio.x
local offset = {width}

function t:enter(from, to, ...)
    offset = {0}
    Timer.tween(0.5, offset, {width}, "in-out-cubic", function()
        State.completeTransition()
    end)
end

function t:update(dt) end

function t:draw()
    love.graphics.push()
    love.graphics.translate(offset[1], 0)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, width, baseScreenRatio.y)
    love.graphics.pop()
end

return t
