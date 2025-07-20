local t = {}

local height = baseScreenRatio.y
local offset = {0}

function t:enter(from, to, ...)
    offset = {0}
    Timer.tween(0.5, offset, {-height}, "in-out-cubic", function()
        State.completeTransition()
    end)
end

function t:update(dt) end

function t:draw()
    love.graphics.push()
    love.graphics.translate(0, offset[1])
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 0, 0, baseScreenRatio.x, height)
    love.graphics.pop()
end

return t
